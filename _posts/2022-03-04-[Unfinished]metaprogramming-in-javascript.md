````javascript
type argument = number
type Fwd = argument
type Turn = argument;
type Repeat<T> = Array<T>;

type Command = 
      { Fwd : number }
    | { Turn: number }
    | { Repeat : {
            Times: number
            Commands: Array<Command>
        } 
      }

const test: Command = {Fwd: 4};

 const foo: Command = 
    { Repeat: { Times: 5,
        Commands: [
            {Fwd: 1}
        ]
    }}


const matcher = (comand: Command) => {
    const commandName = Object.entries(comand)[0][0];
    const commandArgument = Object.entries(comand)[0][1];
    switch(commandName){
            case "Fwd":
                for(var i = 0; i < commandArgument; i++){
                    console.log("->")
                }
                return
            case "Repeat":
                const times = Object.entries(commandArgument)[0][1] as number;
                const innerCommand = Object.entries(commandArgument)[1][1] as Array<Command>;
                for(var i = 0; i < times; i++){
                    for(let j in innerCommand){
                        matcher(innerCommand[j]);
                    }
                }
                return
    }
}

matcher(foo)
````
