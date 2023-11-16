(load "mk.scm")
(load "test-check.scm")

#|
Non-overlapping clause problem

With no overlapping checks: 

(conde
  ((== tx t))
  ((ino t rx)))

(test-check "ino-duplicate"
  (run* (r) (ino 1 (set ∅ 1 1)))
  '(_.0 _.0))

With a check on the second branch:

(conde
  ((== tx t))
  ((=/= tx t) (ino t rx)))

(test-check "ino-duplicate"
 (run* (r) (ino 1 (set (set ∅ 1) r)))
 '(1 (_.0 : (=/= (_.0 1)))))

With a check on the first branch:

(conde
  ((== tx t) (!ino t rx))
  ((ino t rx)))

(test-check "ino-duplicate"
  (run* (p) (ino 1 (set p 1)))
  '((_.0 : (set _.0) (!in (1 _.0))) ((set _.0 1) : (set _.0))))

Test in both branches:

(conde
  ((== tx t) (!ino t rx))
  ((ino t rx) (=/= tx t)))

(test-check "ino-fail"
  (run* (p) (ino 1 (set (set p 1) 1)))
  '())

Test in both statements, with a fallback

(conde
  ((== tx t) (!ino t rx))
  ((ino t rx) (=/= tx t))
  ((ino t rx) (== tx t)))

Susceptible to both cases:

(test-check "ino-duplicate"
  (run* (l) (ino 1 (set ∅ 1 1)))
  '(_.0 _.0))
|#
