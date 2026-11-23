"""Give Ardzy's board web page (/opt/ardzy/web/index.html) the Orphan look, with an "Ardzy inside" credit.
    python3 brand-ardzy-web.py <ardzy index.html> <out index.html>
The look and layout follow the Orphan KAS miner page (dark, lime, mono, big metric tiles, 3 columns), without its
animations. Ardzy's own script is kept as it is; only the styles and the markup around it change (every element id
its script uses is kept). If a newer Ardzy needs an id this layout lacks, its original page is kept with a credit.
Ardzy (c) chryso, GPL-3.0: https://github.com/chrysovalantischryso/ardzy
This script and the change it makes: by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import re
import sys

src, out = sys.argv[1], sys.argv[2]
s = open(src, encoding='utf-8').read()
if 'orphan-brand' in s:                        # already branded
    open(out, 'w', encoding='utf-8').write(s)
    raise SystemExit(0)
m = re.search(r'<small[^>]*>([\d.]+ ?\w*)</small>', s)
ver = m.group(1) if m else ''
script = s[s.index('<script>'):s.rindex('</script>') + len('</script>')]

CSS = """<style>/* orphan-brand: the Orphan KAS look (JMSCNC, GPL-3.0-or-later) */
:root{color-scheme:dark;--ink:#e8efe6;--muted:#a3afa2;--lime:#d2ff51;--line:#364239;--panel:#101613;--bad:#ffaea3;
 --mono:Consolas,"IBM Plex Mono",ui-monospace,monospace;--space:clamp(7px,1.3vh,15px)}
