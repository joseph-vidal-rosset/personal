;;; test-date-update.el --- Test script for automatic date updates -*- lexical-binding: t; -*-

;; To use this script:
;; 1. Load it in Emacs: M-x load-file RET test-date-update.el
;; 2. Call: M-x test-date-update
;; This will show you debug messages about what the system is doing

(require 'publish) ;; Load your publish.el first

(defun test-date-update ()
  "Test the automatic date update function on a specific file"
  (interactive)
  (let* ((test-file (read-file-name "Select org file to test: " 
                                     (expand-file-name "~/Dropbox/org/blog/") 
                                     nil t))
         (html-file (concat public_html-dir 
                           (file-name-sans-extension 
                            (file-name-nondirectory test-file)) 
                           ".html")))
    
    (message "\n\n=== MANUAL TEST OF DATE UPDATE ===")
    (message "Testing file: %s" test-file)
    (message "HTML file should be: %s" html-file)
    (message "HTML exists: %s" (file-exists-p html-file))
    (message "Date format: %s" (detect-date-format test-file))
    (message "Current date (ISO): %s" (get-current-date-iso))
    (message "Current date (English): %s" (get-current-date-english))
    (message "\nNow calling update-article-date-if-republishing...\n")
    
    (update-article-date-if-republishing test-file)
    
    (message "\n=== TEST COMPLETE ===")
    (message "Check the *Messages* buffer for debug output")
    (message "Open the file to see if #+UPDATED was modified")))

(defun test-current-buffer-date ()
  "Test date update on the current buffer's file"
  (interactive)
  (if (buffer-file-name)
      (progn
        (message "\n\n=== TESTING CURRENT BUFFER ===")
        (update-article-date-if-republishing (buffer-file-name))
        (revert-buffer t t)
        (message "\nBuffer reverted to show changes"))
    (message "Current buffer has no associated file")))

(message "Test functions loaded. Available commands:")
(message "  M-x test-date-update        - Test on any file")
(message "  M-x test-current-buffer-date - Test on current buffer")

(provide 'test-date-update)
;;; test-date-update.el ends here
