(defun get-number ()
  (do ((digits '()))
      ((>= (length digits) 4) digits)
    (pushnew (1+ (random 9)) digits)))

(defun compute-score (guess number)
  (let ((cows  0)
        (bulls 0))
    (map nil (lambda (guess-digit number-digit)
               (cond ((= guess-digit number-digit) (incf bulls))
                     ((member guess-digit number)  (incf cows))))
         guess number)
    (values cows bulls)))

(defun number->guess (number)
  (when (integerp number)
    (do ((digits '()))
        ((zerop number) digits)
      (multiple-value-bind (quotient remainder) (floor number 10)
        (push remainder digits)
        (setf number quotient)))))

(defun valid-guess-p (guess)
  (and (= 4 (length guess))
       (every (lambda (digit) (<= 1 digit 9)) guess)
       (equal guess (remove-duplicates guess))))

(defun play-game (&optional (stream *query-io*))
  (do ((number (get-number))
       (cows   0)
       (bulls  0))
      ((= 4 bulls))
    (format stream "~&Guess a 4-digit number: ")
    (let ((guess (number->guess (read stream))))
      (cond ((not (valid-guess-p guess))
             (format stream "~&Malformed guess."))
            (t
             (setf (values cows bulls) (compute-score guess number))
             (if (= 4 bulls)
               (format stream "~&Correct, you win!")
               (format stream "~&Score: ~a cows, ~a bulls."
                       cows bulls)))))))
