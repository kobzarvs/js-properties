#!/usr/bin/env coffee

class exports.Properties
    HOOK_FUNCTIONS = [ 'get', 'set', 'before_get', 'after_get', 'before_set', 'after_set'  ]

    property: (pname, desc ) ->
        return null if pname in HOOK_FUNCTIONS

        unless desc.get? then desc.get = () -> @_prop[pname]
        unless desc.set? then desc.set = (val) -> @_prop[pname] = val

        for foo in HOOK_FUNCTIONS
            if desc[foo]? then desc[foo] = desc[foo].bind(this)

        description = {}
        description.get = ->
            desc.before_get?()
            result = desc.get()
            desc.after_get?()
            result

        description.set = (val) ->
            desc.before_set?(val)
            desc.set(val)
            desc.after_set?(val)
            val

        @_prop ?= {}
        @_prop[pname] = null
        Object.defineProperty this, pname, description
        @_prop

    create_context: ->
        new class extends Properties

    properties: (plist) ->
        for k, v of plist
            if typeof v is 'object'
                p_list = @property k, v
                if p_list?
                    p_list[ k ] = @create_context()
                    @properties.call( p_list[ k ], v )
                    unless p_list[ k ]._prop
                        p_list[ k ] = null

    to_JSON: ->
        return null unless @_prop?
        json = {}
        for name, value of @_prop
            json[name] = if typeof value is 'object'
                @to_JSON.call( value )
            else
                value
        return json
