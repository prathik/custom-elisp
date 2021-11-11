(defun increment-number-at-point ()
  (skip-chars-backward "0-9")
  (or (looking-at "[0-9]+")
      (error "No number at point"))
  (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))

(defun goto-last-row ()
  (goto-char (org-table-end))
  (previous-line)
  (previous-line))

(defun goto-second-column ()
  (org-table-goto-column 2))

(defun increment-last-row-second-column ()
  "This is used to track the total pomodoro done."
  (interactive)
  (goto-last-row)
  (goto-second-column)
  (org-table-end-of-field 1)
  (increment-number-at-point))

(global-set-key (kbd "s-d") 'increment-last-row-second-column)

(provide 'org-table-incr)
