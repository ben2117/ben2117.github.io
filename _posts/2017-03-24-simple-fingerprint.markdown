---
layout: post
title:  "very simple fingerprinting"
date:   2017-03-24 11:18:44 +1100
categories: javascript fingerprint
---
when i wanted to see who of about 10 or so users were accsessing a site i quickly wrote this to keep an eye on activity. of course you could drop cookies and that would be better but then its not fingerprinting

here we format our date, create a hash for later comparison (using CryptoJs) and then create our object that is to be added to our database each time someone connects to our site

{% highlight javascript %}
     
function formatDate(date){
  var month = date.getUTCMonth() + 1;
  var day = date.getUTCDate();
  var year = date.getUTCFullYear();
  
  return day + "/" + month + "/" + year;
}

function callHome(page){
  var hash = CryptoJS.MD5("" + navigator.userAgent + screen.height + screen.width + screen.colorDepth);
  var connection = {
    userAgent: navigator.userAgent,
      date: formatDate(new Date()),
      h: screen.height, 
      w: screen.width, 
      c: screen.colorDepth,
      hash: hash.toString(),
      pageViewed: page
  }

  firebase.database().ref('connections/').push(connection);
}
{% endhighlight %}

in our adminstrator console we can gather our data together to view the seperate users activities on our site


{% highlight javascript %}

firebase.initializeApp(config);

var clients = [];

firebase.database().ref('connections').once('value').then(function(snapshot) {
    
    snapshot.forEach( function (child) {
        
        //if our client already exsists, we add a date for a connection if not
        //we create a new client and add his connection date

        var newClient = true;
        clients.forEach( function (client){ 
          if(client.hash === child.val().hash){
            newClient = false;
            client.connections.push({date: child.val().date});
          }
        });
        
        if(newClient){
          clients.push({
            hash: child.val().hash,
            connections: [ { date: child.val().date } ]
          });
        }
    });

    console.log(clients);
});
{% endhighlight %}
