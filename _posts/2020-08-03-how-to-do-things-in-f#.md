# Talk To Postgres

## write to db
```f#
open Npgsql.FSharp

let AddListing gear = 
    Helpers.connectionString
    |> Sql.connect
    |> Sql.executeTransaction
        [
            "INSERT INTO GearListing ( ownedbyuserid,gearname,  description, locationstring, lat, lng, price) 
             VALUES (@ownedbyuserid, @gearname, @description, @locationstring, @lat, @lng,  @price )", [
                [ 
                  "@ownedbyuserid", Sql.int 1
                  "@gearname", Sql.string gear.Name
                  "@description", Sql.string gear.Description
                  "@locationstring", Sql.string gear.LocationString
                  "@lat", Sql.decimal gear.Lat
                  "@lng", Sql.decimal gear.Lng
                  "@price", Sql.decimal gear.Price
                ]
            ]
       ]
```
## read from db
```F#
open Npgsql.FSharp
let GetAllListings = 
    Helpers.connectionString
    |> Sql.connect
    |> Sql.query 
        "
            select id
            , ownedbyuserid
            , gearname
            , description
            , locationstring
            , lat
            , lng
            , price
            from gearlisting
        "
    |> Sql.execute (fun read ->
        {
            ID = read.int "id"
            UserID = read.int "ownedbyuserid"
            Name = read.string "gearname"
            Description = read.string "description"
            LocationString = read.string "locationstring"
            Lat = read.decimal "lat"
            Lng = read.decimal "lng"
            Price = read.decimal "price"
        })

let GetListing id = 
    match GetAllListings with 
    | Ok r -> r |> List.find ( fun g -> g.ID = id)
    | Error e -> NoGear
    
```

# Send Web Requests
## simple
```f#
#r "C:/Users/Ben/.nuget/packages/hopac/0.3.23/lib/netstandard1.6/Hopac.Core.dll"
#r "C:/Users/Ben/.nuget/packages/hopac/0.3.23/lib/netstandard1.6/Hopac.dll"
#r "C:/Users/Ben/.nuget/packages/http.fs/5.4.0/lib/net471/HttpFs.dll"

let requestUrl location = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=" +
    location + 
    "&inputtype=textquery" +
    "&fields=photos,formatted_address,name,rating,opening_hours,geometry" +
    "&key=" + 
    "***************"
  
let placesRequest location = 
    Request.createUrl Get (requestUrl location)
    |> Request.responseAsString
    |> run
```
## with authentication and json body
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
# Work with json
```f#
let getLocationData requestResult = JsonValue.Parse(requestResult)?candidates.[0]?geometry?location
let munichJsonString = placesRequest "Munich"

```
munichJsonString = 
```json
{
   "candidates" : [
      {
         "formatted_address" : "Munich, Germany",
         "geometry" : {
            "location" : {
               "lat" : 48.1351253,
               "lng" : 11.5819805
            },
            "viewport" : {
               "northeast" : {
                  "lat" : 48.2482197,
                  "lng" : 11.7228755
               },
               "southwest" : {
                  "lat" : 48.0616018,
                  "lng" : 11.360796
               }
            }
         },
         "name" : "Munich",
         "photos" : [
            {
               "height" : 3456,
               "html_attributions" : [
                  "\u003ca href=\"https://maps.google.com/maps/contrib/100682666017966674167\"\u003eliu james\u003c/a\u003e"
               ],
               "photo_reference" : "CmRaAAAAoxxg8Y7MLfGSqYJOeX5_V0qZZ6xEgUcCUYvs0q0ToVEUvqix32_hUfvGia1gn3ii-3KBRSKWJCscoHnmhcfqGJBPEjz7NPQZdL8mmbSog1HFqJsR0S_xvBbwU4FOUGsIEhCN43pY-UCo6WZeYLHf9mtBGhTQ1J8dwG74j3-j0wrawrSGHMlB2w",
               "width" : 5184
            }
         ]
      }
   ],
   "status" : "OK"
}

```
```f#
let locs = getLocationData munichJsonString
```
locs = 
```json
{ "lat": 48.1351253, "lng": 11.5819805 }
```
locs?lat = 48.1351253
locs?long = 11.5819805
