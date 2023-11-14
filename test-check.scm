
(define-syntax test
  (syntax-rules ()
    [(test title body ...)
     (begin
       (printf "Test ~s " title)
       (guard (exn
               [(error? exn)
                (printf "FAILED: ~a~%" (condition-message exn))
                #f])
         body ...
         (printf "passed~%")))]))

(define-syntax check
  (syntax-rules ()
    [(check v)
     (unless v
       (error 'check
              (format "Expected ~s to be truthy, but it was not" 'v)))]
    [(check a b)
     (let ([t a]
           [v b])
       (unless (equal? t v)
         (error 'check
                (format "expected: ~a, but computed: ~a" v t))))]))

(define-syntax test-check
  (syntax-rules ()
    ((_ title tested-expression expected-result)
     (test title
       (check tested-expression expected-result)))))

(define-syntax test-disable
  (syntax-rules ()
    ((_ title other-forms ...)
     (begin
       (printf "Test ~s disabled~%" title)
       #t))))
