;; org gtd setup
(setq org-directory "/Users/prathikrajendran/GetThingsDone/")
(setq gtd-file (concat org-directory "gtd.org"))
(setq inbox-file (concat org-directory "inbox.org"))
(setq tickler-file (concat org-directory "tickler.org"))
(setq someday-file (concat org-directory "someday.org"))
(setq org-agenda-files (directory-files-recursively org-directory "\\.org$"))

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline inbox-file "Tasks")
                               "* TODO %i%? [0%]")
			      ("i" "Writing Idea" entry
			       (file+headline org-writing-ideas-file "Ideas")
			       "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline tickler-file "Tickler")
                               "* TODO %i%? \nDEADLINE: %t")))

(setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)" "CANCELLED(c)")))
(setq org-refile-targets '((gtd-file :maxlevel . 3)
                           (someday-file :level . 1)
                           (tickler-file :maxlevel . 2)))

(setq org-agenda-custom-commands 
      '(("o" "At the office" tags-todo "@office"
         ((org-agenda-overriding-header "Office")
          (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))))

(defun my-org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (org-current-is-todo)
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
          (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))
		  
(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

(setq org-refile-use-outline-path 'file)

(setq org-clock-idle-time 4)

(defun insert-subtask ()
  ;; insert a subtask at the next line
  ;; this is useful when you want to break a task into
  ;; multiple next steps
  (interactive)
  (end-of-line)
  (org-insert-todo-heading-respect-content t)
  (org-shiftmetaright)
  (end-of-line))

(add-hook 'org-mode-hook
  (lambda ()
    (local-set-key (kbd "C-c t") 'insert-subtask)))

(provide 'org-gtd)
