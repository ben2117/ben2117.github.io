# Currying / Partial Application
##### whats the difference?


```fsharp
let add x y = x + y //int -> int -> int
```


```fsharp
let increment = add 1 // int -> int
```

# Sum Types

## Option Type


```fsharp
type Option<'a> =  // ( in built, this will override it)
    | Some of 'a
    | None 
```


```fsharp
let optionVal = Some 1  //Option<int>

match optionVal with 
    | Some x -> x + 1
    | None   -> 0
```




    2



## Choice Type


```fsharp
type Choice<'a, 'b> =  // ( in built, this will override it)
    | Choice1Of2 of 'a
    | Choice2Of2 of 'b
```


```fsharp
let theChoice : Choice<string, bool> = Choice2Of2 false
```


```fsharp
match theChoice with 
    | Choice1Of2 c -> c
    | Choice2Of2 c -> if c then "true" else "false"
```




    "false"



# Functor

##### Imagen we have three functions all converting different types to strings


```fsharp
let optionIntToString (i : Option<int>) = // int option -> string
    match i with
        | Some x -> string x
        | None   -> string None
```


```fsharp
let choiceIntToString (i: Choice<string, int>) = 
     match i with
        | Choice1Of2 x -> x
        | Choice2Of2 x -> string x
```


```fsharp
let listToString (i: List<int>) = 
    match i with 
        | [] -> ""
        | x  -> System.String.Join( ",", x)
```

##### Now when we want to do this same thing for decimal, or for some more complex type we will need to rewrite all of these. But! because option, choice, list are functors we can give them map ( or they are functors when they have a map? idk)
Map!, its signature looks like this

                                    `(a->b) -> E<a> -> E<b>`
                                    
If we have an int elevated to an option, map allows us to apply some function without leaving the elevated state of int.

##### As an exmaple Option is a functor, because we give it a map? Here is a reimplementation of Option map.
Map transforms the value inside the option, while maintaing the option wrapper


```fsharp
let optionmap fn opt = // ( 'a -> 'b ) -> 'a option -> 'b option 
    match opt with
        | Some x -> Some (fn x)
        | None   -> None
```


```fsharp
let addTwo n = n + 2 // int -> int
```


```fsharp
let five = Some 5 // int option

optionmap addTwo five
```




    Some 7




```fsharp
let noFive : Option<int> = None 

optionmap addTwo noFive
```




    None



##### lists are functors two so the map for list is


```fsharp
let rec listmap fn lst =  // ( 'a -> 'b ) -> 'a list -> 'b list 
    match lst with 
        | x :: xs -> fn x :: listmap fn xs // takes the head and applys function, append results of recursive call on tail
        | []      -> []
```

##### and finaly choice is a functor


```fsharp
let choicemap fn choice = // ( 'a -> 'b ) -> Choice<'c, 'a> -> Choice<'c, 'b>
    match choice with 
        | Choice1Of2 x -> Choice1Of2 x
        | Choice2Of2 x -> Choice2Of2 ( fn x )
```

# Applicative
### Similar to a functor, except transforms both structure and value instead of just value


```fsharp

```
