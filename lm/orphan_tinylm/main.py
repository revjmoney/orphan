"""[orphan] Orphan TinyLM: "Retired silicon writes stories". A 15M-parameter Llama (Karpathy's stories15M, MIT)
with every matrix product on the S9 control board's FPGA (64 lanes: 4 stories per weight pass), a story page on
port 8000 with three modes: Write (one story), 4 Stories (four at once), Adventure (4 takes per chapter, you pick).
Roots: the DDR streaming is Ardzy's AI Studio engine (project 19, by chryso, GPL-3.0); the model and tokenizer are
llama2.c's (Andrej Karpathy, MIT). by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import http.server
import json
import os
import threading
import time

import numpy as np

import tlm_batch
import tlm_board
from tinylm import Tokenizer

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = 8000
TAKE_MAX = 70                                  # tokens per take (a chapter); a take ends early at a blank line
MODELS = tlm_batch.load_models(HERE)                # stories15M (fast), stories42M (better): both in DDR at once
eng = tlm_batch.Engine4(MODELS)
tok = Tokenizer(os.path.join(HERE, 'model', 'tokenizer.bin'), eng.m.vocab)
runners = {}


def use(name):
    """Switch the engine and the runner to another model (instant: every model already sits in DDR)."""
    global model, run
    eng.select(name)
    model = eng.m
    if name not in runners:
        runners[name] = tlm_batch.Runner4(model, eng)
    run = runners[name]
    S['model'] = name


model = run = None
arm = None
lock = threading.Lock()
S = {'mode': 'idle', 'running': False, 'slots': ['', '', '', ''], 'done': [False] * 4, 'tokens': 0, 'seconds': 0.0,
     'story': '', 'chapters': [], 'takes': [], 'race': None, 'error': '', 'stop': False,
     'model': '', 'models': list(MODELS)}
adv = {'ids': [], 'pos': 0, 'take_ids': [[], [], [], []], 'take_pos': [0] * 4}


def self_check():
    """FPGA (16-bit results) vs the same math in numpy on the ARM, for a few matrices and 4 random vectors."""
    rng = np.random.default_rng(7)
    for key in ('wq.0', 'w2.5', 'cls.0'):
        name, L = key.split('.')
        pos, rows, cols = model.table[key]
        G, n = rows // 16, rows // 16 * cols * 8
        a = np.stack([model.port0[pos:pos + n].view(np.int8).reshape(G, cols, 8),
                      model.port1[pos:pos + n].view(np.int8).reshape(G, cols, 8)], axis=1)
        W = a.transpose(0, 1, 3, 2).reshape(rows, cols).astype(np.int64)
        X = rng.standard_normal((4, cols)).astype(np.float32)
        got = eng.batch(name, int(L), X)
        sh, worst = eng.shifts[key], 0.0
        for b in range(4):
            x8, sx = tlm_board.quantize_vec(X[b])
            acc = W @ x8.astype(np.int64)
            want = (np.clip(acc >> sh, -32768, 32767) << sh).astype(np.float32) * model.scales[key] * sx
            worst = max(worst, float(np.abs(got[b] - want).max()))
        print('self-check %-6s 4 stories, FPGA vs ARM: max diff %g %s' % (key, worst, 'OK' if worst == 0 else 'MISMATCH'),
              flush=True)


def generate(prompts, temps, steps, on_tok, stop_at_blank=False):
    """Run up to 4 slots from their prompts; on_tok(b, piece) per new token. Returns (ids per slot, pos per slot)."""
    n = len(prompts)
    rngs = [np.random.default_rng() for _ in range(n)]
    ids = [tok.encode(p) for p in prompts]
    cur = [i[0] for i in ids]
    pos = [0] * n
    done = [False] * n
    made = [0] * n
    out_ids = [list(i[:1]) for i in ids]
    t0 = time.perf_counter()
    while not all(done) and not S['stop']:
        logits = run.step(cur, pos)
        for b in range(n):
            if done[b]:
                continue
            p = pos[b] + 1
            if p < len(ids[b]):
                nxt = ids[b][p]                                   # still reading the prompt
            else:
                nxt = tlm_batch.fast_sample(logits[b], temps[b], rngs[b])
                made[b] += 1
            if nxt == 1 or p >= model.seq - 1 or made[b] >= steps:
                done[b] = True
                continue
            piece = tok.decode(cur[b], nxt)
            on_tok(b, piece)
            out_ids[b].append(nxt)
            cur[b], pos[b] = nxt, p
            if stop_at_blank and made[b] > 20 and '\n' in piece:
                done[b] = True
        with lock:
            S['tokens'] = sum(made)
            S['seconds'] = time.perf_counter() - t0
            S['done'] = done + [True] * (4 - n)
    return out_ids, pos


def piece_to(slot):
    def f(b, piece):
        with lock:
            S['slots'][b if slot is None else slot] += piece
    return f


def job(fn):
    def go():
        try:
            fn()
        except Exception as e:  # noqa: BLE001
            import traceback
            traceback.print_exc()
            with lock:
                S['error'] = str(e)
        finally:
            with lock:
                S['running'] = False
    threading.Thread(target=go, daemon=True).start()


def adventure_takes():
    """4 takes of the next chapter from the story so far (its KV cache is already in slot 0)."""
    with lock:
        S['takes'], S['slots'] = [], ['', '', '', '']
    base_pos, last = adv['pos'], adv['ids'][-1]
    cur, pos = [last] * 4, [base_pos] * 4
    rngs = [np.random.default_rng() for _ in range(4)]
    done, made, tids = [False] * 4, [0] * 4, [[] for _ in range(4)]
    t0 = time.perf_counter()
    while not all(done) and not S['stop']:
        logits = run.step(cur, pos)
        for b in range(4):
            if done[b]:
                continue
            nxt = tlm_batch.fast_sample(logits[b], 0.9, rngs[b])
            if nxt == 1 or pos[b] + 1 >= model.seq - 1:
                done[b] = True
                continue
            piece = tok.decode(cur[b], nxt)
            made[b] += 1
            with lock:
                S['slots'][b] += piece
            tids[b].append(nxt)
            cur[b], pos[b] = nxt, pos[b] + 1
            if made[b] >= TAKE_MAX or (made[b] > 20 and '\n' in piece):
                done[b] = True
        with lock:
            S['tokens'], S['seconds'] = sum(made), time.perf_counter() - t0
    adv['take_ids'], adv['take_pos'] = tids, pos
    with lock:
        S['takes'] = list(S['slots'])


def adventure_start(prompt):
    """Read the opening into slot 0, copy it to all 4 slots, write 4 takes of chapter 1."""
    ids = tok.encode(prompt)
    for p in range(len(ids) - 1):
        run.step([ids[p]], [p])
    run.copy_slot(0, len(ids))
    adv['ids'], adv['pos'] = ids, len(ids) - 1
    with lock:
        S['story'], S['chapters'] = prompt, [prompt]
    adventure_takes()


def adventure_pick(i):
    """Keep take i: it becomes the next chapter; its cache goes to every slot; then 4 takes of the next one."""
    take, tids, tpos = S['takes'][i], adv['take_ids'][i], adv['take_pos'][i]
    with lock:
        S['story'] += take
        S['chapters'].append(take)
    adv['ids'] += tids
    if tpos > model.seq - TAKE_MAX - 10:                          # memory nearly full: keep the recent story
        keep = adv['ids'][-120:]
        ids = [1] + keep
        for p in range(len(ids) - 1):
            run.step([ids[p]], [p])
        run.copy_slot(0, len(ids))
        adv['ids'], adv['pos'] = ids, len(ids) - 1
    else:
        run.copy_slot(i, tpos + 1)
        adv['pos'] = tpos
        if i != 0:
            run.kc[0], run.vc[0] = run.kc[i], run.vc[i]
    adventure_takes()


class Handler(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def send(self, code, body, kind='application/json'):
        b = body if isinstance(body, bytes) else json.dumps(body).encode()
        self.send_response(code)
        self.send_header('Content-Type', kind)
        self.send_header('Content-Length', str(len(b)))
        self.end_headers()
        self.wfile.write(b)

    def do_GET(self):
        if self.path.startswith('/api/status'):
            with lock:
                s = dict(S)
            s['tps'] = round(s['tokens'] / s['seconds'], 1) if s['seconds'] else 0
            s['fpga_ms'] = round(eng.fpga_s * 1000 / max(1, eng.calls) * 43, 1) if eng.calls else 0
            try:
                s['temp'] = round(int(open('/sys/bus/iio/devices/iio:device0/in_temp0_raw').read()) * 503.975 / 4096 - 273.15, 1)
            except (OSError, ValueError):
                s['temp'] = None
            return self.send(200, s)
        return self.send(200, open(os.path.join(HERE, 'index.html'), 'rb').read(), 'text/html; charset=utf-8')

    def do_POST(self):
        try:
            d = json.loads(self.rfile.read(int(self.headers.get('Content-Length', 0))) or b'{}')
            a = d.get('action')
            if a == 'stop':
                S['stop'] = True
                return self.send(200, {'ok': True})
            with lock:
                if S['running']:
                    return self.send(409, {'error': 'still writing; press Stop first'})
                S.update(running=True, stop=False, error='', tokens=0, seconds=0.0, slots=['', '', '', ''], race=None)
            eng.fpga_s, eng.calls = 0.0, 0
            prompt = str(d.get('prompt', 'Once upon a time'))[:300]
            temp = max(0.0, min(1.5, float(d.get('temp', 0.8))))
            steps = max(8, min(250, int(d.get('steps', 200))))
            if a == 'write':
                S['mode'] = 'write'
                job(lambda: generate([prompt], [temp], steps, piece_to(0)))
            elif a == 'four':
                S['mode'] = 'four'
                job(lambda: generate([prompt] * 4, [max(temp, 0.6)] * 4, steps, piece_to(None)))
            elif a == 'adventure':
                S['mode'] = 'adventure'
                job(lambda: adventure_start(prompt))
            elif a == 'pick':
                i = int(d.get('take', 0))
                if S['mode'] != 'adventure' or not (0 <= i < len(S['takes'])):
                    S['running'] = False
                    return self.send(400, {'error': 'no take to pick'})
                job(lambda: adventure_pick(i))
            elif a == 'model':
                name = str(d.get('model', ''))
                S['running'] = False
                if name not in MODELS:
                    return self.send(400, {'error': 'no model %r' % name})
                use(name)
                S.update(mode='idle', story='', chapters=[], takes=[])
                return self.send(200, {'ok': True, 'model': name})
            elif a == 'race':
                S['mode'] = 'race'

                def race():
                    global arm
                    S['race'] = {}
                    t0 = time.perf_counter()
                    generate([prompt], [0.0], 60, piece_to(0))
                    S['race']['fpga1'] = round(60 / (time.perf_counter() - t0), 1)
                    S['slots'] = ['', '', '', '']
                    t0 = time.perf_counter()
                    generate([prompt] * 4, [0.8] * 4, 60, piece_to(None))
                    S['race']['fpga4'] = round(240 / (time.perf_counter() - t0), 1)
                    if S['model'] != 'stories15M':          # a float copy of a bigger model does not fit the RAM
                        S['race']['arm'] = 0
                        return
                    if arm is None:
                        arm = tlm_board.ArmInt8(model)
                    from tinylm import Runner
                    r, ids, t0 = Runner(model, arm), tok.encode(prompt), time.perf_counter()
                    cur = ids[0]
                    for p in range(60):
                        lg = r.step(cur, p)
                        cur = ids[p + 1] if p + 1 < len(ids) else int(np.argmax(lg))
                    S['race']['arm'] = round(60 / (time.perf_counter() - t0), 1)
                job(race)
            else:
                S['running'] = False
                return self.send(400, {'error': 'unknown action'})
            self.send(200, {'ok': True})
        except Exception as e:  # noqa: BLE001
            S['running'] = False
            self.send(400, {'error': str(e)})


for _n in MODELS:
    use(_n)
    print('== %s: dim %d, %d layers, story memory %d tokens' % (_n, model.dim, model.layers, model.ctx), flush=True)
    self_check()
for _n, (_m, _) in MODELS.items():                  # the FPGA reads the DDR store: free the program's copies
    if _n != 'stories15M':                           # (15M keeps them for the ARM-alone race)
        _m.port0 = _m.port1 = None
use(next(iter(MODELS)))
print('[orphan] Orphan TinyLM | Retired silicon writes stories | 4 stories per FPGA pass | port %d' % PORT, flush=True)
http.server.ThreadingHTTPServer(('0.0.0.0', PORT), Handler).serve_forever()
