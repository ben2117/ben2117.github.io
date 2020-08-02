# Talk To Postgres

# Send Web Requests

```f#
#r "C:/Users/Ben/.nuget/packages/hopac/0.3.23/lib/netstandard1.6/Hopac.Core.dll"
#r "C:/Users/Ben/.nuget/packages/hopac/0.3.23/lib/netstandard1.6/Hopac.dll"
#r "C:/Users/Ben/.nuget/packages/http.fs/5.4.0/lib/net471/HttpFs.dll"
open HttpFs.Client
open Hopac.Core
open Hopac


let key = "*****"
let url = "https://api/something"
let body = "jsonBody"

let site =
  Request.createUrl Post url
  |> Request.setHeader(ContentType (ContentType.parse "application/json" |> Option.get) )
  |> Request.setHeader(Authorization  ("Bearer " + key))
  |> Request.body (BodyString body)
  |> Request.responseAsString
  |> run
  
```
