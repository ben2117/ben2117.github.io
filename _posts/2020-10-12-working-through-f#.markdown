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


///
/// Towers of Hanoi
///

let rec TowerOfHanoi f x t n = 
    if n > 0 then
        TowerOfHanoi f t x (n-1)
        printfn "Move disc from %c to %c" f t
        TowerOfHanoi x f t (n-1)

TowerOfHanoi 'a' 'b' 'c' 2

// aparently that was not idomatic f#. for some reason this is better

let rec TowerOfHanoiRec n s f = 
    match n with 
    | 0 -> []
    | _ -> 
        let t = (6 - s - f)
        (TowerOfHanoiRec (n-1) s t) @ [s,f] @ (TowerOfHanoiRec(n-1) t f) // the @ concatinates lists
// I will leave this here as I dont understand the point the following "improvements"

//
// Lazy Evaluations
//

let x = lazy(printfn "Lazy Evaluation"; 2*2)
x
x.Value

// lazy quicksort
// the quicksort algorithm
    // 1. Select a pivot from given array
    // 2. Partition data into two lists. Elements with values less then the pivot go in the first list and elements greater go in the second
    // 3. recursivly call
    // 4. combine

// :: operator paternmatches? with the list so that n is the first element of the list see below

//takes the head of the list and puts it on the end
let dotDotexamp n = 
    match n with 
    | [] -> []
    | h::t -> 
        let head, tail = h, t
        tail @ [head]

// above can be reduced to 
let dotDotShorter = function
    | [] -> []
    | h::t -> 
        let head, tail = h, t
        tail @ [head]

//partition example
let partitionExamp inList = 
    let firstPart, secondPart = List.partition ( fun a -> a > 5 ) inList
    (firstPart, secondPart)

//can be reduced to
let partitionExampSimpler inList = 
  List.partition ( (>) 5 ) inList

let joinTwoListsExample = [1; 2; 3] @ [2]

// and after all of that i still dont understand it . 
let rec quickSort = function
    | [] -> []
    | n::ns -> 
        let lessthen, greaterEqual = List.partition ((>) n ) ns
        quickSort lessthen @ n :: quickSort greaterEqual


///
/// Data Structures 
/// 


//
// Arrays, just a basic array. they are mutable 
//

//array forward count 
let CountTo1000By100 = [|1..100..1000|]

//array reverse count
let ReverseCount100 = [|100..-1..1|]

//array create zero
let arrayLength = 23
let stringZerps : string[] = Array.zeroCreate arrayLength

//array create
let SixSixers = Array.create 6 6

//array init
let ArrayofCubes = (Array.init 10 (fun index -> index * index * index))

//Retreiving Arrays
let imdb : string[] = [|
    "The Shawshank Redemption (1994)";
    "The Godfather (1972)";
    "The Godfather: Part II (1974)";
    "Il buono, il brutto, il cattivo. (1966)";
    "Pulp Fiction (1994)";
    "Inception (2010)";
    "Schindler's List (1993)";
    "12 Angry Men (1957)";
    "One Flew Over the Cuckoo's Nest (1975)";
    "The Dark Knight (2008)"
|]

//get the top 3
imdb.[1..3]
// get the top 4
imdb.[1..5]
//bottom 5
imdb.[5..]
//all
imdb.[0..]

// multidimensional arrays
let md = Array3D.zeroCreate<int> 11 11 11
// assign value to array
md.[0,0,0] <- 1
md.[0,0,0]

//
// Lists, are immutable, are ordered, singly linked implementation
//

// correct way
let numbers = [0; 1; 2; 3; 4; 5; 6; 7; 8; 9] 
// 0.o nb this makes tuple, so probably not what you want
let listTupleNumbers = [0, 2, 3, 4, 5, 6]

// lists can use recursion and pattern matching for 
let l1 = ["one"; "two"; "three"]
let l2 = "four"::l1
let l3 = [l1.[1].[0..1] + "ed"]
let l4 = l2 @ l3

// Motherflipping list comprehensions. 
```
