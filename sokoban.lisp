;;;; sokoban.lisp

(in-package #:sokoban)

(defparameter *@* nil)

(defparameter *moves* 0)

(defparameter *winlist* nil)

(defun read-game (file)
  (let* ((origin (uiop:read-file-lines file))
	 (result (make-hash-table))
	 (dim (length origin)))
    (dotimes (row dim (values result dim))
      (dotimes (col dim)
	(let ((element (aref (nth row origin) col)))
	  (setf (gethash (complex col row) result) element)
	  (when (eq element #\@)
	    (setf *@* (complex col row)
		  (gethash (complex col row) result) #\.))
	  (when (eq element #\_)
	    (push (complex col row) *winlist*)))))))

(defun sokoban (file)
  (multiple-value-bind (level dim) (read-game file) 
    (blt:with-terminal 
      (blt:set "window.size = ~AX~A" dim dim)
      (tick level))))

(defun tick (level)
  (blt:clear)
  (maphash #'(lambda (coord val) 
	       (setf (blt:cell-char (realpart coord) (imagpart coord)) val))
	   level)
  (setf (blt:cell-char (realpart *@*) (imagpart *@*)) #\@)
  (blt:print 0 0 (format nil "~a" *moves*))
    (when (winp) (return-from tick *moves*))
  (blt:refresh)
  (unless (eq (make-move level) 'quit)
    (tick level)))

(defun winp ()
  (every #'(lambda (n) (eq (blt:cell-char (realpart n) (imagpart n)) #\B)) 
	 *winlist*))

(defun make-move (level)
  (let ((move (case (blt:read) 
		(11 #C(-1 0)) ; h
		(13 #C(0 1))  ; j
		(14 #C(0 -1)) ; k	
		(15 #C(1 0))  ; l
		(41 'quit)))) ; esc
    (if (numberp move)
	(let* ((newcoord (+ *@* move))
	       (dest (blt:cell-char (realpart newcoord) (imagpart newcoord))))
	  (case dest
	    ((#\_ #\.) (incf *@* move) (incf *moves*))
	    (#\B (when (member (gethash (+ newcoord move) level #\#) 
			       '(#\. #\_))
		   (incf *@* move)
		   (incf *moves*)
		   (setf (gethash newcoord level) #\.
			 (gethash (+ newcoord move) level) #\B)
		   (when (member newcoord *winlist*)
		     (setf (gethash newcoord level) #\_))))))
	move)))
