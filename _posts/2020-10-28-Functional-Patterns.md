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
To do this there are two functions, **pure** and **apply**

**pure** will lift a value into the elecated world

**apply** will unpack a function wraped inside an elevated value into a lifted function



```fsharp
let optionpure x = Some x // 'a -> 'a option
```


```fsharp
let optionapply fn opt = //(('a -> 'b) option) => 'a option -> 'b option
    match (fn, opt) with
        | Some fn, Some x -> Some (fn x)
        | None,    _      -> None
        | _,       None   -> None
```


```fsharp
optionapply
```


    val it : (Option<('a -> 'b)> -> Option<'a> -> Option<'b>)


##### we can see how similar the apply function is to map

**map**     ( 'a -> 'b ) -> 'a option -> 'b option 

**apply**   (('a -> 'b) option) => 'a option -> 'b option

##### this is because every Applicative is also a functor

imagen we have two option strings, and if both are some we want to seperate them with a space


```fsharp
let seperateWithSpace x y = x + " " + y
```


```fsharp
let s1 = Some "a"
let s2 = Some "b"
let s3 : Option<string> = None
```


```fsharp
let combineString1 = optionapply ( optionapply ( optionpure seperateWithSpace) s1) s3 
// this is hard to read but he does then he does it with infix in haskel which you cant do in f# so ¯\_(ツ)_/¯
```


```fsharp
// acutaly you do it this way
let resultOfThis = 
    let (<*>) = optionapply
    optionpure seperateWithSpace <*> s1 <*> s2

resultOfThis
```




    Some "a b"



##### You can simplify this further with map


```fsharp
let resultOfThis2 = 
    let (<*>) = optionapply
    let (<!>) = optionmap
    seperateWithSpace <!> s1 <*> s2
resultOfThis2    
```




    Some "a b"



# Monad

Monad is used for transforming values and structures together.
Lets look at signatures for map and apply to understand mondads.

**Functor map**         `(a->b) -> E<a> -> E<b>`

**Applicative apply**   `E<(a->b)> -> E<a> -> E<b>`

all monads are functors and applicatives but have one more function, bind. Bind looks like

**Monad bind**          `(a->E<b>) -> E<a> -> E<b>`


##### option is a monad.


```fsharp
let optionbind fn opt = 
    match opt with
        | Some x -> fn x 
        | None   -> None
optionbind
```


    val it : (('a -> Option<'b>) -> Option<'a> -> Option<'b>)


##### list is a monad


```fsharp
let rec listbind fn lst = 
    match lst with 
        | x ::xs -> fn x @ listbind fn xs
        | []     -> []
        
listbind
```


    val it : (('a -> 'b list) -> 'a list -> 'b list)


### Using the option Monad


```fsharp
let parseInt str = 
    match str with 
        | "-1" -> Some -1
        | "0"  -> Some 0
        | "1"  -> Some 1
        | "2"  -> Some 2
        | _    -> None
parseInt    
```




    <fun:it@8-21> : (string -> Option`1)




```fsharp
type OrderQty = OrderQty of int

let toOrderQty qty = 
    if qty >= 1 then
        Some (OrderQty qty)
    else 
        None
toOrderQty
```




    <fun:it@8-22> : (int -> Option`1)




```fsharp
let partseOrderQty str = 
    parseInt str
    |> optionbind toOrderQty
partseOrderQty
```




    <fun:it@4-23> : (string -> Option`1)




```fsharp
partseOrderQty "1"
```




    Some (OrderQty 1)




```fsharp
partseOrderQty "-1"
```




    None




```fsharp

```
