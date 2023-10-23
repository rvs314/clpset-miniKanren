(load "mk.scm")
(load "test-check.scm")

(define (set-removeo s x s-x)
  (fresh ()
    (!ino x s-x)
    (conde
      ((ino x s)
       (== (set s-x x) s))
      ((!ino x s)
       (== s-x s)))))

(test-check "set-removeo"
  (run* (q) (set-removeo (set ∅ 'dog 'cat 'rat) 'cat q))
  '((set ∅ dog rat)))

(test-check "set-removeo-idempotent"
  (run* (q) (set-removeo (set ∅ 'dog 'rat) 'cat q))
  '((set ∅ dog rat)))

(define (free-variableso expr vs)
  (conde
    ((symbolo expr) (== (set ∅ expr) vs))
    ;; no numbero!
    ;;((numbero expr) (== ∅ vs))
    ((fresh (x e vs^)
       (== `(lambda (,x) ,e) expr)
       (symbolo x)
       (set-removeo vs^ x vs)
       (free-variableso e vs^)))))

(test-check "free-variableso"
  (run* (q) (free-variableso `(lambda (y) z) q))
  '((set ∅ z)))

;; not only is this behavior bad, in terms of the duplicate empty-set,
;; it gets worse If you swap (set-removeo vs^ x vs) and (free-variableso e vs^)
;; free-variableso you get (∅) instead of (∅ ∅)!! Grosssssss
;;; FIXXX MEEE PLZZZZZ
(test-check "no-free-variableso"
  (run* (q) (free-variableso `(lambda (y) y) q))
  '(∅ ∅))

(test-check "no-free-variableso-nested"
  (run* (q) (free-variableso `(lambda (y) (lambda (z) y)) q))
  '(∅ ∅))
