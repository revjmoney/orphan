// [orphan] H4SHR-CH3KR hashrd: a small HTTP/1.1 server for the page (port 8000): one request per connection, LAN and
// loopback clients only. Standard library and POSIX sockets. by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <functional>
#include <string>

struct HttpReq {
    std::string method, path, query, body;
    std::string host, origin, content_type;       // headers the safety checks need
};

HttpReq parse_request(const std::string& raw, bool& complete);   // complete: headers ended and the whole body is in
std::string http_response(int code, const std::string& type, const std::string& body);
bool safe_path(const std::string& path);           // no "..", no "//"
bool lan_ok(const std::string& ip);                // 10/8, 172.16/12, 192.168/16, 169.254/16, 127/8, ::1, fe80::/10
bool request_allowed(const HttpReq& r, std::string& why);   // own host; actions: JSON and same origin
std::string query_value(const std::string& query, const std::string& key);

// serve forever on the port; handler(req) returns {status code, content type, body}
struct HttpOut { int code; std::string type, body; };
void http_serve(int port, std::function<HttpOut(const HttpReq&)> handler, std::function<void(const std::string&)> log);
