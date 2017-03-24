---
layout: post
title:  "assembly cheat sheet (x86)"
date:   2017-03-24 11:18:44 +1100
categories: assembly
---
general purpose registers are RAX( accumulator), RXC (Counter), RDX (Data), RBX(Base)

the pointer registers are RSP(stack pointer), RBP(base pointer), RSI(source index) and RDI(destination index)

the RIP register is the instruction pointer register which points to the instruction the processor is reading

{% highlight shell %}
|| memory       { register }
||--------                rax
||         <---- rbp      rbx
|| stack   <---- rsp      rcx
||                        rdx
||--------                rsi
|| heap                   rdi
||--------
||        
|| code    <---- rip
||
{% endhighlight %}

the stack is used for local variables, the registers are 32bit integers that store values for the cpu. esp shows the current end of the stack, it moves up and down as you add and remove data eip allways points to the instruction that is being executed

here are some arithmatic instructions, instrucitons take the form of : operation {destination}, {source} the destiantion or source will be a register an address or a value

{% highlight shell %}
mov rax, 2      ; rax = 2
mov rvx, 3      ; rbx = 3

add rax, ebx    ; rax = rax + rbx
sub rbx, 2      ; rbx = rbx - 2
{% endhighlight %}

when you need to work with more data then is stored in the registers you must store the extra data in memory. here we load and store data in memory.

{% highlight shell %}
mov rax, [1234] ; rax = *(int*)1234

mov rbx, 1234   ; rbx = 1234
mov rax, [ebx]  ; rax = *rbx

mov [rbx], rax  ;*rbx = rax 
{% endhighlight %}

conditional branches are used for things like loops, they are essentialy goto statements with a condition

{% highlight shell %}
cmp rax, 2      ;compare rax with 2

je label1       ; if (rax == 2) goto label 1
ja label2       ; if (rax > 2 ) got label 2
jb label3       ; if (rax < 2) goto label 3
jbe label4      ; if (rax <= 2) goto label 4
jne label5      ; if (rax != 2) goto label 5


jmp label7      ;unconditional goto label 6
{% endhighlight %}
functions
{% highlight shell %}
call func       ;store return address on stack and jump to function

func:
  push rsi      ; save rsi
  pop rsi       ; restores rsi
  ret           ; reads return address and jumps to it
{% endhighlight %}