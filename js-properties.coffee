#!/usr/local/bin/coffee
class this.Properties
    HOOK_FUNCTIONS = [ 'cookie', 'get', 'set', 'before_get', 'after_get', 'before_set', 'after_set'  ]

    property: (pname, desc ) ->
        return null if pname in HOOK_FUNCTIONS

        unless desc.get? then desc.get = () -> @_prop[pname]
        unless desc.set? then desc.set = (val,old) -> @_prop[pname] = val

        for foo in HOOK_FUNCTIONS
            if desc[foo]? and typeof desc[foo] is 'function'
                desc[foo] = desc[foo].bind(this)

        description = {}
        description.get = ->
            if @_prop is undefined and desc.cookie?
                cookie_value = JSON.parse( $.cookie desc.cookie.context )
                if cookie_value? then @_prop[pname] = cookie_value
            desc.before_get?()
            result = desc.get()
            desc.after_get?()
            if desc.cookie?
                $.cookie desc.cookie.context, JSON.stringify( result ), {expires: 10000, raw:true}
            result

        description.set = (val) ->
            old = @_prop[pname]
            result = desc.before_set?(val,old)
            if result or result is undefined
                desc.set(val,old)
                desc.after_set?(val,old)
            if desc.cookie?
                $.cookie desc.cookie.context, JSON.stringify( val ), {expires: 10000, raw:true}
            val

        @_prop ?= {}
        @_prop[pname] = undefined
        Object.defineProperty this, pname, description
        @_prop

    create_context: ->
        new class extends Properties

    cookies: (plist) ->
        @properties plist, 'cookies'

    localStorage: (plist) ->
        @properties plist, 'localStorage'

    properties: (plist, cookies = off, context = @name) ->
        for k, v of plist
            if typeof v is 'object'
                p_store = @property k, v
                if p_store?
                    p_store[ k ] = @create_context()
                    @properties.call( p_store[ k ], v, cookies, context + '.' + k )
                    unless p_store[ k ]._prop
                        if cookies
                            v.cookie = { context: context + '.' + k }
                            p_store[ k ] = JSON.parse( $.cookie v.cookie.context )
                        else
                            p_store[ k ] = null

    to_JSON: ->
        return null unless @_prop?
        json = {}
        for name, value of @_prop
            json[name] = if typeof value is 'object'
                @to_JSON.call( value )
            else
                this[name]
        return json
