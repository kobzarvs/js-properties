#!/usr/local/bin/coffee

lib = require('./js-properties.js')

console.log lib.Properties

class TestClass extends lib.Properties
    constructor: ->
        @name = 'TestClass'
        @properties
            root:
                flag_1:
                    flag_3:
                        before_get: =>
                            console.log 'before get'
                        before_set: =>
                            console.log 'before set'
                flag_2:
                    before_get: =>
                        console.log 'before get'
                    before_set: =>
                        console.log 'before set'

test = new TestClass

test.root.flag_2 = 2
test.root.flag_1.flag_3 = 3
#console.log test.root.flag_2
#console.log test.root.flag_1.flag_3
console.log 'to JSON'
console.log test.to_JSON()
console.log test.root.to_JSON()

