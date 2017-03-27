---
layout: post
title:  "to fingerprint better!"
date:   2017-03-1 11:18:44 +1100
categories: javascript fingerprint
---
a while ago i needed a way to keep track of a few users that would be accessing a site. it worked because i was only keeping track of about 5 different people. today i am going to make it more robust by removing the width and height (as they can easily change) and primarily use mimetypes instead along with other information that can be pulled form the navigator javascript object.

{% highlight javascript %}
function callHome(page){

  var browserInfo = {
    platform: navigator.platform,
    launguge: navigator.language,
    appCodeName: navigator.appCodeName,
    product: navigator.product,
    productSub: navigator.productSub,
    appName: navigator.appName,
    c: screen.colorDepth,
    mimeTypes: navigator.mimeTypes
  }

  var stringToHash = "";

  for (var key in browserInfo) {
    if( key === "mimeTypes")
      break;
    stringToHash += browserInfo[key];
  }

  for(var i = 0; i < browserInfo['mimeTypes'].length; i++){
    stringToHash += browserInfo['mimeTypes'][i].type;
  }

  var hash = CryptoJS.MD5(stringToHash);
  
  var connection = {
      date: formatDate(new Date()),
      info: browserInfo,
      hash: hash.toString(),
      pageViewed: page
  }

  firebase.database().ref('connections/').push(connection);

}
{% endhighlight %}
