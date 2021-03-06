---
layout: post
title:  "creating a call back"
date:   2017-03-1 11:18:44 +1100
categories: java
---
i needed to implement a callback after a certain amount of frames. im not sure the right way to do this so i made it up as i went along.

{% highlight java %}
  
class Callback{
  ActionHandler actionHandler;
  CallFunction callFunction;
  int timer;
  int time;
  Button button;
  boolean destroy;

  Callback(CallFunction callFunction, int timer, Button button, ActionHandler actionHandler){
    this.destroy = false;
    this.time = 0;
    this.actionHandler = actionHandler;
    this.callFunction = callFunction;
    this.timer = timer;
    this.button = button;
    println("callback added" + this.timer);
  }

  public boolean toDestroy(){
    return destroy;
  }

  public void incTime(){
    if(destroy) return;
    time++;
    if(time>timer){
      destroy = true;
      callback();
    }
  }

  private void callback(){
    switch(callFunction){
      case BUTTONCLICK: button.actionClick(); break;
      case NEXTTURN: actionHandler.nextTurnCallback(); break;
    }
  }
  
}
{% endhighlight %}

we then add a callback using the following funciton

{% highlight java %}
ArrayList callbacks = new ArrayList();

void addCallback(CallFunction callFunction, int timer, Button button, ActionHandler actionHandler){
  callbacks.add(new Callback(callFunction, timer, button, actionHandler));
}
{% endhighlight %}

which are looped through in the main loop

{% highlight java %}
 for(Callback c : callbacks){
    c.incTime();
    if(c.toDestroy()){
      callbacks.remove(c);
      break;
    }
  }
{% endhighlight %}
