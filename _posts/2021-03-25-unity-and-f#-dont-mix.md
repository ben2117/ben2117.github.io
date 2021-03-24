To preface this, I would say that generally unity and f# dont mix. Unity and f# expect things to work in a certain way during their whatever it is called " runtime set-up stuff ". 
That being said, this is still possible, just be prepared. 

### getting set up.
I followed this guide https://docs.google.com/document/d/1TazHYYar_DkLJVeU5qAwpvmWAzJlML3aAFQb2zuExho/edit


### creating as monobehaviour that updates postion on key press

```f#
type Controller() = 
    inherit MonoBehaviour()
    
    member this.Update() = 
        let yMovement = if Input.GetKey(KeyCode.W) then 0.1f elif Input.GetKey(KeyCode.S) then -0.1f else 0.f
        let xMovement = if Input.GetKey(KeyCode.A) then -0.1f elif Input.GetKey(KeyCode.D) then 0.1f else 0.f
        this.transform.position <- new Vector3(this.transform.position.x + xMovement, this.transform.position.y)
        this.transform.position <- new Vector3(this.transform.position.x, this.transform.position.y + yMovement)
 ```
 
 ### instatiating prefab from resources and adding said controler to it
 
 ```f#
 type SetupScript() = 
    inherit MonoBehaviour()
    member this.Start() =
        (GameObject.Instantiate(Resources.Load("SpaceShip")) :?> GameObject).AddComponent(typedefof<Controller>)
 ```
 
 
 ### instatiating a prefab and adding more then one component with pipes
 ```f#
     member this.CreatePlayer() = 
        GameObject.Instantiate(Resources.Load("Capsule"), new Vector3(10.0f, 1.0f, 10.0f), new Quaternion()) :?> GameObject
        |> (fun o -> o.gameObject.AddComponent(typedefof<Clickable>))
        |> (fun o -> o.gameObject.AddComponent(typedefof<Moveable>))
        
 // and my moveable and clickable monobehaviours for reference
 type Moveable() = 
    inherit MonoBehaviour()

    member this.Start() = 
        Debug.Log("Movable Attacehd")

    member this.Update() =
        let x, y, z = (List.last game.States).MyPosition
        this.transform.position <- Vector3.MoveTowards(this.transform.position, new Vector3(x, y, z), 10.0f * Time.deltaTime)


type Clickable() = 
    inherit MonoBehaviour()

    member this.Start() = 
        Debug.Log("Clickable Attached")
    member this.OnMouseDown() = 
        game.dispatch(game.Clicked this.gameObject)
```

### using the raycast api
```f#
type RayCastController() = 
    inherit MonoBehaviour()
    member this.Update() = 
        if Input.GetMouseButtonDown(0) then 
            let ray = Camera.main.ScreenPointToRay(Input.mousePosition)
            let mutable hit = new RaycastHit()
            if Physics.Raycast(ray, &hit) then 
                this.transform.position <- hit.point
    
```
