// Generated by CoffeeScript 1.3.1
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.Properties = (function() {
    var HOOK_FUNCTIONS;

    Properties.name = 'Properties';

    function Properties() {}

    HOOK_FUNCTIONS = ['cookie', 'get', 'set', 'before_get', 'after_get', 'before_set', 'after_set'];

    Properties.prototype.property = function(pname, desc) {
      var description, foo, _i, _len;
      if (__indexOf.call(HOOK_FUNCTIONS, pname) >= 0) {
        return null;
      }
      if (desc.get == null) {
        desc.get = function() {
          return this._prop[pname];
        };
      }
      if (desc.set == null) {
        desc.set = function(val, old) {
          return this._prop[pname] = val;
        };
      }
      for (_i = 0, _len = HOOK_FUNCTIONS.length; _i < _len; _i++) {
        foo = HOOK_FUNCTIONS[_i];
        if ((desc[foo] != null) && typeof desc[foo] === 'function') {
          desc[foo] = desc[foo].bind(this);
        }
      }
      description = {};
      description.get = function() {
        var cookie_value, result;
        if (this._prop === void 0 && (desc.cookie != null)) {
          cookie_value = JSON.parse($.cookie(desc.cookie.context));
          if (cookie_value != null) {
            this._prop[pname] = cookie_value;
          }
        }
        if (typeof desc.before_get === "function") {
          desc.before_get();
        }
        result = desc.get();
        if (typeof desc.after_get === "function") {
          desc.after_get();
        }
        if (desc.cookie != null) {
          $.cookie(desc.cookie.context, JSON.stringify(result), {
            expires: 10000,
            raw: true
          });
        }
        return result;
      };
      description.set = function(val) {
        var old, result;
        old = this._prop[pname];
        result = typeof desc.before_set === "function" ? desc.before_set(val, old) : void 0;
        if (result || result === void 0) {
          desc.set(val, old);
          if (typeof desc.after_set === "function") {
            desc.after_set(val, old);
          }
        }
        if (desc.cookie != null) {
          $.cookie(desc.cookie.context, JSON.stringify(val), {
            expires: 10000,
            raw: true
          });
        }
        return val;
      };
      if (this._prop == null) {
        this._prop = {};
      }
      this._prop[pname] = void 0;
      Object.defineProperty(this, pname, description);
      return this._prop;
    };

    Properties.prototype.create_context = function() {
      return new ((function(_super) {

        __extends(_Class, _super);

        function _Class() {
          return _Class.__super__.constructor.apply(this, arguments);
        }

        return _Class;

      })(Properties));
    };

    Properties.prototype.cookies = function(plist) {
      return this.properties(plist, 'cookies');
    };

    Properties.prototype.localStorage = function(plist) {
      return this.properties(plist, 'localStorage');
    };

    Properties.prototype.properties = function(plist, cookies, context) {
      var k, p_store, v, _results;
      if (cookies == null) {
        cookies = false;
      }
      if (context == null) {
        context = this.name;
      }
      _results = [];
      for (k in plist) {
        v = plist[k];
        if (typeof v === 'object') {
          p_store = this.property(k, v);
          if (p_store != null) {
            p_store[k] = this.create_context();
            this.properties.call(p_store[k], v, cookies, context + '.' + k);
            if (!p_store[k]._prop) {
              if (cookies) {
                v.cookie = {
                  context: context + '.' + k
                };
                _results.push(p_store[k] = JSON.parse($.cookie(v.cookie.context)));
              } else {
                _results.push(p_store[k] = null);
              }
            } else {
              _results.push(void 0);
            }
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Properties.prototype.to_JSON = function() {
      var json, name, value, _ref;
      if (this._prop == null) {
        return null;
      }
      json = {};
      _ref = this._prop;
      for (name in _ref) {
        value = _ref[name];
        json[name] = typeof value === 'object' ? this.to_JSON.call(value) : this[name];
      }
      return json;
    };

    return Properties;

  })();

}).call(this);
