class UserClass extends Properties
  constructor: (args...)->
    @properties
      property_name_1:
        [get/set/before_get/before_set/after_get/after_set] =>
          ...
        property_name_1_1:
          get: =>
            ...
          set: =>
            ...
          [before_get/before_set/after_get/after_set] =>
            ...
        property_name_1_2:
        ...

test = new UserClass
test.property_name_1.property_name_1_1 = 'test value'
console.log test.property_name_1.property_name_1_1

tree = test.to_JSON

> { property_name_1:
>   { property_name_1_1: 'test value', 
>     property_name_1_2: null
>   }
> }

