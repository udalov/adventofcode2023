; racket 02a.rkt

#lang racket

(define (check cubes)
  (define num-and-type (regexp-split #rx" " cubes))
  (define num (string->number (car num-and-type)))
  (define type (car (cdr num-and-type)))
  (match type
    ["red" (<= num 12)]
    ["green" (<= num 13)]
    ["blue" (<= num 14)]))

(define (check-set string)
  (define cubes (regexp-split #rx", " string))
  (for/and ([i cubes]) (check i)))

(define (solve id line)
  (define colon (regexp-match-positions #rx": " line))
  (define start (+ 2 (car (car colon))))
  (define strings (regexp-split #rx"; " (substring line start)))
  (if (for/and ([i strings]) (check-set i)) id 0)
  )

(define (main id)
  (define line (read-line))
  (if (eof-object? line)
    0
    (+ (solve id line) (main (+ 1 id)))))

(printf "~a\n" (main 1))
