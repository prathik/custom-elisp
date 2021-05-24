;; Exec puml
;; Build the png for all the plantuml files present
(defun files () (directory-files default-directory))

(defun str-puml (x) (when (> (length x) 3) (string= (substring x -4 nil) "puml")))

(defun puml-files ()
  (mapcar (lambda (c) (concat (concat "plantuml " default-directory) c))
	  (seq-filter 'str-puml (files))))

(defun build-puml ()
  (interactive)
  (dolist (file (puml-files)) (shell-command file)))

(provide 'exec-plantuml)
