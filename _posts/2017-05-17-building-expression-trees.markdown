---
layout: post
title:  "building expression tree with the shunting-yard algorithm "
date:   2017-05-17 11:11:00 +1100
categories: learning c++
---


{% highlight cpp %}
buildTree(vector<string> tokens){ 
    //Shunting-yard algorithm
    queue<string> outputQueue;
    stack<string> operatorStack;
    
    for(int i = 0; i < tokens.size(); i++){
        string token = tokens[i];
        // if the token is a number we always add it to the queue
        if(is_number(tokens[i])){
            outputQueue.push(tokens[i]);
        }
        else if(checkForOperator(tokens[i])){
            while(!operatorStack.empty()){
                // fail first, if the token on the top of the stack is not an
                // operator then we can just add our operator to the stack
                if(!checkForOperator(operatorStack.top())){
                    break;
                }
                // check order of operations, if the current token operator has lower precendency
                // then the operator currently on the top of the operatorStack
                // should go onto the outputQueue
                if(getPrecedence(tokens[i])<=getPrecedence(operatorStack.top())){
                    outputQueue.push(operatorStack.top());
                    operatorStack.pop();
                }
            }
            operatorStack.push(tokens[i]);
        }
        else if(tokens[i]=="("){
            operatorStack.push(tokens[i]);
        }
        // we put all operators that are inside the brakets onto the outputQueue
        else if (tokens[i]==")"){
            while(operatorStack.top()!="(" && !operatorStack.empty()){
                outputQueue.push(operatorStack.top());
                operatorStack.pop();
            }
            //Pop the left parenthesis ( from the stack, but not onto the outputQueue
            operatorStack.pop();
        }
    }
    //push all remaining operators onto the queue
    while (!operatorStack.empty()){
        outputQueue.push(operatorStack.top());
        operatorStack.pop();
    }
    
    stack<TreeNode *> buildTreeStack;
    
    while(!outputQueue.empty()){
        // if the token is a number we always add it to the stack
        if(is_number(outputQueue.front())){
            TreeNode * oneNode = new TreeNode(to_number( outputQueue.front()));
            buildTreeStack.push(oneNode);
        }
        // if the token is an operator we take the last two nodes
        // from the buildTreeStack, turn them into a tree and add them back
        // onto the buildTreeStack
        else if(checkForOperator (outputQueue.front())){
            
            //we get the top two nodes on the stack and remove them
            //right child must go first as we are taking them from the top of the stack
            TreeNode * rightChild = buildTreeStack.top();
            buildTreeStack.pop();
            TreeNode * leftChild = buildTreeStack.top();
            buildTreeStack.pop();
            
            //create the new parent node
            TreeNode * root = createOperatorNode( outputQueue.front() );
            
            //give the children a parent
            leftChild->setParent(root);
            rightChild->setParent(root);
            
            //assign the new root tree left child and right children
            root->setLeftChild(leftChild);
            root->setRightChild(rightChild);
            
            buildTreeStack.push(root);
        }
        // we assume that the token must be a number or an operator so we now remove it as
        // we should be done
        outputQueue.pop();
    }
    
    // as we assume expression is wellformed we can assume the top of the stack
    // will be the root of the tree after
    return ExprTree(buildTreeStack.top());
}
{% endhighlight %}