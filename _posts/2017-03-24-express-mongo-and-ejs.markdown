---
layout: post
title:  "express, mongo and ejs is super easy"
date:   2017-03-24 11:18:44 +1100
categories: javascript express
---
whenever i want to quickly roll a node app this is my setup, for my example ill make a simple message board. hopefully it wont take me more then 20 mins

we start with node init then add our dependancies to package.json

{% highlight javascript %}
   
{
  "name": "express app for website",
  "version": "1.0.0",
  "description": "",
  "main": "app.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "body-parser": "*",
    "express": "*",
  }
}
    
{% endhighlight %}

now lets set up our app.js, some things to note: we are going to be using ejs for templating which will be in our views folder and we use body parser middleware so we can access req.body easy


{% highlight javascript %}  
var express = require('express');
var bodyParser = require('body-parser');
var path = require('path');

var app = express();
var port = 5000;

app.set('view engine', 'ejs'); 

app.set('views', path.join(__dirname, 'views'));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));

app.use(express.static(path.join(__dirname, 'public')));


app.get('/', function(req, res){
  res.render('index');
})

app.post('/posts/add', function(req, res){
  var newPost = {
    name : req.body.name,
    post : req.body.post
  }
})

app.listen(port, function(){
  console.log("server on " + port);
})

{% endhighlight %}

too easy, our index.ejs is just a form at the moment so not worth showing. now we want to grab our new post object and send it to our mongo database, so lets get mongod running

{% highlight php%} 
% mongo

...

> use postApp
switched to db postApp
> db.createCollection('posts')
{ "ok" : 1 }
> db.posts.insert([{name: 'ben', post: 'initial test post'}])
BulkWriteResult({
  "writeErrors" : [ ],
  "writeConcernErrors" : [ ],
  "nInserted" : 1,
  "nUpserted" : 0,
  "nMatched" : 0,
  "nModified" : 0,
  "nRemoved" : 0,
  "upserted" : [ ]
})
> db.posts.find()
{ "_id" : ObjectId("58ad0f4ec51748ba3aa5e13c"), "name" : "ben", "post" : "initial test post" }

{% endhighlight %}

now we need to add mongo js to our project. after this we can read the posts from the database and send pass them into our res.render method. we also want to save our new posts to the database. after we have implemented these changes our app.js file looks like this.

  
{% highlight javascript %}
var express = require('express');
var bodyParser = require('body-parser');
var path = require('path');

var mongojs = require('mongojs');
var db = mongojs("postApp",['posts']);

var app = express();
var port = 5000;

app.set('view engine', 'ejs'); 

app.set('views', path.join(__dirname, 'views'));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));

app.use(express.static(path.join(__dirname, 'public')));


app.get('/', function(req, res){
  db.posts.find(function (err, docs){
    res.render('index', {
      posts: docs
    });
  });
  
});

app.post('/posts/add', function(req, res){
  var newPost = {
    name : req.body.name,
    post : req.body.post
  }

  db.posts.insert(newPost, function(err, res){
    if(err){
      console.log(err);
    }
  });
  res.redirect('/');
});



app.listen(port, function(){
  console.log("server on " + port);
});
{% endhighlight %}

our index view is in ejs looks like this


{% highlight html %}  
  <h1> submit post </h1>
  <form method="POST" action="/posts/add">
    <label> Name </label>
    <input type="text" name="name">
    <label> Post </label>
    <input type="text" name="post">
    <input type="submit" value="Submit">
  </form>

  <h1> posts </h1>
    <ul>
    <% posts.forEach(function(post){ %>
      <li><b><%=  post.name %></b> <%= post.post %> </li>
    <% }) %>
    </ul>
  {% endhighlight %}
and there you have it as simple as it gets, probably should put in some error handling but my time is up