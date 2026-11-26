// [orphan] H4SHR-CH3KR hashrd: the page's HTTP server (see http.hpp). by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "http.hpp"
#include <algorithm>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <atomic>
#include <chrono>
#include <thread>
#ifndef _WIN32
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <unistd.h>
#endif

HttpReq parse_request(const std::string& raw, bool& complete) {
    HttpReq r;
    complete = false;
    size_t he = raw.find("\r\n\r\n");
    if (he == std::string::npos) return r;
    size_t sp1 = raw.find(' '), sp2 = sp1 == std::string::npos ? sp1 : raw.find(' ', sp1 + 1);
    if (sp1 == std::string::npos || sp2 == std::string::npos) { complete = true; return r; }
    r.method = raw.substr(0, sp1);
    std::string target = raw.substr(sp1 + 1, sp2 - sp1 - 1);
    size_t q = target.find('?');
    r.path = target.substr(0, q);
    if (q != std::string::npos) r.query = target.substr(q + 1);
    size_t len = 0;
    std::string head = raw.substr(0, he);
    std::string low = head;
    std::transform(low.begin(), low.end(), low.begin(), [](unsigned char c) { return char(std::tolower(c)); });
    size_t cl = low.find("\r\ncontent-length:");
    if (cl != std::string::npos) len = size_t(std::strtoul(head.c_str() + cl + 17, nullptr, 10));
    auto header = [&](const char* name) {           // a header's value, as sent (names match in any case)
        std::string key = std::string("\r\n") + name + ":";
        size_t p = low.find(key);
        if (p == std::string::npos) return std::string();
        size_t s = p + key.size(), e = head.find("\r\n", s);
        std::string v = head.substr(s, e == std::string::npos ? std::string::npos : e - s);
        v.erase(0, v.find_first_not_of(" \t"));
        while (!v.empty() && (v.back() == ' ' || v.back() == '\t')) v.pop_back();
        return v;
    };
    r.host = header("host");
    r.origin = header("origin");
    r.content_type = header("content-type");
    if (raw.size() < he + 4 + len) return r;
    r.body = raw.substr(he + 4, len);
    complete = true;
    return r;
}

std::string http_response(int code, const std::string& type, const std::string& body) {
    const char* text = code == 200 ? "OK" : code == 400 ? "Bad Request" : code == 403 ? "Forbidden" : code == 404 ? "Not Found"
                                                                                                    : "Error";
    return "HTTP/1.1 " + std::to_string(code) + " " + text + "\r\nContent-Type: " + type +
           "\r\nContent-Length: " + std::to_string(body.size()) +
           "\r\nCache-Control: no-store\r\nConnection: close\r\n\r\n" + body;
}

bool safe_path(const std::string& p) {
    return !p.empty() && p[0] == '/' && p.find("..") == std::string::npos && p.find("//") == std::string::npos;
}

bool lan_ok(const std::string& ip) {
    if (ip == "::1" || ip.rfind("fe80:", 0) == 0) return true;
    std::string v4 = ip.rfind("::ffff:", 0) == 0 ? ip.substr(7) : ip;
    unsigned a = 0, b = 0, c = 0, d = 0;
    if (std::sscanf(v4.c_str(), "%u.%u.%u.%u", &a, &b, &c, &d) != 4) return false;
    return a == 10 || a == 127 || (a == 192 && b == 168) || (a == 172 && b >= 16 && b <= 31) || (a == 169 && b == 254);
}

// the Host a browser names: this board by LAN address, a .local name, a bare host name or localhost; never another
// site's name (DNS rebinding points such a name at the board, but the browser still sends that name)
static bool host_ok(std::string h) {
    if (h.empty()) return true;                     // HTTP/1.0 tools send none
    if (h[0] == '[') { size_t e = h.find(']'); h = e == std::string::npos ? h : h.substr(1, e - 1); }
    else { size_t c = h.rfind(':'); if (c != std::string::npos && h.find(':') == c) h = h.substr(0, c); }
    for (auto& ch : h) ch = char(std::tolower((unsigned char)ch));
    if (h == "localhost" || lan_ok(h)) return true;
    if (h.size() > 6 && h.compare(h.size() - 6, 6, ".local") == 0) return true;
    return h.find('.') == std::string::npos && h.find(':') == std::string::npos && !h.empty();
}

