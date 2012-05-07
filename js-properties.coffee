#
#  class UserClass extends Properties
#    constructor: (args...)->
#      @properties
#        property_name_1:
#          [get/set/before_get/before_set/after_get/after_set] =>
#            ...
#          property_name_1_1:
#            get: =>
#              ...
#            set: =>
#              ...
#            [before_get/before_set/after_get/after_set] =>
#              ...
#          property_name_1_2:
#          ...
#
#  test = new UserClass
#  test.property_name_1.property_name_1_1 = 'test value'
#  console.log test.property_name_1.property_name_1_1
#

class Properties
    property: (pname, desc ) ->
        return null if pname in [ 'get', 'set', 'before_get', 'after_get', 'before_set', 'after_set'  ]

        unless desc.get? then desc.get = (   ) => @_prop[pname]
        unless desc.set? then desc.set = (val) => @_prop[pname] = val

        description = {}
        description.get = ->
            desc.before_get?.bind(this)()
            result = desc.get.bind(this)()
            desc.after_get?.bind(this)()
            result
        description.set = (val) ->
            desc.before_set?.bind(this, val)()
            desc.set.bind(this, val)()
            desc.after_set?.bind(this, val)()
            val

        @_prop ?= {}
        @_prop[pname] = null
        Object.defineProperty this, pname, description
        @_prop

    create_context: -> new class extends Properties

    properties: (plist) ->
        for k, v of plist
            if typeof v is 'object'
                properties_list = @property k, v
                properties_list[ k ] = @create_context()
                @properties.bind( properties_list[k], v )()


#
#  Test Class
#
class C1 extends Properties

    constructor: ->
        @properties
            mode:
                before_get: =>
                    console.log "BEFORE GET mode"

                video: {}
                
                flag:
                    before_set: (val) ->
                        console.log "BEFORE SET flag: #{val}"
                    set: (val) =>
                        console.log "SET flag: #{val}"
                        @flag = val
                    after_set: (val) ->
                        console.log "AFTER SET flag: #{val}"
                    before_get: =>
                        console.log "BEFORE GET flag"
                    get: =>
                        console.log "GET flag"
                        @flag
                    after_get: ->
                        console.log "AFTER GET flag"

#
#  Test
#
test = new C1

test.mode.video = 111
console.log test.mode.video
test.mode.flag = 222
console.log test.mode.flag

