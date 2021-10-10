 ```javasacript
 
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



```
