#!/usr/local/bin/coffee

pop = (o) -> 
    for i of o
        result = [i, o[i]]
        delete o[i]
        return result
    return null

first = (o) -> for i of o then return [i, o[i]]


class this.Properties
    TRIGGERS = [ 'localStorage', 'cookie', 'get', 'set', 'before_get', 'after_get', 'before_set', 'after_set'  ]

    save_property: (desc, value) ->
        switch desc.storage.type
            when 'cookie'
                $.cookie desc.storage.context, JSON.stringify(value), {expires: 1000, raw:true}
                tmp = $.cookie desc.context
            when 'localStorage'
                tmp = localStorage.setItem desc.storage.context, JSON.stringify(value)

    property: (pname, desc ) ->
        return null if pname in TRIGGERS

        unless desc.get? then desc.get = () -> @_prop[pname]
        unless desc.set? then desc.set = (val,old) -> @_prop[pname] = val

        for foo in TRIGGERS
            if desc[foo]? and typeof desc[foo] is 'function'
                desc[foo] = desc[foo].bind(this)

        description = {}
        
        description.get = ->
            # если при чтении свойства его значение еще не установлено
            # пытаемся найти его значение в хранилище
            if @_prop is undefined and desc.storage?
                switch desc.storage.type
                    when 'cookie'
                        tmp = $.cookie desc.context
                    when 'localStorage'
                        tmp = localStorage.getItem desc.context
                if tmp? then @_prop[pname] = JSON.parse tmp
            
            desc.before_get?(@_prop[pname])
            result = desc.get(@_prop[pname])
            desc.after_get?(@_prop[pname])
            
            # если для свойства определено хранилище - сохраняем в нем значние
            if desc.storage?
                @save_property(desc, result)
            return result

        description.set = (val) ->
            old = @_prop[pname]
            result = desc.before_set?(val,old)
            if result or result is undefined
                desc.set(val,old)
                desc.after_set?(val,old)

            # если для свойства определено хранилище - сохраняем в нем значние
            if desc.storage?
                @save_property(desc, @_prop[pname])
            return val

        @_prop ?= {}
        @_prop[pname] = undefined
        Object.defineProperty this, pname, description
        return @_prop

    create_context: ->
        new class extends Properties

    cookies: (plist) ->
        @properties plist, 'cookie'


    localStorage: (storage, plist) ->
        return null unless typeof storage is 'string' and typeof plist is 'object'
        @properties plist, 'localStorage', storage


    properties: (plist, storage_type = off, context = @name) ->
        for k, v of plist
            if typeof v is 'object'
                p_store = @property k, v
                if p_store?
                    full_name = context + '.' + k
                    p_store[ k ] = @create_context()
                    @properties.call( p_store[ k ], v, storage_type, full_name )

                    # если созданное свойство не является контейнером для потомков,
                    # присваиваем значение по умолчанию или из хранилища
                    unless p_store[ k ]._prop
                        unless storage_type
                            p_store[ k ] = null
                        else
                            v.storage = { type: storage_type, context: full_name }
                            switch storage_type
                                when 'cookie'
                                    tmp = $.cookie( full_name )
                                when 'localStorage'
                                    tmp = localStorage.getItem( full_name )
                            p_store[ k ] = JSON.parse tmp

    to_JSON: ->
        return null unless @_prop?
        json = {}
        for name, value of @_prop
            json[name] = if typeof value is 'object'
                @to_JSON.call( value )
            else
                this[name]
        return json
