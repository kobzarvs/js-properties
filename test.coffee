#!/usr/local/bin/coffee

lib = require('./js-properties.js')

# console.log lib.Properties

class TestClass extends lib.Properties
    constructor: ->
        @name = 'TestClass'
        @properties
            root:
                flag_1:
                    flag_3:
                        before_set: (v1,v2) =>
                            console.log "before set flag_3 old: #{v2} new: #{v1}"
                            if v1 > 5 then false else true
                flag_2:
                    before_get: =>
                        console.log 'before get flag_2'
                    before_set: =>
                        console.log 'before set flag_2'

test = new TestClass

test.root.flag_1.flag_3 = 1
console.log test.root.flag_1.flag_3
test.root.flag_1.flag_3 = 6
console.log test.root.flag_1.flag_3
test.root.flag_1.flag_3 = 4
console.log test.root.flag_1.flag_3

console.log 'to JSON'
console.log test.to_JSON()

