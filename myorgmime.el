;;; myorgmime.el ---                                 -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2022  Joseph Vidal-Rosset

;; see https://github.com/org-mime/org-mime

;; Author: Joseph Vidal-Rosset <joseph@vidal-rosset.net>
;; Keywords:

;;; myorgmime.el ---                                 -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2022  Joseph Vidal-Rosset

;; see https://github.com/org-mime/org-mime

;; Author: Joseph Vidal-Rosset <joseph@vidal-rosset.net>
;; Keywords:


(require 'org-mime)
(require 'oc-csl)
(require 'citeproc)

;; Utiliser SEMI pour Wanderlust (au lieu de MML qui est pour Gnus)
(setq org-mime-library 'semi)


(setq org-export-before-parsing-hook '(org-ref-csl-preprocess-buffer))  ;; to get the bibliography in email (thanks to John Kitchin)


;; css

(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "pre" (format "color: %s; background-color: %s; padding: 0.5em;"
                           "#E6E1DC" "#232323"))))

;; the following can be used to nicely offset block quotes in email bodies
(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "blockquote" "background-color: #F0F0F0; border-left: 5px solid #CCCCCC; line-height:24px; margin:0px 0px 24px 0px; padding: 6px 20px;")))

;; Below code renders text between "µ" in red color,

(add-hook 'org-mime-html-hook
          (lambda ()
            (while (re-search-forward "µ\\([^µ]*\\)" nil t)
              (replace-match "<span style=\"color:red\">\\1</span>"))))

;; To avoid exporting TOC, you can setup org-mime-export-options which overrides Org default settings (but still inferior to file-local settings),

(setq org-mime-export-options '(:with-latex dvipng
                                            :section-numbers nil
                                            :with-author nil
                                            :with-toc nil))

;; Configuration explicite pour la conversion LaTeX en images avec dvipng
(setq org-preview-latex-default-process 'dvipng)
(setq org-latex-create-formula-image-program 'dvipng)

;;; for exporting ascii code

(setq org-mime-export-ascii 'utf-8)

;; Configuration pour LaTeX avec Org 9.7+ et org-mime
(with-eval-after-load 'org
  (setq org-latex-preview-process-default 'dvipng)
  (setq org-html-with-latex 'dvipng))

(setq org-mime-export-options '(:with-latex dvipng
                                            :section-numbers nil
                                            :with-author nil
                                            :with-toc nil))


(provide 'myorgmime)
;;; myorgmime.el ends here
