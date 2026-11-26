// [orphan] H4SHR-CH3KR hashrd: JSON reader and writer. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026]
// GPL-3.0-or-later.
#include "json.hpp"
#include <cmath>
#include <cstdio>
#include <cstdlib>

namespace json {

static const Value& null_value() { static const Value v; return v; }

const Value& Value::operator[](size_t i) const { return t_ == ARR && i < a_.size() ? a_[i] : null_value(); }
const Value& Value::operator[](const std::string& k) const {
    if (t_ != OBJ) return null_value();
    auto it = o_.find(k);
    return it == o_.end() ? null_value() : it->second;
}
Value& Value::push(Value v) {
    if (t_ == NUL) t_ = ARR;
    a_.push_back(std::move(v));
    return a_.back();
}
Value& Value::set(const std::string& k, Value v) {
    if (t_ == NUL) t_ = OBJ;
    return o_[k] = std::move(v);
}

struct Parser {
    const std::string& s;
    size_t i = 0;
    int depth = 0;
    void ws() { while (i < s.size() && (s[i] == ' ' || s[i] == '\t' || s[i] == '\n' || s[i] == '\r')) i++; }
    bool lit(const char* w) {
        size_t n = 0;
        while (w[n]) n++;
        if (s.compare(i, n, w) != 0) return false;
        i += n;
        return true;
    }
    static void utf8(std::string& o, unsigned c) {
        if (c < 0x80) o += char(c);
        else if (c < 0x800) { o += char(0xC0 | c >> 6); o += char(0x80 | (c & 0x3F)); }
        else if (c < 0x10000) { o += char(0xE0 | c >> 12); o += char(0x80 | (c >> 6 & 0x3F)); o += char(0x80 | (c & 0x3F)); }
        else { o += char(0xF0 | c >> 18); o += char(0x80 | (c >> 12 & 0x3F)); o += char(0x80 | (c >> 6 & 0x3F));
               o += char(0x80 | (c & 0x3F)); }
    }
    bool hex4(unsigned& c) {
        if (i + 4 > s.size()) return false;
        c = 0;
        for (int k = 0; k < 4; k++) {
            char h = s[i++];
            c <<= 4;
            if (h >= '0' && h <= '9') c |= unsigned(h - '0');
            else if (h >= 'a' && h <= 'f') c |= unsigned(h - 'a' + 10);
            else if (h >= 'A' && h <= 'F') c |= unsigned(h - 'A' + 10);
            else return false;
        }
        return true;
    }
    bool string(std::string& o) {
        if (s[i] != '"') return false;
        i++;
        while (i < s.size() && s[i] != '"') {
            char ch = s[i++];
            if (ch != '\\') { o += ch; continue; }
            if (i >= s.size()) return false;
            char e = s[i++];
            switch (e) {
                case '"': o += '"'; break;
                case '\\': o += '\\'; break;
                case '/': o += '/'; break;
                case 'b': o += '\b'; break;
                case 'f': o += '\f'; break;
                case 'n': o += '\n'; break;
                case 'r': o += '\r'; break;
                case 't': o += '\t'; break;
                case 'u': {
                    unsigned c;
                    if (!hex4(c)) return false;
                    if (c >= 0xD800 && c < 0xDC00 && i + 6 <= s.size() && s[i] == '\\' && s[i + 1] == 'u') {
                        unsigned lo;
                        i += 2;
                        if (!hex4(lo)) return false;
                        c = 0x10000 + ((c - 0xD800) << 10) + (lo - 0xDC00);
                    }
                    utf8(o, c);
                    break;
                }
                default: return false;
            }
        }
        if (i >= s.size()) return false;
        i++;
        return true;
    }
    bool value(Value& v) {
        if (++depth > 64) return false;
        ws();
        if (i >= s.size()) return false;
        char c = s[i];
        bool ok = true;
        if (c == '{') {
            v = Value::object();
            i++;
            ws();
            if (i < s.size() && s[i] == '}') i++;
            else for (;;) {
                ws();
                std::string k;
                if (i >= s.size() || !string(k)) { ok = false; break; }
                ws();
                if (i >= s.size() || s[i] != ':') { ok = false; break; }
                i++;
                Value m;
                if (!value(m)) { ok = false; break; }
                v.o_[k] = std::move(m);
                ws();
                if (i < s.size() && s[i] == ',') { i++; continue; }
                if (i < s.size() && s[i] == '}') { i++; break; }
                ok = false;
                break;
            }
        } else if (c == '[') {
            v = Value::array();
            i++;
            ws();
            if (i < s.size() && s[i] == ']') i++;
            else for (;;) {
                Value m;
                if (!value(m)) { ok = false; break; }
                v.a_.push_back(std::move(m));
                ws();
                if (i < s.size() && s[i] == ',') { i++; continue; }
                if (i < s.size() && s[i] == ']') { i++; break; }
                ok = false;
                break;
            }
        } else if (c == '"') {
            std::string t;
            ok = string(t);
            v = Value(std::move(t));
        } else if (lit("true")) v = Value(true);
        else if (lit("false")) v = Value(false);
        else if (lit("null")) v = Value();
        else {
            const char* b = s.c_str() + i;
            char* e = nullptr;
            double n = std::strtod(b, &e);
            if (e == b) ok = false;
            else { i += size_t(e - b); v = Value(n); }
        }
        depth--;
        return ok;
    }
};

bool parse(const std::string& text, Value& out) {
    Parser p{text};
    Value v;
    if (!p.value(v)) return false;
    p.ws();
    if (p.i != text.size()) return false;
    out = std::move(v);
    return true;
}

std::string quote(const std::string& s) {
    std::string o = "\"";
    for (unsigned char c : s) {
        switch (c) {
            case '"': o += "\\\""; break;
            case '\\': o += "\\\\"; break;
            case '\n': o += "\\n"; break;
            case '\r': o += "\\r"; break;
            case '\t': o += "\\t"; break;
            default:
                if (c < 0x20) { char b[8]; std::snprintf(b, sizeof b, "\\u%04x", c); o += b; }
                else o += char(c);
        }
    }
    return o + "\"";
}

std::string dump(const Value& v) {
    switch (v.type()) {
        case Value::NUL: return "null";
        case Value::BOOL: return v.boolean() ? "true" : "false";
        case Value::NUM: {
            double n = v.num();
            char b[40];
            if (!std::isfinite(n)) return "null";
            if (n == std::floor(n) && std::fabs(n) < 9.007199254740992e15) std::snprintf(b, sizeof b, "%.0f", n);
            else std::snprintf(b, sizeof b, "%.17g", n);
            return b;
        }
        case Value::STR: return quote(v.str());
        case Value::ARR: {
            std::string o = "[";
            for (size_t k = 0; k < v.items().size(); k++) o += (k ? "," : "") + dump(v.items()[k]);
            return o + "]";
        }
        default: {
            std::string o = "{";
            bool first = true;
            for (auto& m : v.members()) { o += (first ? "" : ",") + quote(m.first) + ":" + dump(m.second); first = false; }
            return o + "}";
        }
    }
}

}
