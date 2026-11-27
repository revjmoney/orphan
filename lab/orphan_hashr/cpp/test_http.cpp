// [orphan] H4SHR-CH3KR: checks for hashrd's small HTTP server (request parsing, responses, safe paths, LAN-only).
//   g++ -O2 -std=c++17 -o test_http test_http.cpp http.cpp && ./test_http
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "http.hpp"
#include <cstdio>
#include <string>

static int pass = 0, total = 0;
static void check(bool ok, const char* name) {
    total++;
    if (ok) pass++;
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", name);
}

int main() {
    bool complete = true;
    HttpReq r = parse_request("GET /api/state?since=12 HTTP/1.1\r\nHost: orph", complete);
    bool ok = !complete;
    r = parse_request("GET /api/state?since=12 HTTP/1.1\r\nHost: orphan.local\r\n\r\n", complete);
    ok = ok && complete && r.method == "GET" && r.path == "/api/state" && r.query == "since=12" && r.body.empty();
    check(ok, "GET split in two reads: complete only when the headers end");
    r = parse_request("POST /api/action HTTP/1.1\r\nContent-Length: 10\r\n\r\n{\"op\":", complete);
    ok = !complete;
    r = parse_request("POST /api/action HTTP/1.1\r\ncontent-length: 10\r\n\r\n{\"op\":\"x\"}", complete);
    ok = ok && complete && r.method == "POST" && r.body == "{\"op\":\"x\"}";
    check(ok, "POST complete only when Content-Length bytes of body are there");
    std::string h = http_response(200, "application/json", "{}");
    check(h.rfind("HTTP/1.1 200 OK\r\n", 0) == 0 && h.find("Content-Length: 2\r\n") != std::string::npos &&
          h.size() >= 2 && h.substr(h.size() - 2) == "{}", "response with its Content-Length");
    check(safe_path("/") && safe_path("/index.html") && !safe_path("/../etc/passwd") && !safe_path("/a/../../b") &&
          !safe_path("//etc/passwd"), "paths with .. or // are refused");
    check(lan_ok("192.168.0.20") && lan_ok("10.0.0.5") && lan_ok("172.20.1.1") && lan_ok("127.0.0.1") &&
          !lan_ok("8.8.8.8") && !lan_ok("172.32.0.1"), "only LAN and loopback addresses are served");
    // a page on another site must not drive the board: actions need JSON (a preflight no one grants), a matching
    // Origin when the browser sends one, and a Host that is this board (not a rebinding attacker's name)
    {
        std::string why;
        auto req = [&](const char* raw) { bool c; return parse_request(raw, c); };
        HttpReq plain = req("POST /api/action HTTP/1.1\r\nHost: 192.168.0.10:8000\r\nContent-Type: text/plain\r\nContent-Length: 2\r\n\r\n{}");
        HttpReq evil = req("POST /api/action HTTP/1.1\r\nHost: 192.168.0.10:8000\r\nOrigin: http://evil.example\r\nContent-Type: application/json\r\nContent-Length: 2\r\n\r\n{}");
        HttpReq rebind = req("POST /api/action HTTP/1.1\r\nHost: evil.example:8000\r\nContent-Type: application/json\r\nContent-Length: 2\r\n\r\n{}");
        HttpReq page = req("POST /api/action HTTP/1.1\r\nHost: 192.168.0.10:8000\r\nOrigin: http://192.168.0.10:8000\r\nContent-Type: application/json\r\nContent-Length: 2\r\n\r\n{}");
        HttpReq curl = req("POST /api/action HTTP/1.1\r\nHost: orphan.local:8000\r\ncontent-type: application/json; charset=utf-8\r\nContent-Length: 2\r\n\r\n{}");
        HttpReq state = req("GET /api/state HTTP/1.1\r\nHost: localhost:8000\r\n\r\n");
        check(!request_allowed(plain, why) && !request_allowed(evil, why) && !request_allowed(rebind, why) &&
              request_allowed(page, why) && request_allowed(curl, why) && request_allowed(state, why),
              "actions only from this board's own page (JSON, same origin, own host)");
    }
    std::printf("%s %d/%d\n", pass == total ? "PASS" : "FAIL", pass, total);
    return pass == total ? 0 : 1;
}
