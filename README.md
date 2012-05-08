__Sample code:__
```coffee
lib = require('./js-properties.js')

console.log lib.Properties

class TestClass extends lib.Properties
  constructor: ->
    @name = 'TestClass'

    #
    # create cookie tree in browser
    #   TestClass.cookie_1.cookie_1_1 = ...
    #   TestClass.cookie_1.cookie_1_2 = ...
    #
    @cookie
      cookie_1:
        cookie_1_1:
          before_set: =>
            ...
        cookie_1_2:
          before_get: =>
            ...
          after_set: =>
            ...

    @properties
      root:
        flag:
          # [get | set | before_get | before_set | after_get | after_set]: =>
          before_get: =>
            console.log 'before get'
          before_set: =>
            console.log 'before set'

test = new TestClass

test.root.flag = 1
console.log test.root.flag
console.log test.to_JSON()
console.log test.root.to_JSON()
```
__Output:__
    
    [Function: Properties]
    before set
    before get
    1
    { root: { flag: 1 } }
    { flag: 1 }

