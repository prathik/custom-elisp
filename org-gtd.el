;; org content
;; this file has all the content ideas put into it
;; content workflow: capture ideas -> write outline -> write first draft -> get feedback -> review document -> publish
(setq org-content-ideas-file "~/writing/ideas.org")

;; org gtd setup
(setq org-directory "~/GetThingsDone/")
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
			      ("i" "Content Idea" entry
			       (file+headline org-content-ideas-file "Ideas")
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

;; productivity key bindings
(global-set-key (kbd "<f5>") (lambda() (interactive)(find-file org-content-ideas-file)))
(global-set-key (kbd "<f6>") (lambda() (interactive)(find-file inbox-file)))
(global-set-key (kbd "<f7>") (lambda() (interactive)(find-file gtd-file)))


(provide 'org-gtd)
