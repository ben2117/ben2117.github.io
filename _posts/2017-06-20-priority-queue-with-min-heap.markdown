---
layout: post
title:  "priority queue with min heap"
date:   2017-06-20 11:11:00 +1100
categories: learning c++
---
first we need our min heap data structure

{% highlight cpp %}
    vector<pair<int, E> > minHeapVector;
    
    // for a min heap the node must be smaller then both its children so we
    // move a node up the tree untill its not smaller then its parent
    void siftUp(int node){
        //
        if(node == 0){
            return;
        }
        // to find the nodes parent, we subtract one and half it because of binary heap properties
        int parentNode = (node-1)/2;
        
        //if the node is less then its parent, then we must swap them
        if(minHeapVector[node].first < minHeapVector[parentNode].first){
            // get the parent
            pair<int, E> tempNode = minHeapVector[parentNode];
            // put the node in its parents place
            minHeapVector[parentNode] = minHeapVector[node];
            // put the parent where the node used to be
            minHeapVector[node] = tempNode;
            //now we need to check the new parent so we call recusivly again
            siftUp(parentNode);
        }
    }
    
    //for a min heap a node must be smaller then both its children
    void siftDown(int node){
        // we find the children of the index by multiplying
        // the index by 2 ( as it is a binary heap) and then adding 1 for the left child and 2 for the right child
        // we can see in an heap it would look like
        // [0][1][index][3][4][leftchild][rightchild][7]
        int leftChild = 2*node+1;
        int rightChild = 2*node+2;
        
        //if ether left child or node is leaf return, there is nothing to swap
        if(leftChild >= size()){
            return;
        }
        
        // we need to swap it with the smallest of the two children
        
        // first we assume that the root node is the smallest, it might be in the correct place
        int smallestNode = node;
        // is the node smaller then the left child it might be the smallest
        if(minHeapVector[leftChild].first < minHeapVector[node].first){
            smallestNode = leftChild;
        }
        //make sure right child is not a leaf
        if(rightChild < size()){
            // we compare it with the smallestNode which will ether be node or leftChild
            if(minHeapVector[rightChild].first < minHeapVector[smallestNode].first){
                smallestNode = leftChild;
            }
        }
        //now smallestNode should be the smallest out of all three
        
        // if it is the node then it is in the right place we dont need to do anything
        if ( smallestNode != node){
            
            pair<int, E> tempNode = minHeapVector[node];
            minHeapVector[node] = minHeapVector[smallestNode];
            minHeapVector[smallestNode] = tempNode;
            //we must call recusivly becauase it is min heap and we need it to
            // go all the way down to where it belongs
            siftDown(smallestNode);
        }
    }

    //we create the min heap structure in our vector
    void heapify(){
        // we start from the end of the array and swap untill
        // we have the structure of the min heap
        for(int i = size()-1; i > -1; i--){
            siftDown(i);
        }
    }

{% endhighlight %}

then we implement the methods of the priority queue abstract data type

{% highlight cpp %}
    void insert(int priority, E element) {
        if( priority < 0 ){
            return;
        }
        // in our min heap each pair is considered a node
        std::pair<int, E> tempNode = std::make_pair(priority, element);
        // we put the new node on the end of the heap
        minHeapVector.push_back(tempNode);
        // we then use siftUp to put the node in its correct place
        siftUp(size()-1);
    }
    
     void insert_all(std::vector<std::pair<int,E> > new_elements) {
        // loop through each of the new elements add them to the back of the heap
        // and sift them up
        for(int i = 0; i < new_elements.size(); i++){
            minHeapVector.push_back(new_elements[i]);
            siftUp(size()-1);
        }
    }
    
    E remove_front() {
        if(size() < 1){
            return E();
        }
        
        // instead the correct way to do is swap the back with the front, then siftDOwn the back one
        E frontElement = minHeapVector[0].second;
        //swap first with last element
        minHeapVector[0] = minHeapVector[size()-1];
        //delete last element
        minHeapVector.pop_back();
        //put last element in correct place
        siftDown(0);
        return frontElement;
        
    }
    
    E peek() {
        return minHeapVector[0].second;
    }
    

    std::vector<E> get_all_elements() {
        std::vector<E> allElements;
        for(int i = 0; i < size(); i++){
            allElements.push_back(minHeapVector[i].second);
        }
        return allElements;
        
    }
    
    bool contains(E element){
        bool containsElement = false;
        for(int i = 0; i < size(); i++){
            if(minHeapVector[i].second == element){
                containsElement = true;
            }
        }
        return containsElement;
    }
    
    int get_priority(E element){
        int lowestPriority = -1;
        for(int i = 0; i < size(); i++){
            if(minHeapVector[i].second == element){
                // check to make sure priority is lower or nothing has been found yet
                if(minHeapVector[i].first < lowestPriority || lowestPriority == -1){
                    lowestPriority = minHeapVector[i].first;
                }
            }
        }
        return lowestPriority;
        
    }
    
    std::vector<int> get_all_priorities(){
        std::vector<int> allPriorities;
        for(int i = 0; i < size(); i++){
            allPriorities.push_back(minHeapVector[i].first);
        }
        return allPriorities;
        
    }
    
    void change_priority(E element, int new_priority) {
        
        // first we find the node that matches the element with the lowest priority
        int lowestMatchingNode = -1;
        for(int i = 0; i < size(); i++){
            if(minHeapVector[i].second == element){
                if(lowestMatchingNode == -1){
                    lowestMatchingNode = i;
                }
                else if(minHeapVector[i].first < minHeapVector[lowestMatchingNode].first){
                    lowestMatchingNode = i;
                }
            }
        }
        
        if(lowestMatchingNode != -1){
            //then we change the priority of it
            minHeapVector[lowestMatchingNode].first = new_priority;
            // here we want to heapify as the new priority might mean a siftDown or a siftUp
            // so we can just resort the whole heap
            heapify();
        }
    }
    
    int size() {
        return minHeapVector.size();
        
    }
    
    bool empty() {
        return ( size() < 1);
        
    }

{% endhighlight %}
