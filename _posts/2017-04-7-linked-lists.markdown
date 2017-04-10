---
layout: post
title:  "linked lists"
date:   2017-04-7 11:11:00 +1100
categories: learning c++
---

learning another language. Im going to go through a bunch of algorythims and data structures over the next 
few months until i get a handle on it.

the first file is List.h. This is a header file which contains definitions of functions and variables. 
we will create an abstract class. this uses pure virtua functions. 
{% highlight cpp %}
virtual void myFunction() = 0;
{% endhighlight %}
with the = 0 indicating that the class that inherits must implement the function

here we define a generic list, maybe its a linked list maybe its not. 
{% highlight cpp %}
//----List.h file----

#ifndef LIST_H_
#define LIST_H_

class List {
public:
  virtual ~List() {};  //this is the destructor
  virtual bool isEmpty() = 0; // to check if the list is empty
  virtual void prepend(int c) = 0; 
  virtual void append(int c) = 0;
  virtual int getHead() = 0; //the head will be a pointer to the start of the list
  virtual List * tail() = 0; // the tail will be a list returned from a certain point. 
};

#endif
{% endhighlight %}
now we want to define a linked list. Here we specify the functions and variables to be used by a linked lits.
this inherits from our generic list class.
{% highlight cpp %}
//----LinkedList.h file----

#ifndef LINKEDLIST_H_
#define LINKEDLIST_H_

#include <cstddef>
#include <string>

#include "List.h"

using std::size_t;
using std::string;

class LinkedList : public List { //our linked list inherits from list

 private:

  // we have a private sub class node
  // each element in the list will be contained in a Node, along with the location
  // of the next node in the list.
  class Node{ 

  private: //our private variables for the node class

    Node * next; // the node has apointer to the next node in the list
    int data; // the node contains an int variable 

  public:

    Node(); //node constructor
    Node(Node * next, int data); //overloaded node constructor
    ~Node(); //node destructor
    int getData(); //to return the data
    Node * getNext(); //to return the next pointer
    void setNext(Node *); //sets the pointer next will point to

  };

  Node * head; //we have the head of the list, this will point to the first node
  size_t length; //it is usefull to know the length of the list

 public:
  //our functions are no longer virtual so will be implemented in the linkedlist.cpp file
  LinkedList(); 
  ~LinkedList();
  bool isEmpty();
  void prepend(int c); 
  void append(int c);
  int getHead();
  LinkedList * tail();
  
};

#endif
{% endhighlight %}

in the .cpp file we implement the definitions from header file

{% highlight cpp %}
//----LinkedList.cpp file----

#include "LinkedList.h"

LinkedList::Node::Node() {
  data = 0;
  next = 0;
}

LinkedList::Node::Node(Node * n, int d){
  data = d;
  next = n;
}

LinkedList::Node::~Node() {
}

int LinkedList::Node::getData(){
  return data;
}

LinkedList::Node * LinkedList::Node::getNext(){
  return next;
}

void LinkedList::Node::setNext(Node * n){
  next = n;
}

LinkedList::LinkedList(){
  head = 0;
  length = 0;
}

LinkedList::~LinkedList(){

  if (head != 0){

    Node * current = head;
    Node * next = current->getNext();
    while (next != 0){
      delete current;
      current = next;
      next = current->getNext();
    }
  }
}

bool LinkedList::isEmpty(){
  return length == 0;
}

void LinkedList::prepend(int c){
  Node * newNode = new Node(head, c);
  head = newNode;
  length++;
}

void LinkedList::append(int c){

  if (head == 0){
    prepend(c);
  }
  else{
    Node * current = head;
    while (current->getNext() != 0){
      current = current->getNext();
    }
    current->setNext(new Node(0, c));
    length++;
  }

}

int LinkedList::getHead(){
  return head->getData();
}

LinkedList * LinkedList::tail(){

  LinkedList * newList = new LinkedList();

  if (head != 0){
    Node * current = head->getNext();

    while (current != 0){
      newList->append(current->getData());
      current = current->getNext();
    }
  }

  return newList;
  
}

{% endhighlight %}

now we will quickly check out linked list implementation by creatiing a main function that uses it


{% highlight cpp %}
#include <iostream>

#include "LinkedList.h"

using std::cout;

int main(){

  LinkedList * list = new LinkedList();

  for (int i = 0; i < 10; i++){
    list->append(i);
  }

  LinkedList * tailList = list->tail();

  while (!tailList->isEmpty()){
    cout << tailList->getHead() << "\n";
    LinkedList * temp = tailList->tail();
    delete tailList;
    tailList = temp;
  }
  
}

{% endhighlight %}