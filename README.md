__Sample code:__
```coffee
# use require command if you run with node.js
lib = require('./js-properties.js')

console.log lib.Properties

class TestClass extends lib.Properties
  constructor: ->
    @name = 'TestClass'

    # create cookie tree in browser
    #   TestClass.cookie_1.cookie_1_1 = ...
    #   TestClass.cookie_1.cookie_1_2 = ...
    #
    @cookie
      cookie_1:
        cookie_1_1:
          [get | set | before_get | before_set | after_get | after_set]: =>
            ...

    # save data to localStorage session object
    # support by Chrome / Safari
    #
    @localStorage 'storage_name'
      struct_1:
        field_1_1: {}
          field_1_1_1:
            [get | set | before_get | before_set | after_get | after_set | {}]: =>
              ...
          field_1_1_2:
            [get | set | before_get | before_set | after_get | after_set | {}]: =>
              ...

    # simple tree of DOM properties
    #
    @properties
      root:
        flag:
          [get | set | before_get | before_set | after_get | after_set | {}]: =>
            ...

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

