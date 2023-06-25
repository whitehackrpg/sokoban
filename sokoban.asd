;;;; sokoban.asd

(asdf:defsystem #:sokoban
  :description "A Sokoban implementation"
  :author "Christian Mehrstam <whitehackrpg@gmail.com>"
  :license  "MIT"
  :serial t
  :depends-on (#:cl-blt)
  :components ((:file "package")
	       (:file "sokoban")))



