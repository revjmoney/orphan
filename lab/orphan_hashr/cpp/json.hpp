// [orphan] H4SHR-CH3KR hashrd: a small JSON value, reader and writer (stratum lines, the web API). Standard library
// only. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <map>
#include <memory>
#include <string>
#include <vector>

namespace json {

class Value {
public:
    enum Type { NUL, BOOL, NUM, STR, ARR, OBJ };
    Value() = default;
    Value(bool b) : t_(BOOL), b_(b) {}
    Value(double n) : t_(NUM), n_(n) {}
    Value(int n) : t_(NUM), n_(n) {}
    Value(long long n) : t_(NUM), n_(double(n)) {}
    Value(unsigned long long n) : t_(NUM), n_(double(n)) {}
    Value(const char* s) : t_(STR), s_(s) {}
    Value(std::string s) : t_(STR), s_(std::move(s)) {}
    static Value array() { Value v; v.t_ = ARR; return v; }
    static Value object() { Value v; v.t_ = OBJ; return v; }

    Type type() const { return t_; }
    bool is_null() const { return t_ == NUL; }
    bool is_array() const { return t_ == ARR; }
    bool is_object() const { return t_ == OBJ; }
    bool is_string() const { return t_ == STR; }
    bool is_number() const { return t_ == NUM; }
    bool boolean() const { return t_ == BOOL && b_; }
    double num(double dflt = 0) const { return t_ == NUM ? n_ : dflt; }
    const std::string& str() const { static const std::string e; return t_ == STR ? s_ : e; }
    size_t size() const { return t_ == ARR ? a_.size() : t_ == OBJ ? o_.size() : 0; }

    const Value& operator[](size_t i) const;            // missing: a null value
    const Value& operator[](const std::string& k) const;
    bool has(const std::string& k) const { return t_ == OBJ && o_.count(k); }
    Value& push(Value v);                               // array append (turns a null into an array)
    Value& set(const std::string& k, Value v);          // object member (turns a null into an object)
    const std::vector<Value>& items() const { return a_; }
    const std::map<std::string, Value>& members() const { return o_; }

private:
    friend bool parse(const std::string&, Value&);
    friend struct Parser;
    Type t_ = NUL;
    bool b_ = false;
    double n_ = 0;
    std::string s_;
    std::vector<Value> a_;
    std::map<std::string, Value> o_;
};

bool parse(const std::string& text, Value& out);       // false on any syntax error
std::string dump(const Value& v);                       // compact, numbers as integers when they are whole
std::string quote(const std::string& s);                // a JSON string literal

}
