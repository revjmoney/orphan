#!/bin/bash
# Copy the Orphan Synth project to a board and load it. Usage: bash deploy.sh <board ip>
set -e
B=${1:?usage: bash deploy.sh <board ip>}
cd "$(dirname "$0")"
tar -cf - --exclude=__pycache__ --exclude='*.out' orphan_synth | ssh -o BatchMode=yes root@$B 'systemctl stop s9-ledring 2>/dev/null; tar -xf - -C /opt/ardzy/projects/ &&
  cd /opt/ardzy/projects/orphan_synth && sed -i "s/\r$//" *.py *.html *.json *.v *.xdc &&
  ardzy load orphan_synth 2>&1 | tail -1 && sleep 4 && ardzy log 2>&1 | tail -4'
