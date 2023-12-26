; racket 02b.rkt

#lang racket

(define (update-max result num type)
  (match result
    [(list r g b) (match type
                ["red" (list (max r num) g b)]
                ["green" (list r (max g num) b)]
                ["blue" (list r g (max b num))])]))

(define (get-max string)
  (define cubes (regexp-split #rx"(,|;) " string))
  (for/fold ([result '(0 0 0)])
    ([cube cubes])
    (define num-and-type (regexp-split #rx" " cube))
    (define num (string->number (car num-and-type)))
    (define type (car (cdr num-and-type)))
    (update-max result num type)))

(define (solve id line)
  (define colon (regexp-match-positions #rx": " line))
  (define start (+ 2 (car (car colon))))
  (match (get-max (substring line start))
    [(list r g b) (* r (* g b))]))

(define (main id)
  (define line (read-line))
  (if (eof-object? line)
    0
    (+ (solve id line) (main (+ 1 id)))))

(printf "~a\n" (main 1))
