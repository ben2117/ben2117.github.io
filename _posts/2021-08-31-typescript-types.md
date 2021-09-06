```ts
////

/////

// type objects 
type Result = 
    | { status: "ok"}
    | { status: "error",
        reason?: string }

// Descriminated Unions 
type Square = {
    kind: "Square";
    size: number;
}

type Rectangle = {
    kind: "Rectangle";
    width: number;
    height: number;
}

type Shape = Square | Rectangle

function area(s:Shape):number{
    switch(s.kind){
        case "Square":
            return s.size * s.size;
        case "Rectangle":
            return s.width * s.height;
    }
}

// Deriving Types
// Generics

type Stack<T> = {
    top: T;
    rest: Stack<T>;
} | null;

type Animal = "Animal"

const animalStack: Stack<Animal> = {
    top: "Animal",
    rest: null
}

const y = animalStack.top

// Think of generics as functions

const ident = (x: any) => x; // value level
type Ident<T> = T; // type level

const pair = (x:any, y:any) => [x, y]; // value level
type Pair<T,U> = [T,U]; // type-level

type MyPartial<T> = {[ K in keyof T] ?: T[K]}

//Partial

{[ K in keyof "x" | "y"] ?: Point[K]}
```
