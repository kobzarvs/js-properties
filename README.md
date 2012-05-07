```coffee
lib = require('./js-properties.js')

console.log lib.Properties

class TestClass extends lib.Properties
  constructor: ->
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
  OUTPUT:

  [Function: Properties]
  before set
  before get
  1
  { root: { flag: 1 } }
  { flag: 1 }