bool request_allowed(const HttpReq& r, std::string& why) {
    if (!host_ok(r.host)) { why = "not this board's address"; return false; }
    if (r.method != "POST") return true;
    std::string ct = r.content_type;
    for (auto& ch : ct) ch = char(std::tolower((unsigned char)ch));
    if (ct.rfind("application/json", 0) != 0) { why = "actions must be JSON"; return false; }
    if (!r.origin.empty() && r.origin != "http://" + r.host) { why = "actions only from this board's own page"; return false; }
    return true;
}

std::string query_value(const std::string& query, const std::string& key) {
    size_t p = 0;
    while (p <= query.size()) {
        size_t e = query.find('&', p);
        std::string kv = query.substr(p, e == std::string::npos ? std::string::npos : e - p);
        size_t eq = kv.find('=');
        if (kv.substr(0, eq) == key) return eq == std::string::npos ? "" : kv.substr(eq + 1);
        if (e == std::string::npos) break;
        p = e + 1;
    }
    return "";
}

#ifndef _WIN32
void http_serve(int port, std::function<HttpOut(const HttpReq&)> handler, std::function<void(const std::string&)> log) {
    int s = socket(AF_INET6, SOCK_STREAM, 0);
    int one = 1, zero = 0;
    setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one);
    setsockopt(s, IPPROTO_IPV6, IPV6_V6ONLY, &zero, sizeof zero);
    sockaddr_in6 a{};
    a.sin6_family = AF_INET6;
    a.sin6_addr = in6addr_any;
    a.sin6_port = htons(uint16_t(port));
    if (bind(s, reinterpret_cast<sockaddr*>(&a), sizeof a) != 0 || listen(s, 16) != 0) {
        if (log) log("web page: cannot listen on port " + std::to_string(port));
        close(s);
        return;
    }
    if (log) log("web page on port " + std::to_string(port));
    static std::atomic<int> active{0};             // requests being handled: a flood is refused, never a crash
    for (;;) {
        sockaddr_in6 peer{};
        socklen_t pl = sizeof peer;
        int fd = accept(s, reinterpret_cast<sockaddr*>(&peer), &pl);
        if (fd < 0) { std::this_thread::sleep_for(std::chrono::milliseconds(100)); continue; }   // EMFILE: back off
        char ipb[INET6_ADDRSTRLEN] = {0};
        inet_ntop(AF_INET6, &peer.sin6_addr, ipb, sizeof ipb);
        std::string ip = ipb;
        timeval tv{5, 0};
        setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof tv);
        setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof tv);
        auto reply = [](int f, const std::string& out) {
            size_t off = 0;
            while (off < out.size()) {
                ssize_t k = send(f, out.data() + off, out.size() - off, MSG_NOSIGNAL);
                if (k <= 0) break;
                off += size_t(k);
            }
            close(f);
        };
        if (!lan_ok(ip)) { reply(fd, http_response(403, "text/plain", "LAN only\n")); continue; }   // before reading
        if (active >= 16) { reply(fd, http_response(503, "text/plain", "busy\n")); continue; }
        active++;
        try {
            std::thread([fd, handler, reply] {
                std::string raw, out;
                bool complete = false;
                HttpReq r;
                char b[8192];
                auto deadline = std::chrono::steady_clock::now() + std::chrono::seconds(10);
                while (!complete && raw.size() < (64u << 10) && std::chrono::steady_clock::now() < deadline) {
                    ssize_t k = read(fd, b, sizeof b);
                    if (k <= 0) break;
                    raw.append(b, size_t(k));
                    r = parse_request(raw, complete);
                }
                std::string why;
                if (!complete) out = http_response(400, "text/plain", "bad request\n");
                else if (!request_allowed(r, why)) out = http_response(403, "text/plain", why + "\n");
                else {
                    HttpOut o;
                    try { o = handler(r); } catch (const std::exception& e) { o = {500, "text/plain", std::string("error: ") + e.what()}; }
                    out = http_response(o.code, o.type, o.body);
                }
                reply(fd, out);
                active--;
            }).detach();
        } catch (const std::exception&) {          // no thread to be had: refuse this one, keep serving
            active--;
            reply(fd, http_response(503, "text/plain", "busy\n"));
        }
    }
}
#endif
