// Generated by CoffeeScript 1.3.1
var first, pop, push,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

pop = function(o) {
  var i, result;
  for (i in o) {
    result = [i, o[i]];
    delete o[i];
    return result;
  }
  return null;
};

push = function(prop, name, val) {
  prop[name].push(val);
  return prop[name] = prop[name];
};

first = function(o) {
  var i;
  for (i in o) {
    return [i, o[i]];
  }
};

this.Properties = (function() {
  var TRIGGERS;

  Properties.name = 'Properties';

  function Properties() {}

  TRIGGERS = ['localStorage', 'cookie', 'get', 'set', 'before_get', 'after_get', 'before_set', 'after_set'];

  Properties.prototype.save_property = function(desc, value) {
    var tmp;
    switch (desc.storage.type) {
      case 'cookie':
        $.cookie(desc.storage.context, JSON.stringify(value), {
          expires: 1000,
          raw: true
        });
        return tmp = $.cookie(desc.context);
      case 'localStorage':
        return tmp = localStorage.setItem(desc.storage.context, JSON.stringify(value));
    }
  };

  Properties.prototype.property = function(pname, desc) {
    var description, foo, _i, _len;
    if (__indexOf.call(TRIGGERS, pname) >= 0) {
      return null;
    }
    this._desc = desc;
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
    for (_i = 0, _len = TRIGGERS.length; _i < _len; _i++) {
      foo = TRIGGERS[_i];
      if ((desc[foo] != null) && typeof desc[foo] === 'function') {
        desc[foo] = desc[foo].bind(this);
      }
    }
    description = {};
    description.get = function() {
      var result, tmp;
      if (this._prop === void 0 && (desc.storage != null)) {
        switch (desc.storage.type) {
          case 'cookie':
            tmp = $.cookie(desc.context);
            break;
          case 'localStorage':
            tmp = localStorage.getItem(desc.context);
        }
        if (tmp != null) {
          this._prop[pname] = JSON.parse(tmp);
        }
      }
      if (typeof desc.before_get === "function") {
        desc.before_get(this._prop[pname]);
      }
      result = desc.get(this._prop[pname]);
      if (typeof desc.after_get === "function") {
        desc.after_get(this._prop[pname]);
      }
      if (desc.storage != null) {
        this.save_property(desc, result);
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
      if (desc.storage != null) {
        this.save_property(desc, this._prop[pname]);
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
    return this.properties(plist, 'cookie');
  };

  Properties.prototype.localStorage = function(storage, plist) {
    if (!(typeof storage === 'string' && typeof plist === 'object')) {
      return null;
    }
    return this.properties(plist, 'localStorage', storage);
  };

  Properties.prototype.properties = function(plist, storage_type, context) {
    var full_name, k, p_store, tmp, v, _results;
    if (storage_type == null) {
      storage_type = false;
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
          full_name = context + '.' + k;
          p_store[k] = this.create_context();
          this.properties.call(p_store[k], v, storage_type, full_name);
          if (!p_store[k]._prop) {
            if (!storage_type) {
              _results.push(p_store[k] = null);
            } else {
              v.storage = {
                type: storage_type,
                context: full_name
              };
              switch (storage_type) {
                case 'cookie':
                  tmp = $.cookie(full_name);
                  break;
                case 'localStorage':
                  tmp = localStorage.getItem(full_name);
              }
              _results.push(p_store[k] = JSON.parse(tmp));
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
