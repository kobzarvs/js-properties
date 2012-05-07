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
                properties_list = @property k, v
                if properties_list?
                    properties_list[ k ] = @create_context()
                    @properties.bind( properties_list[ k ], v )()
                    unless properties_list[ k ]._prop
                        properties_list[ k ] = null

    counter = 0

    properties_toJSON: (obj=this) ->
        return null unless obj? and typeof obj is 'object' and obj._prop?
        console.log obj._prop
        json = {}
        for pname, pvalue of obj._prop
            #console.log pname
            json[pname] = if typeof pvalue is 'object' and pvalue?
                @properties_toJSON(pvalue) #.bind( pvalue )()
            else
                pvalue
        return json
            
#
#  Test Class
#
class C1 extends Properties

    constructor: ->
        @context = "ROOT CONTEXT"
        @root =
        @properties
            mode:
                before_get: ->
                    console.log "BEFORE GET mode  [#{@context}]"

                video: {}
                
                flag:
                    before_set: (val) ->
                        console.log "BEFORE SET flag: [#{@context}] #{@_prop.flag}"
                    set2: (val) =>
                        #console.log "SET flag: #{val}"
                        #@flag = val
                    after_set: (val) ->
                        #console.log "AFTER SET flag: #{val}"
                    before_get: =>
                        #console.log "BEFORE GET flag"
                    get2: =>
                        #console.log "GET flag"
                        #@flag
                    after_get: ->
                        #console.log "AFTER GET flag"
#
#  Test
#
test = new C1

test.mode.video = 111
console.log test.properties_toJSON(null)
#test.mode.flag = 222
#console.log test.mode.flag
#test.mode.flag = 222
#console.log test.mode.flag