*{box-sizing:border-box}
body{margin:0;background:#080a0c;color:var(--ink);font:clamp(11px,1.7vh,15px)/1.35 var(--mono)}
button,input,select{font:inherit}
button{cursor:pointer;color:var(--ink);border:1px solid #47584d;border-radius:3px;background:linear-gradient(#242e28,#131914);padding:.45em .7em;white-space:nowrap}
button:hover,a:hover{color:var(--lime);border-color:var(--lime)}
button:focus-visible,input:focus-visible,a:focus-visible{outline:2px solid var(--lime);outline-offset:2px}
button.primary{background:linear-gradient(#e1ff8a,#a5cb37);border-color:var(--lime);color:#131a06;font-weight:700}
button.stop{border-color:#744744;color:var(--bad)}
a{color:var(--muted);text-decoration:none}
#rain{position:fixed;inset:0;width:100%;height:100%;pointer-events:none}
#motion{font-size:.85em}
main{position:relative;height:100dvh;max-width:1850px;margin:auto;display:grid;grid-template-rows:auto auto minmax(0,1fr) auto;gap:var(--space);padding:var(--space) clamp(9px,2vw,28px)}
header,footer,.panel-head,.row{display:flex;align-items:center;gap:.6em}
header{justify-content:space-between;border-bottom:1px solid #71827170;padding:0 0 var(--space)}
.identity{display:flex;align-items:center;gap:11px}
.mark{display:grid;place-items:center;width:2.7em;aspect-ratio:1;color:#142000;background:linear-gradient(140deg,#eaffac,#bddf47 55%,#667e25 56%,#aed438 82%,#edfaba);border:1px solid var(--lime);border-radius:3px;font-weight:bold;font-size:1.15em}
h1,h2,p{margin:0}
h1{font:800 clamp(24px,5vh,54px)/.87 "Arial Narrow",Bahnschrift,Impact,sans-serif;letter-spacing:-.035em;white-space:nowrap}
h1 span{color:var(--lime)}
.brand,.panel-head span,footer,.stat small{color:var(--muted);font-size:.84em;letter-spacing:.09em;text-transform:uppercase}
.brand{margin-top:.44em}
.header-tools{display:flex;gap:.5em;align-items:center}
.pill{color:var(--lime);font-size:.83em;border:1px solid #596e3e;background:#152112;padding:.45em .7em;white-space:nowrap}
.pill.offline{color:var(--bad);border-color:#744744;background:#1f1312}
a.pill b{color:var(--ink)}
.stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:var(--space)}
.stat,.panel{position:relative;min-width:0;border:1px solid var(--line);background:#101613b8;border-radius:4px;padding:var(--space);box-shadow:inset 0 1px #e1ffc810,0 10px 24px #0005}
.stat::before,.panel::before{content:"";position:absolute;top:-1px;left:12px;width:28px;height:1px;background:#b3c3b3}
.stat small{display:block}
.stat strong{display:block;font-size:clamp(15px,3.2vh,32px);line-height:1.15;font-weight:500;letter-spacing:-.04em;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.stat:first-child strong{color:var(--lime);text-shadow:0 0 22px #cfff5140}
.ok{color:var(--lime)}.warn{color:#e0c84a}.bad{color:var(--bad)}
#safemode{grid-column:1/-1;color:#e0c84a;border-left:2px solid #e0c84a;background:#1d1a0c;padding:.45em .65em}
.workspace{display:grid;min-height:0;grid-template-columns:minmax(220px,1fr) minmax(300px,1.6fr) minmax(240px,1fr);gap:var(--space)}
.rail,.center{display:grid;min-width:0;min-height:0;gap:var(--space)}
.rail.right{grid-template-rows:auto minmax(0,1fr)}
.center{grid-template-rows:minmax(0,1fr) auto}
.panel{display:flex;flex-direction:column;min-height:0}
.panel-head{justify-content:space-between;margin-bottom:.55em;flex-wrap:wrap}
h2{font-size:1em;color:var(--lime);text-transform:uppercase;letter-spacing:.11em}
.scroll{flex:1;min-height:0;overflow:auto;scrollbar-width:thin}
.proj{border-top:1px solid #26302a;padding:.6em 0}
.proj:first-child{border-top:0;padding-top:0}
.proj .name{font-weight:700}
.proj .files{color:var(--muted);font-size:.82em;margin:.15em 0 .5em;overflow-wrap:anywhere}
.proj button{padding:.25em .55em;font-size:.88em}
.tag{font-size:.75em;padding:.05em .5em;border:1px solid #596e3e;background:#152112;color:var(--lime);margin-left:.5em;text-transform:uppercase;letter-spacing:.06em}
input[type=text]{width:100%;min-width:0;background:#090e0b;border:1px solid #405044;border-radius:2px;padding:.38em .48em;color:var(--ink)}
input[type=checkbox]{accent-color:var(--lime)}
.field{margin-bottom:.5em}
label{color:var(--muted);font-size:.88em}
#drop{border:1px dashed #47584d;border-radius:3px;padding:.9em;text-align:center;color:var(--muted);margin:.2em 0 .6em;font-size:.88em}
#drop.over{border-color:var(--lime);color:var(--lime)}
#drop input{margin-top:.5em;max-width:100%;color:var(--muted)}
pre{flex:1;min-height:0;overflow:auto;scrollbar-width:thin;margin:0;background:#080e0a;border:1px solid #2d3b31;padding:.5em;white-space:pre-wrap;overflow-wrap:anywhere;color:#b2c7a6;font:inherit;font-size:.86em;line-height:1.5}
#regs{flex:none;min-height:3em;margin-top:.55em}
.status{display:flex;gap:.6em;align-items:center;min-height:2.65em;padding:.48em .65em;border-left:2px solid var(--lime);background:#112017;color:#d8ead1;overflow:hidden}
#msg{min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.hint{color:var(--muted);font-size:.8em;margin-top:.6em}
code{color:var(--ink)}
.bmc{display:inline-block;color:#1a1200!important;background:linear-gradient(#ffe27a,#ffcc2e);border:1px solid #ffdd55;border-radius:3px;padding:.4em .7em;font-weight:700;white-space:nowrap;box-shadow:0 0 14px #ffcc2e55}
.bmc:hover{color:#000!important;box-shadow:0 0 20px #ffcc2e99}.bmc.small{padding:.1em .5em;box-shadow:none;text-transform:none;letter-spacing:0}
.owner{color:var(--ink);letter-spacing:.08em}.owner.orphan{color:var(--lime)}
#otree summary{cursor:pointer;list-style:none;padding:.35em .2em;user-select:none}
#otree summary::-webkit-details-marker{display:none}
#otree summary::before{content:"▸ ";color:var(--muted)}#otree details[open]>summary::before{content:"▾ "}
.tree-o>summary{font-weight:700;border-bottom:1px solid #26302a}
.tree-b{margin-left:1em;border-left:1px solid #26302a;padding-left:.6em}
.tree-b>summary{color:#c9d6c4;text-transform:uppercase;letter-spacing:.08em;font-size:.88em}
.tree-b .proj{margin-left:.4em}
.cnt{color:var(--muted);font-weight:400;font-size:.85em}
.tag.gui{border-color:#3d6b66;background:#0f1f1d;color:#6ecfc1}
.proj .name{cursor:pointer}.proj .name:hover{color:var(--lime)}
.proj .name::after{content:" ⓘ";color:var(--muted);font-weight:400}
dialog{width:min(95vw,600px);max-height:calc(100dvh - 16px);overflow:auto;color:var(--ink);background:#111914;border:1px solid #587053;border-radius:4px;padding:16px;box-shadow:0 15px 65px #000}
dialog::backdrop{background:#030705cb}
dialog h3{color:var(--lime);font-size:.9em;letter-spacing:.1em;text-transform:uppercase;margin:1em 0 .3em}
dialog ol,dialog ul{margin:0;padding-left:1.4em}dialog li{margin:.25em 0}
dialog p{margin:.4em 0}.oi-tags .tag:first-child{margin-left:0}.oi-name{color:var(--muted);margin-left:.6em}
.oi-actions{margin-top:1em}
footer{justify-content:space-between;gap:6px;flex-wrap:wrap}
footer b{color:var(--ink);font-weight:400}
@media(max-width:899px){main{height:auto;min-height:100dvh}.workspace{grid-template-columns:minmax(0,1fr)}
 .rail.left .scroll{max-height:340px}pre#log{height:260px;flex:auto}h1{font-size:clamp(20px,6.2vw,36px)}}
@media(max-width:380px){.mark{display:none}}
</style>"""

BODY = """<body>
<canvas id="rain" aria-hidden="true"></canvas>
<main>
<header>
 <div class="identity"><div class="mark" aria-hidden="true">O</div><div><h1>ORPHAN <span>FPGA</span></h1><div class="brand">[orphan] · by JMSCNC, makers of RotatoCAM · FPGA Dev Linux for the S9 Control Board</div></div></div>
 <div class="header-tools">
  <a class="bmc" href="https://buymeacoffee.com/revjmoney" target="_blank" rel="noopener">&#9749; Buy me a coffee</a>
  <span id="orphan-fan"></span>
  <button id="motion" type="button" aria-pressed="true">FX on</button>
  <a class="pill" href="https://github.com/chrysovalantischryso/ardzy" target="_blank" rel="noopener" title="This page, the FPGA tool flow and the project loader are Ardzy"><b>ARDZY</b> INSIDE%s</a>
  <a class="pill" id="orphanGui" target="_blank" rel="noopener" hidden></a>
  <div class="pill" id="orphanConn">CONNECTING</div>
 </div>
</header>
<div class="stats" id="stats"></div>
<div class="workspace">
 <div class="rail left">
  <section class="panel">
   <div class="panel-head"><h2>Projects</h2><span id="orphanCount"></span></div>
   <div class="scroll"><div id="otree"></div><div id="projects" hidden></div></div>
  </section>
 </div>
 <div class="center">
  <section class="panel">
   <div class="panel-head"><h2>Program output</h2>
    <div class="row"><button onclick="act('restart')">Restart</button><button class="stop" onclick="act('stop')">Stop</button>
     <label><input type="checkbox" id="follow" checked> Follow</label></div></div>
   <pre id="log"></pre>
  </section>
  <div class="status" role="status"><strong>BOARD</strong><span id="msg">Ready.</span></div>
 </div>
 <div class="rail right">
  <section class="panel">
   <div class="panel-head"><h2>Upload</h2></div>
   <div class="field"><input type="text" id="pname" placeholder="project name, e.g. blink"></div>
   <div id="drop">Drop files here (.bit, main.py, .c, run.sh, devices.dtsi, or a .zip)<br><input type="file" id="files" multiple></div>
   <div class="row"><button class="primary" onclick="upload(true)">Upload and run</button><button onclick="upload(false)">Upload only</button></div>
   <p class="hint">From the PC you can also double-click <code>UPLOAD.bat</code> in a project folder.</p>
  </section>
  <section class="panel">
   <div class="panel-head"><h2>Registers</h2></div>
   <div class="field"><input type="text" id="addr" placeholder="address, e.g. 0x43C00000"></div>
   <div class="field"><input type="text" id="val" placeholder="value (for write)"></div>
   <div class="row"><button onclick="peek()">Read</button><button onclick="poke()">Write</button></div>
   <pre id="regs"></pre>
   <p class="hint">Only use addresses that exist in your loaded design. An address with nothing behind it freezes the
    board; the watchdog then reboots it in about 30 s.</p>
  </section>
 </div>
</div>
<div id="safemode" style="display:none">SAFE MODE: the last boot did not finish, so the default project was not loaded. Load a project to clear it.</div>
<footer><span><a class="bmc small" href="https://buymeacoffee.com/revjmoney" target="_blank" rel="noopener">&#9749; Buy me a coffee</a> · <b>[Rev. J. Money - 2026]</b> · by <a href="https://jmscnc.com">JMSCNC</a>, makers of RotatoCAM</span>
 <span>Ardzy inside: <a href="https://github.com/chrysovalantischryso/ardzy">Ardzy</a> by chryso (GPL-3.0) · Orphan FPGA Dev Linux</span></footer>
</main>
%s
<script>/* orphan-brand: connection pill + project count */
setInterval(async () => {
  const c = document.getElementById('orphanConn');
  try { const r = await fetch('/api/status'); const s = await r.json(); c.textContent = 'ONLINE'; c.classList.remove('offline');
    document.getElementById('orphanCount').textContent = s.projects.length + ' on board'; }
  catch (e) { c.textContent = 'OFFLINE'; c.classList.add('offline'); }
}, 3000);
</script>
<!--RAIN-->
<!--INFO-->
<script>(function(){var s=document.createElement('script');s.src='//'+location.hostname+':8080/fan.js';s.async=1;document.head.appendChild(s)})()</script>
</body>
</html>
""" % ((' ' + ver) if ver else '', script)
# project info popup (project.json: title, runs, summary, quickstart, wiring, web) + open a project's own web page
# in a new tab when it is loaded (the tab is opened at the click, so pop-up blockers allow it)
BODY = BODY.replace('<!--INFO-->', """<dialog id="orphanInfo" aria-labelledby="oiTitle">
 <div class="panel-head"><h2 id="oiTitle">Project</h2><form method="dialog"><button>Close</button></form></div>
 <div id="oiBody"></div>
</dialog>
<script>/* orphan-brand: project info + core web page */
(() => {
  const meta = {}, $o = id => document.getElementById(id);
  const esc2 = s => String(s).replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));
  let current = '';
  async function getMeta(p) {
    if (meta[p]) return meta[p];
    try { const r = await fetch('/api/file?p=' + encodeURIComponent(p) + '&f=project.json');
      meta[p] = r.ok ? JSON.parse(await r.text()) : {}; } catch (e) { meta[p] = {}; }
    return meta[p];
  }
  const guiUrl = m => m && m.web ? location.protocol + '//' + location.hostname + ':' + m.web + '/' : '';
  async function poll() {
    try { const s = await (await fetch('/api/status')).json(); current = s.current || '';
      for (const p of s.projects) getMeta(p.name);
      const m = current ? await getMeta(current) : null, a = $o('orphanGui');
      if (s.running && guiUrl(m)) { a.href = guiUrl(m); a.textContent = 'OPEN ' + current.toUpperCase() + ' GUI'; a.hidden = false; }
      else a.hidden = true;
    } catch (e) {}
  }
  poll(); setInterval(poll, 3000);
  // the project tree: [orphan] (Orphan's own) and [ardzy] (Ardzy's examples), each split into branches.
  // project.json "branch" picks the branch; otherwise it follows the category. Folder names stay as they are.
  const owner = p => /^orphan_/.test(p) ? 'orphan' : 'ardzy';
  const BRANCHES = ['games', 'mining', 'science', 'radio & sound', 'lab toys', 'starters & tests', 'etc.'];
  const BY_NAME = {'13_sha256': 'mining', 'orphan_toys': 'lab toys'};
  const BY_CAT = {'games': 'games', 'mining': 'mining', 'compute': 'mining', 'ai': 'science', 'computing': 'science',
    'radio': 'radio & sound', 'sound': 'radio & sound', 'starters': 'starters & tests', 'tests': 'starters & tests',
    'lights and display': 'lab toys', 'test and measurement': 'lab toys', 'motors and motion': 'lab toys',
    'communication': 'lab toys', 'sensors': 'lab toys', 'graphics': 'lab toys'};
  const branch = (p, m) => m.branch || BY_NAME[p] || BY_CAT[(m.category || '').toLowerCase()] || 'etc.';
  let opened = null;
  try { opened = JSON.parse(localStorage.getItem('orphan-tree') || 'null'); } catch (e) {}
  opened = new Set(opened || ['orphan']);
  const remember = () => { try { localStorage.setItem('orphan-tree', JSON.stringify([...opened])); } catch (e) {} };
  let lastKey = '';
  async function tree() {
    let s;
    try { s = await (await fetch('/api/status')).json(); } catch (e) { return; }
    const ms = await Promise.all(s.projects.map(p => getMeta(p.name)));
    const key = JSON.stringify([s.projects.map(p => p.name), s.current, s.default, ms.map(m => m.branch || m.category)]);
    if (key === lastKey) return;
    lastKey = key;
    const groups = {orphan: {}, ardzy: {}};
    s.projects.forEach((p, i) => { const b = branch(p.name, ms[i]); (groups[owner(p.name)][b] = groups[owner(p.name)][b] || []).push([p, ms[i]]); });
    let h = '';
    for (const o of ['orphan', 'ardzy']) {
      const n = Object.values(groups[o]).reduce((a, x) => a + x.length, 0);
      if (!n) continue;
      h += '<details class="tree-o" data-k="' + o + '"' + (opened.has(o) ? ' open' : '') + '><summary><span class="owner ' + o + '">[' + o + ']</span> <span class="cnt">' + n + '</span></summary>';
      for (const b of BRANCHES) {
        const list = groups[o][b]; if (!list) continue;
        const k = o + '/' + b;
        h += '<details class="tree-b" data-k="' + esc2(k) + '"' + (opened.has(k) ? ' open' : '') + '><summary>[' + esc2(b) + '] <span class="cnt">' + list.length + '</span></summary>';
        for (const [p, m] of list) {
          const isDef = p.name === s.default;
          h += '<div class="proj"><div class="name" data-p="' + esc2(p.name) + '">' + esc2(p.name) +
            (p.name === s.current ? '<span class="tag">loaded</span>' : '') + (isDef ? '<span class="tag">at boot</span>' : '') +
            (m.web ? '<span class="tag gui">gui</span>' : '') + '</div>' +
            '<div class="files">' + esc2(m.title || '') + '</div><div class="row">' +
            '<button class="primary" data-act="load">Load</button>' +
            '<button data-act="boot">' + (isDef ? 'Not at boot' : 'At boot') + '</button>' +
            '<button data-act="del">Delete</button></div></div>';
        }
        h += '</details>';
      }
      h += '</details>';
    }
    $o('otree').innerHTML = h || '<p class="hint">No projects yet. Upload one.</p>';
    $o('otree').dataset.def = s.default || '';
    // links: #all opens every branch, #info=<project> opens that project's quick start (for docs and screenshots)
    if (!tree.linked) {
      tree.linked = true;
      if (location.hash === '#all') { document.querySelectorAll('#otree details').forEach(d => d.open = true); }
      const want = location.hash.startsWith('#info=') ? decodeURIComponent(location.hash.slice(6)) : '';
      const n = want && document.querySelector('#otree .name[data-p="' + want.replace(/"/g, '') + '"]');
      if (n) { n.closest('details.tree-b').open = true; n.closest('details.tree-o').open = true; n.click(); }
    }
  }
  tree(); setInterval(tree, 3000);
  $o('otree').addEventListener('toggle', e => {
    const k = e.target.dataset && e.target.dataset.k; if (!k) return;
    if (e.target.open) opened.add(k); else opened.delete(k); remember();
  }, true);
  $o('otree').addEventListener('click', e => {
    const b = e.target.closest('button[data-act]'); if (!b) return;
    const p = b.closest('.proj').querySelector('.name').dataset.p, def = $o('otree').dataset.def;
    if (b.dataset.act === 'load') load(p);
    else if (b.dataset.act === 'boot') setDefault(p === def ? '' : p);
    else if (b.dataset.act === 'del') del(p);
    setTimeout(() => { lastKey = ''; tree(); }, 800);
  });
  // click a project's name: what it is and how to start
  $o('otree').addEventListener('click', async e => {
    const n = e.target.closest('.name'); if (!n) return;
    const p = n.dataset.p, m = await getMeta(p);
    $o('oiTitle').textContent = '[' + owner(p) + '] ' + (m.title || p);
    let h = '<p class="oi-tags"><span class="tag">' + esc2(m.runs || 'fpga core') + '</span>' +
      (m.category ? '<span class="tag">' + esc2(m.category) + '</span>' : '') + '<span class="oi-name">' + esc2(p) + '</span></p>';
    if (m.summary) h += '<p>' + esc2(m.summary) + '</p>';
    if (m.quickstart && m.quickstart.length) h += '<h3>Quick start</h3><ol>' + m.quickstart.map(s => '<li>' + esc2(s) + '</li>').join('') + '</ol>';
    if (m.wiring && m.wiring.length) h += '<h3>Wiring</h3><ul>' + m.wiring.map(w => '<li><b>' + esc2(w[0]) + '</b>: ' + esc2(w.slice(1).join(', ')) + '</li>').join('') + '</ul>';
    h += '<div class="row oi-actions"><button class="primary" id="oiLoad">Load ' + esc2(p) + '</button>' +
      (guiUrl(m) ? '<span class="hint">opens its page on port ' + m.web + '</span>' : '') + '</div>';
    $o('oiBody').innerHTML = h;
    $o('oiLoad').onclick = () => { $o('orphanInfo').close(); load(p); };
    $o('orphanInfo').showModal();
  });
  // Load: Ardzy's own load(), plus the project's web page in a new tab when it has one
  const ardzyLoad = load;
  window.load = async function (p) {
    const m = meta[p], url = guiUrl(m);
    let tab = null;
    if (url) { tab = window.open('', '_blank');
      if (tab) tab.document.write('<body style="background:#080a0c;color:#d2ff51;font:16px Consolas,monospace;padding:2em">Starting ' + esc2(p) + ' ...</body>'); }
    await ardzyLoad(p);
    if (tab) setTimeout(() => { try { tab.location.href = url; } catch (e) {} }, 2500);
  };
})();
</script>""")
# the falling 0/1 rain of the Orphan KAS page (no hash pipeline); FX on/off is remembered per browser
BODY = BODY.replace('<!--RAIN-->', """<script>/* orphan-brand: rain */
(() => {
  const cv = document.getElementById('rain'), btn = document.getElementById('motion');
  const reduced = matchMedia('(prefers-reduced-motion: reduce)');
  let on = !reduced.matches, frame = 0, last = 0;
  try { on = on && localStorage.getItem('orphan-fx') !== 'off'; } catch (e) {}
  function draw(time) {
    const w = cv.clientWidth, h = cv.clientHeight;
    if (cv.width !== w || cv.height !== h) { cv.width = w; cv.height = h; }
    const ctx = cv.getContext('2d'); ctx.clearRect(0, 0, w, h); ctx.font = '12px Consolas';
    for (let lane = 0; lane < w / 22; lane++) {
      const step = Math.floor(time / (82 + lane % 6 * 16)), y = ((step * 14 + lane * 89) % (h + 154)) - 12;
      for (let i = 0; i < 8; i++) {
        ctx.fillStyle = i === 0 ? '#bfef6650' : 'rgba(139,208,57,' + (8 - i) * .014 + ')';
        ctx.fillText((step + i * 13 + lane * 29) % 7 < 3 ? '0' : '1', lane * 22 + 4, y - i * 14);
      }
    }
  }
  function animate(time) { if (!on) return; if (time - last >= 48) { last = time; draw(time); } frame = requestAnimationFrame(animate); }
  function set(v) {
    on = v; btn.textContent = v ? 'FX on' : 'FX off'; btn.setAttribute('aria-pressed', v); cv.hidden = !v;
    if (!v) { cancelAnimationFrame(frame); frame = 0; } else if (!frame) frame = requestAnimationFrame(animate);
  }
  btn.onclick = () => { set(!on); try { localStorage.setItem('orphan-fx', on ? 'on' : 'off'); } catch (e) {} };
  reduced.addEventListener('change', e => set(!e.matches));
  set(on);
})();
</script>""")

used = set(re.findall(r"\$\('(\w+)'\)", script))
missing = sorted(i for i in used if 'id="%s"' % i not in BODY)
if missing:                                    # a newer Ardzy: keep its page, add the credit only
    s = s.replace('</body>', '<p style="text-align:center;font:12px monospace;opacity:.7"><!-- orphan-brand -->'
                  '<a href="https://buymeacoffee.com/revjmoney">Buy me a coffee</a> · [Rev. J. Money - 2026] · Orphan · FPGA Dev Linux for the S9 Control Board · by JMSCNC, makers of RotatoCAM · Ardzy inside: Ardzy by chryso (GPL-3.0)</p></body>', 1)
    open(out, 'w', encoding='utf-8').write(s)
    print('kept the Ardzy layout (ids missing here: %s)' % ', '.join(missing))
    raise SystemExit(0)
head = s[:s.index('<style>')]
head = re.sub(r'<title>.*?</title>', '<title>ORPHAN FPGA · JMSCNC</title>', head, count=1)
head = head.replace('<meta charset="utf-8">', '<meta charset="utf-8">\n<meta name="theme-color" content="#080a0c">', 1)
open(out, 'w', encoding='utf-8').write(head + CSS + '\n</head>\n' + BODY)
print('branded', out, ver)
