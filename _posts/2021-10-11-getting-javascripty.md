 ```js
 
 // A higher order function
 const filter = ( array: any[], fun: (element: any) => boolean): any[] => {
    let newArray = [];
    array.forEach(element => {
      if (fun(element)) {
        newArray.push(element);
      }
    });
    return newArray;
  };

  const array = [1,2,3];
  const myPredicate = (num: number): boolean=> num === 2;
  console.log(filter(array, myPredicate))


// reduce

const states = [
    { one: 1 },
    { two: 2 },
    { three: 3 }
]

const reductor =( reduction, item) => {
    return ({...item, ...reduction})
}

const reducedThing = states.reduce(reductor, {})

console.log(reducedThing);


const myReducer = (array, fun, startState) => {
    let variable = startState;
    array.forEach(element => {
        variable = fun(variable, element)
      });
    return variable;
}

console.log(
    myReducer(states, reductor, {})
);

// Currying
const theCurry =
    (one: number) => 
        (two: number) => 
            (three: number) => {
                return one + two + three;
            };

const stepOne = theCurry(4);
console.log(stepOne); // (two) => (three) => {return one + two + three;} 

const stepTwo = stepOne(2);
console.log(stepTwo); //(three) => {return one + two + three;}

const stepThree = stepTwo(3);
console.log(stepThree); //9 


```
