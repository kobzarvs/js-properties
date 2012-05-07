#!/usr/local/bin/coffee

lib = require('./js-properties.js')

console.log lib.Properties

class TestClass extends lib.Properties
    constructor: ->
        @properties
            root:
                flag:
                    before_get: =>
                        console.log 'before get'
                    before_set: =>
                        console.log 'before set'

test = new TestClass

test.root.flag = 1
console.log test.root.flag
console.log test.to_JSON()
console.log test.root.to_JSON()
