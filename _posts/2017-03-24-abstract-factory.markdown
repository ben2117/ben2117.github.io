---
layout: post
title:  "a design pattern: the abstract factory class"
date:   2017-03-24 11:18:44 +1100
categories: java
---
i am tinkering with a board game idea in my spare time and use programming to test out game play mechanics. while setting up the board, the code became messy and i wanted to clean it up.

this pattern is the answer to my question. i need seperate factories for related things. each player is given a board peice and cards, both of these require factories and i want to stream line this by joining them. Enter abstract factories

{% highlight java %}
interface Card{
  public String toString();
}

class MonsterAttackCard implements Card{
  public String toString(){
   return "I am monster card"; 
  }
}

class ItemCard implements Card{
  public String toString(){
   return "I am item card"; 
  }
}

interface BoardPeice{
  public void useCard(); 
}

class Monster implements BoardPeice{
  MonsterAttackCard card;

  public void useCard(){
   card.toString(); 
  }
}

class Human implements BoardPeice{
  ItemCard card;
  
  public void useCard(){
   card.toString(); 
  }
}

interface PlayerFactory{
 public Card dealCards();
 public BoardPeice createBoardPeice();
}

class MonsterPlayerFactory implements PlayerFactory{
 public Card dealCards(){
  return new MonsterAttackCard();
 }
}

class HumanPlayerFactory implements PlayerFactory{
 public Card dealCards(){
  return new ItemCard();
 }
}
{% endhighlight %}

now i can use the player factory to easily create players with Monster or Human board peices and their cards.