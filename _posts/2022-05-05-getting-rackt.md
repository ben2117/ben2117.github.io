# Getting Rackt

````lisp
> ;; lambdas
(lambda (x) x) ;; you have a list of arguments, and then a body
#<procedure>
> ;; this is the identity function
((λ (x) x) 5) ;; evaluates the operator λ on the operand 5
5
> (define foo (λ (x) x))
> foo
#<procedure:foo>
> (foo 5)
5
> ;; pattern matching
(require racket/match)
> (match (list 3 4)
    [(list x y) (+ x y)])
7
````

````racket
#lang racket
(require racket/match)
(define ben-terp
    (λ (expression)
      (match expression
        [n #:when (number? n) n]
        [`(add2 ,e)
          (+ 2 (ben-terp e))]
        [(list 'add3 e)
          (+ 3 (ben-terp e))]
        [`(* ,e1 ,e2)
          (* (ben-terp e1) (ben-terp e2))]
        [`(if ,t ,c ,a)
         (if (ben-terp t) ;; test
             (ben-terp c) ;; first sub expression
             (ben-terp a) ;; second sub expression
             )]
        [(λ 
        [`(,rator ,rand)
         ((ben-terp rator) (ben-terp rand))])))

(ben-terp (list 'add2 '1))
(ben-terp `(* 2 3))

````
