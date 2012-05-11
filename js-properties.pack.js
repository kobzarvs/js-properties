(function(){var k=[].indexOf||function(b){for(var c=0,d=this.length;c<d;c++)if(c in this&&this[c]===b)return c;return-1},l={}.hasOwnProperty,m=function(b,c){function d(){this.constructor=b}for(var a in c)l.call(c,a)&&(b[a]=c[a]);d.prototype=c.prototype;b.prototype=new d;b.__super__=c.prototype;return b};this.Properties=function(){function b(){}var c;b.name="Properties";c="localStorage cookie get set before_get after_get before_set after_set".split(" ");b.prototype.save_property=function(d,a){switch(d.storage.type){case "cookie":return $.cookie(d.storage.context,
JSON.stringify(a),{expires:1E3,raw:!0}),$.cookie(d.context);case "localStorage":return localStorage.setItem(d.storage.context,JSON.stringify(a))}};b.prototype.property=function(d,a){var b,e,f;if(0<=k.call(c,d))return null;this._desc=a;null==a.get&&(a.get=function(){return this._prop[d]});null==a.set&&(a.set=function(a){return this._prop[d]=a});e=0;for(f=c.length;e<f;e++)b=c[e],null!=a[b]&&"function"===typeof a[b]&&(a[b]=a[b].bind(this));null==this._prop&&(this._prop={});this._prop[d]=void 0;Object.defineProperty(this,
d,{get:function(){var b;if(this._prop===void 0&&a.storage!=null){switch(a.storage.type){case "cookie":b=$.cookie(a.context);break;case "localStorage":b=localStorage.getItem(a.context)}b!=null&&(this._prop[d]=JSON.parse(b))}typeof a.before_get==="function"&&a.before_get(this._prop[d]);b=a.get(this._prop[d]);typeof a.after_get==="function"&&a.after_get(this._prop[d]);a.storage!=null&&this.save_property(a,b);return b},set:function(b){var c,e;c=this._prop[d];if((e=typeof a.before_set==="function"?a.before_set(b,
c):void 0)||e===void 0){a.set(b,c);typeof a.after_set==="function"&&a.after_set(b,c)}a.storage!=null&&this.save_property(a,this._prop[d]);return b}});return this._prop};b.prototype.create_context=function(){return new (function(b){function a(){return a.__super__.constructor.apply(this,arguments)}m(a,b);return a}(b))};b.prototype.cookies=function(b){return this.properties(b,"cookie")};b.prototype.localStorage=function(b,a){return!("string"===typeof b&&"object"===typeof a)?null:this.properties(a,"localStorage",
b)};b.prototype.properties=function(b,a,c){var e,f,g,j,i,h;null==a&&(a=!1);null==c&&(c=this.name);h=[];for(f in b)if(i=b[f],"object"===typeof i)if(g=this.property(f,i),null!=g)if(e=c+"."+f,g[f]=this.create_context(),this.properties.call(g[f],i,a,e),g[f]._prop)h.push(void 0);else if(a){i.storage={type:a,context:e};switch(a){case "cookie":j=$.cookie(e);break;case "localStorage":j=localStorage.getItem(e)}h.push(g[f]=JSON.parse(j))}else h.push(g[f]=null);else h.push(void 0);else h.push(void 0);return h};
b.prototype.to_JSON=function(){var b,a,c,e;if(null==this._prop)return null;b={};e=this._prop;for(a in e)c=e[a],b[a]="object"===typeof c?this.to_JSON.call(c):this[a];return b};return b}()}).call(this);
