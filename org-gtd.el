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
(setq waiting-file (concat org-directory "waiting.org"))

;; all files except hidden files, ie those starting with . are matched
(setq org-agenda-files (directory-files-recursively org-directory "^[^.].*org$"))

(defun org-capture-idea ()
  "Capture a todo item via org capture"
  (interactive)
  (org-capture nil "i")
  )

(defun org-capture-todo ()
  "Capture a todo item via org capture"
  (interactive)
  (org-capture nil "t")
  )

(global-set-key (kbd "s-a") 'org-agenda)
(global-set-key (kbd "s-n") 'org-agenda-list)
(global-set-key (kbd "s-c") 'org-capture)
(global-set-key (kbd "s-t") 'org-capture-todo)
(global-set-key (kbd "s-i") 'org-capture-idea)

(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file inbox-file)
                               "* TODO %i%? [/]")
			      ("i" "Content Idea" entry
			       (file+headline org-content-ideas-file "Ideas")
			       "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline tickler-file "Tickler")
                               "* TODO %i%? \nDEADLINE: %t")))

(setq org-refile-targets '((gtd-file :maxlevel . 1)
                           (someday-file :level . 1)
			   (waiting-file :level . 1)
                           (tickler-file :maxlevel . 1)))

(setq org-agenda-custom-commands 
      '(("w" "Work In Progress" todo "WIP"
	 ((org-agenda-start-with-follow-mode t)))
	("i" "Writing" todo "WRITING"
	 ((org-agenda-files (list org-content-ideas-file))))
	("g" "GTD" tags-todo "LEVEL=1"
	 ((org-agenda-files (list gtd-file))
	  (org-agenda-start-with-follow-mode t)
	  (org-agenda-sorting-strategy '(priority-down effort-down))))))

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

(defun archive-done ()
  "Archive all the top level done tasks"
  (interactive)
  (beginning-of-buffer)
  (org-map-entries 'org-archive-subtree "LEVEL=1/+DONE" 'file)
  (org-map-entries 'org-archive-subtree "LEVEL=1/+CANCELED" 'file))

(add-hook 'org-mode-hook
  (lambda ()
    (local-set-key (kbd "C-]") 'insert-subtask)
    (local-set-key (kbd "C-t") 'org-todo)
    (local-set-key (kbd "C-c M-a") 'archive-done)))

;; productivity key bindings
(global-set-key (kbd "<f6>") (lambda() (interactive)(find-file inbox-file)))
(global-set-key (kbd "<f7>") (lambda() (interactive)(find-file gtd-file)))
(global-set-key (kbd "<f8>") (lambda() (interactive)(find-file org-content-ideas-file)))

;; Only show agenda for today and next day
;; Next day is used while planning
(setq org-agenda-span 2)

(provide 'org-gtd)
