"""On the board: merge Orphan's descriptions and quick starts into every project's project.json.
    python3 merge-quickstart.py <quickstart.json> [<quickstart.json> ...]
Each file maps project name -> {"summary", "quickstart", "web"}; those keys replace the ones in
/opt/ardzy/projects/<name>/project.json (other keys stay). by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import json
import os
import sys

P = '/opt/ardzy/projects'
n = 0
for f in sys.argv[1:]:
    for name, add in json.load(open(f, encoding='utf-8')).items():
        pj = os.path.join(P, name, 'project.json')
        if not os.path.isdir(os.path.join(P, name)):
            continue
        try:
            m = json.load(open(pj, encoding='utf-8'))
        except (OSError, ValueError):
            m = {'title': name}
        m.update({k: v for k, v in add.items() if k in ('summary', 'quickstart', 'web')})
        json.dump(m, open(pj, 'w', encoding='utf-8'), indent=2, ensure_ascii=False)
        n += 1
print('   quick starts merged: %d projects' % n)
