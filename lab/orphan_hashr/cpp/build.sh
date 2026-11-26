#!/bin/sh
# [orphan] H4SHR-CH3KR hashrd: build on the S9 control board (g++, C++17, no third-party libraries).
# by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
set -e
cd "$(dirname "$0")"
g++ -O2 -std=c++17 -Wall -Wextra -pthread -o hashrd $(ls *.cpp | grep -v '^test_')
