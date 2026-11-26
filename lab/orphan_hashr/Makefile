# [orphan] H4SHR-CH3KR: Ardzy runs `make` and then ./app when the project is loaded (no main.py: no Python).
# ./app is hashrd (C++, standard library only): the daemon with no arguments, a command client with them.
# by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
SRC := $(filter-out cpp/test_%.cpp,$(wildcard cpp/*.cpp))
HDR := $(wildcard cpp/*.hpp)

app: $(SRC) $(HDR)
	g++ -O2 -std=c++17 -Wall -Wextra -pthread -o app $(SRC)

.PHONY: clean
clean:
	rm -f app
