# Working Through F#

```f#

// Functional Datastructures and Algorithims

///
/// Some Basics
/// 

//array access
let GuardiansOfGalaxy = [| "Peter Quill"; "Gamora"; "Drax"; "Groot";
    "Rocket"; "Ronan"; "Yondu Udonta"; "Nebula"; "Korath"; "Corpsman
    Dey";"Nova Prime";"The Collector";"Meredith Quill" |]
let iAmGroot = GuardiansOfGalaxy.[3];
printfn "%c" iAmGroot.[2] // o 

// create array with range
let OneToHundred = [|1..100|]
//slice array
let TopThree = OneToHundred.[0..2]

//Functions
let add x y = x + y

//partial application
let Add10 = add 10
Add10 5

// Higher Order Functions
let increment n = n + 1
let InvokeThrice n (f:int->int) = f(f(f(n)))
InvokeThrice 3 increment

//Lambdas
InvokeThrice 80 ( fun n -> n / 2)

//Mapping
let nums = [|0..20|]
let squares : int [] = 
    nums 
    |> Array.map ( fun n -> n * n )
squares

// Folding ( folding is agregating functions)
// lambda takes acumulator and array 
Array.fold (fun acc n -> acc + n ) 0 squares   // can be reduced to -> Array.fold (( + ) ) 0 squares

//Zipping
// takes two collections and combines them 
let firstNames = [| "Leonard"; "Sheldon"; "Howard"; "Penny"; "Raj";
"Bernadette"; "Amy" |]
let lastNames = [| "Hofstadter"; "Cooper"; "Wolowitz"; "";
"Koothrappali"; "Rostenkowski"; "Fowler" |]
let fullNames = Array.zip(firstNames) lastNames


//lazy evaluation
let devide x y = 
    printfn "dividing %d by %d" x y
    x / y

let answer = lazy(devide 8 2)

printfn "%d" (answer.Force()) 

///
/// Learning With Factorial
/// 

// recursion factorial

let rec factorial n = 
    if n < 1 then 1
    else n * factorial ( n - 1 )

let rec factorialWithPatternMatch n = 
    match n with 
    | 0 | 1 -> 1
    | _ -> n * factorialWithPatternMatch(n-1)

factorialWithPatternMatch 10
factorial 10

// tail recusion -> optimisation, using the accum variable we no longer need to take up stack space. The CLR imp is identical to while loop
let tailFactorial n = 
    let rec tailRecFact n accum = 
        if n <= 1 then 
            accum
        else 
            tailRecFact (n - 1) (accum * n)
    tailRecFact n 1

// factorial with continuation
// the continuation is a function that is passed to a function to instruct it on what to do next.
// this is simalar to the tailFactorial except we pass in a continuation instead of the accumulator

let factorialContinuation n = 
    let rec contTailRecFact n f = 
        if n <= 1 then 
            f()
        else 
            contTailRecFact (n-1) (fun () -> n * f())
    contTailRecFact n ( fun () -> 1)

// folding factorial
let factorialFold n = 
    [1..n]
    |> List.fold (*) 1

// reducing factorial 
let factorialReduce n = 
    [1..n]
    |> List.reduce (*)

///
/// Learning with Fibonacci
///

// similar to factorials
let rec fibonacci n = 
    if n <= 2 then 1
    else fibonacci (n-1) + fibonacci (n-2)

// tail recursion prevents stack overflow

let fibonacciTailRecursion n = 
    let rec fibonacciX (n, x, y) = 
        if (n = 0I) then x //(0I) defines 0 big int
        else fibonacciX ((n-1I), y, (x+y))
    fibonacciX (n, 0I, 1I)

  
// fibonacci with memoization ( caches previous results )

open System.Collections.Generic

let rec fibonacciGeneric n = 
    let cache = Dictionary<_,_>()
    let rec fibonacciX = function
        | n when n = 0I -> 0I
        | n when n = 1I -> 1I
        | n -> fibonacciX (n - 1I) + fibonacciX (n-2I)
    if cache.ContainsKey(n) then cache.[n]
    else 
        let result = fibonacciX n 
        cache.[n] <- result
        result
```
