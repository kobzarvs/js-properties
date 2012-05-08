#!/usr/local/bin/coffee

class this.Properties
    HOOK_FUNCTIONS = [ 'cookie', 'get', 'set', 'before_get', 'after_get', 'before_set', 'after_set'  ]

    property: (pname, desc ) ->
        return null if pname in HOOK_FUNCTIONS

        unless desc.get? then desc.get = () -> @_prop[pname]
        unless desc.set? then desc.set = (val) -> @_prop[pname] = val

        for foo in HOOK_FUNCTIONS
            if desc[foo]? and typeof desc[foo] is 'function'
                desc[foo] = desc[foo].bind(this)

        description = {}
        description.get = ->
            if desc.cookie?
                @_prop[pname] = $.cookie pname
            desc.before_get?()
            result = desc.get()
            desc.after_get?()
            result

        description.set = (val) ->
            desc.before_set?(val)
            desc.set(val)
            desc.after_set?(val)
            if desc.cookie?
                $.cookie pname, val
            val

        @_prop ?= {}
        @_prop[pname] = null
        Object.defineProperty this, pname, description
        @_prop

    create_context: ->
        new class extends Properties

    cookies: (plist) ->
        @properties plist, on

    properties: (plist, cookies = off, context = @name) ->
        console.log 'context: ' + context
        for k, v of plist
            if typeof v is 'object'
                p_store = @property k, v
                if p_store?
                    p_store[ k ] = @create_context()
                    @properties.call( p_store[ k ], v, cookies, context + '.' + k )
                    unless p_store[ k ]._prop
                        if cookies
                            v.cookie = {}
                            p_store[ k ] = $.cookie context
                        else
                            p_store[ k ] = null

    to_JSON: ->
        return null unless @_prop?
        json = {}
        for name, value of @_prop
            json[name] = if typeof value is 'object'
                @to_JSON.call( value )
            else
                value
        return json
