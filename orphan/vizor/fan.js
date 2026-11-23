/* Orphan fan slider: one small control in the header of every Orphan page.
   Served by VIZOR (http://<board>:8080/fan.js) and loaded by each page with:
     <script>(function(){var s=document.createElement('script');s.src='http://'+location.hostname+':8080/fan.js';s.async=1;document.head.appendChild(s)})()</script>
   It mounts into #orphan-fan, else the header's .tools, else the header, else a small chip at the top right.
   The duty is saved on the board and used at boot (orphan-fan). by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] */
(function () {
  if (window.__orphanFan) return; window.__orphanFan = 1;
  var API = 'http://' + location.hostname + ':8080/api/fan';
  var css = '.ofan{display:inline-flex;align-items:center;gap:.45em;font:12px/1 Consolas,"IBM Plex Mono",monospace;color:#a3afa2;' +
    'border:1px solid #596e3e;background:#152112d9;padding:.3em .55em;border-radius:3px;white-space:nowrap;letter-spacing:.06em}' +
    '.ofan b{color:#d2ff51;font-weight:400;min-width:3.2em;text-align:right}.ofan input{width:84px;accent-color:#d2ff51;margin:0;cursor:pointer}' +
    '.ofan.float{position:fixed;top:8px;right:8px;z-index:99999;box-shadow:0 6px 18px #000a}.ofan.off{opacity:.55}';
  var st = document.createElement('style'); st.textContent = css; document.head.appendChild(st);
  var el = document.createElement('span'); el.className = 'ofan off'; el.title = 'Fans (saved on the board)';
  el.innerHTML = '<span>FAN</span><input type="range" min="0" max="100" step="5" aria-label="Fan speed"><b>-</b>';
  var rng = el.querySelector('input'), val = el.querySelector('b'), busy = false, t = 0;
  function mount() {
    var host = document.getElementById('orphan-fan') || document.querySelector('header .tools') || document.querySelector('#tray') || document.querySelector('header');
    if (host) { if (host.id === 'tray') host.insertBefore(el, host.firstChild); else host.appendChild(el); }
    else { el.classList.add('float'); document.body.appendChild(el); }
  }
  function show(f) {
    if (!f || !f.ok) { el.classList.add('off'); el.title = 'Fans: ' + ((f && (f.error || f.out)) || 'VIZOR not reachable'); val.textContent = '-'; return; }
    el.classList.remove('off');
    var rpm = (f.rpm || []).filter(function (r) { return r > 0; });
    el.title = 'Fans: ' + f.duty + ' % via ' + (f.via || '?') + (rpm.length ? ' · ' + rpm.join(' / ') + ' rpm' : '') + ' (saved on the board)';
    if (!busy && document.activeElement !== rng) rng.value = f.duty;
    val.textContent = (busy ? rng.value : f.duty) + '%';
  }
  function poll() { fetch(API, { cache: 'no-store' }).then(function (r) { return r.json(); }).then(show).catch(function () { show(null); }); }
  rng.addEventListener('input', function () { busy = true; val.textContent = rng.value + '%'; clearTimeout(t);
    t = setTimeout(function () {
      fetch(API, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ duty: +rng.value }) })
        .then(function (r) { return r.json(); }).then(function () { busy = false; poll(); }).catch(function () { busy = false; });
    }, 250); });
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', mount); else mount();
  poll(); setInterval(poll, 4000);
})();
