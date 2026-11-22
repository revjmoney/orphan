#!/bin/bash
# Copy the Orphan Radio project to a board and load it. Usage: bash deploy.sh <board ip>
set -e
B=${1:?usage: bash deploy.sh <board ip>}
cd "$(dirname "$0")"
tar -cf - --exclude=__pycache__ --exclude='*.out' orphan_radio | ssh -o BatchMode=yes root@$B 'systemctl stop s9-ledring 2>/dev/null; tar -xf - -C /opt/ardzy/projects/ &&
  cd /opt/ardzy/projects/orphan_radio && sed -i "s/\r$//" *.py *.html *.json *.v *.xdc &&
  ardzy load orphan_radio 2>&1 | tail -1 && sleep 4 && ardzy log 2>&1 | tail -4'
