;;; publish.el --- Complete blog publishing configuration -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Joseph Vidal-Rosset

;; Author: Joseph Vidal-Rosset <joseph@vidal-rosset.net>
;; Keywords: org-mode, publishing, blog
;; Version: 1.0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Complete blog publishing system for Org-mode with intelligent LaTeX class
;; selection, automatic sitemap generation, and separate workflows for blog
;; posts vs academic papers.
;;
;; Features:
;; - Tag-based content organization (arg, code, prov, french, academic)
;; - Intelligent LaTeX class selection (KOMA vs SMF based on content)
;; - Separate directories for blog posts and academic papers
;; - MathJax 4 support with bussproofs (self-hosted, no CDN)
;; - Custom CSS integration
;; - Automatic section page generation
;; - Smart PDF export routing

;;; Code:

(require 'org)
(require 'ox-html)
(require 'ox-latex)
(require 'ox-publish)

;; Add org-ref if available
(when (locate-library "org-ref")
  (require 'org-ref))

;; =================================================================
;; CONFIGURATION VARIABLES
;; =================================================================

;; Blog author information
(defvar my-blog-author "Joseph Vidal-Rosset")
(defvar my-blog-author-email "joseph@vidal-rosset.net")
(defvar my-blog-institution "Université de Lorraine")

;; Directory structure
(defvar emacs-personal-dir (expand-file-name "~/.emacs.d/personal/"))
(defvar dropbox-dir (expand-file-name "~/Dropbox/"))
(defvar dropbox-tex-dir (file-name-as-directory (concat dropbox-dir "tex")))
(defvar blog-root-dir (expand-file-name "~/Dropbox/org/blog/"))
(defvar public_html-dir (expand-file-name "~/Dropbox/public_html/"))
(defvar academic-dir (expand-file-name "~/Dropbox/tex/"))
(defvar academic-pdf-dir (expand-file-name "~/Dropbox/tex/pdf/"))

;; Public HTML subdirectories
(defvar emacs-personal-csl-dir (file-name-as-directory (concat emacs-personal-dir "csl")))
(defvar public_html-css-dir (file-name-as-directory (concat public_html-dir "css")))
(defvar public_html-images-dir (file-name-as-directory (concat public_html-dir "images")))
(defvar public_html-pdf-dir (file-name-as-directory (concat public_html-dir "pdf")))
(defvar public_html-csl-dir (file-name-as-directory (concat public_html-dir "csl")))

;; =================================================================
;; LOAD EXTERNAL CONFIGURATION
;; =================================================================

;; Load comprehensive LaTeX configuration
(let ((org-export-file (expand-file-name "~/.emacs.d/personal/preload/myorgexport.el")))
  (if (file-exists-p org-export-file)
      (condition-case err
          (progn
            (message "Loading org-export configuration from: %s" org-export-file)
            (load-file org-export-file)
            (message "myorgexport.el loaded successfully"))
        (error
         (message "Error loading myorgexport.el: %s - Using fallback classes" err)))
    (message "Warning: myorgexport.el not found at %s, using fallback classes" org-export-file)))


;; =================================================================
;; LOAD SPRINGER NATURE CONFIGURATION
;; =================================================================

;; Load Springer Nature journal classes
(let ((springer-config (expand-file-name "~/.emacs.d/personal/springer-nature-config.el")))
  (if (file-exists-p springer-config)
      (condition-case err
          (progn
            (message "Loading Springer Nature configuration from: %s" springer-config)
            (load-file springer-config)
            (message "Springer Nature classes loaded successfully"))
        (error
         (message "Error loading springer-nature-config.el: %s" err)))
    (message "Warning: springer-nature-config.el not found at %s" springer-config)))

;; =================================================================
;; BIBLIOGRAPHY AND ORG-REF CONFIGURATION
;; =================================================================

;; Configure org-ref with citations
(when (featurep 'org-ref)
  (setq org-ref-default-bibliography (list (concat dropbox-tex-dir "references.bib"))
        org-ref-pdf-directory (concat dropbox-dir "pdfs/")
        org-ref-notes-directory (concat dropbox-dir "notes/")))

;; Blog bibliography (separate from the academic references.bib above)
(defvar blog-bibliography-file (concat blog-root-dir "blog.bib"))

;; CSL configuration for citations
;; Only blog.bib is listed here: this is what the blog's CSL/HTML
;; export path resolves against. references.bib is deliberately left
;; out — it's a much larger, older file, and a single malformed entry
;; anywhere in it can break citeproc even for blog articles that never
;; cite a key from it. Academic papers don't go through this variable
;; at all: they use org-ref-default-bibliography (above) for the
;; LaTeX/PDF pipeline, a fully separate mechanism. Each article still
;; declares its own bibliography: line explicitly in its own text, so
;; nothing here needs to guess which file to use.
(setq org-cite-csl-styles-dir (concat emacs-personal-dir "csl/")
      org-cite-global-bibliography (list blog-bibliography-file)
      org-cite-csl-style "oil-shale")

;; GitHub link abbreviation: only the account name is fixed globally.
;; The repo, branch, and path stay free at each use site, in any
;; article regardless of topic:
;;   [[gh:my_prelude_emacs/blob/master/personal/exwm-config.el][label]]
;;   [[gh:G4plus/blob/main/g4plus.pl][label]]
;; If the GitHub account or org ever changes, this is the one line to
;; update; every article, past and future, follows automatically.
(setq org-link-abbrev-alist
      (append org-link-abbrev-alist
              '(("gh" . "https://github.com/joseph-vidal-rosset/%s"))))

;; Export configuration
(setq org-export-with-broken-links t)
(setq org-export-allow-bind-keywords t)
(setq org-html-validation-link nil)
(setq org-html-creator-string "")

;; Disable default Org MathJax
(setq org-html-mathjax-template "")
(setq org-html-mathjax-options nil)

;; =================================================================
;; MATHJAX 4 CONFIGURATION (self-hosted, no CDN)
;; =================================================================
;;
;; Server side (Dedibox), MathJax 4.1.3 pinned:
;;
;;   /var/www/html/mathjax/                     <- npm package `mathjax'
;;   /var/www/html/mathjax/fonts/mathjax-newcm-font/{chtml.js,chtml/}
;;                                              <- npm `@mathjax/mathjax-newcm-font'
;;
;; Served through /etc/apache2/conf-available/mathjax.conf (Alias /mathjax,
;; enabled with a2enconf, so every vhost inherits it).
;;
;; In v4 the fonts are NO LONGER bundled with the main package: the combined
;; component embeds the font data but fetches the .woff2 files from
;; loader.paths.fonts, which defaults to https://cdn.jsdelivr.net/npm/@mathjax.
;; The `paths' entry below is therefore what actually kills the last
;; third-party request -- do not drop it when upgrading.
;;
;; Upgrading: bump both packages together to the same version.
;;
;; `ui/lazy' typesets formulas only as they approach the viewport, which makes
;; long articles display almost immediately.  Two known trade-offs: the
;; browser's Ctrl-F will not find text inside formulas that have not been
;; typeset yet, and printing a long page may output blank formulas in some
;; browsers.  Drop 'ui/lazy' from the load list to revert.

(defvar my-blog-mathjax-script
  "<script>
window.MathJax = {
  loader: {
    load: ['[tex]/bussproofs', '[tex]/color', '[tex]/ams', 'ui/lazy'],
    paths: { fonts: '/mathjax/fonts' }
  },
  tex: {
    packages: {'[+]': ['bussproofs', 'color', 'ams']},
    tags: 'ams',
    inlineMath: [['$', '$'], ['\\\\(', '\\\\)']],
    displayMath: [['$$', '$$'], ['\\\\[', '\\\\]']]
  },
  startup: {
    ready() {
      MathJax.startup.defaultReady();
    }
  }
};
</script>
<script id=\"MathJax-script\" defer src=\"/mathjax/tex-mml-chtml.js\"></script>")

;; =================================================================
;; CSS CONFIGURATION
;; =================================================================

(defvar my-blog-external-css
  "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/stylesheet.css\" />")

(setq my-blog-html-head
      (concat my-blog-external-css my-blog-mathjax-script))

;; =================================================================
;; HEADER AND FOOTER
;; =================================================================

(defun my-blog-header (info)
  "Custom header for the blog with navigation"
  "<div class=\"banner\">
    <img src=\"images/owl.png\" alt=\"Owl\" style=\"width:50px;float:left;margin-right:0.8em;margin-top:0.2em;\">
    <a id=\"name\" href=\"index.html\">Joseph Vidal-Rosset - Personal Blog</a>
    <p class=\"subtitle\">Philosophy, Logic & Emacs</p>
  </div>
  <header>
    <nav>
      <div class=\"nav-links\">
        <a href=\"index.html\">Home</a> |
        <a href=\"jvr.html\">About</a> |
        <a href=\"arguments.html\">Arguments</a> |
        <a href=\"provers.html\">Provers</a> |
        <a href=\"code.html\">Code</a> |
        <a href=\"french.html\">En français</a>
      </div>
    </nav>
  </header>")

(defun my-blog-footer (info)
  "Custom footer for the blog with publication and update dates, plus Isso comments for articles."
  (let* ((file (plist-get info :input-file))
         (base (when file (file-name-base file)))
         ;; Exclude index, about, and section pages
         ;; Pages that get no comment thread: index, about, the four
         ;; section pages, and the legal notice.
         (is-special-page (member base '("index" "jvr" "arguments" "provers"
                                         "code" "french" "legal")))
         (dates (when file (extract-dates-from-file file)))
         (pub-date (car dates))
         (update-date (cadr dates))
         (date-line (cond
                     ((and pub-date update-date (not (string= pub-date update-date)))
                      (format "<p class=\"date\">Published: %s | Updated: %s</p>" pub-date update-date))
                     (pub-date
                      (format "<p class=\"date\">Published: %s</p>" pub-date))
                     (t "")))
         ;; Robust title retrieval (handles Org struct or plain string)
         (raw-title (let ((title (plist-get info :title)))
                      (when title
                        (let ((title-str (if (stringp title)
                                             title
                                           (org-export-data title info))))
                          ;; Escape double quotes for HTML attribute
                          (replace-regexp-in-string "\"" "&quot;" title-str)))))
         ;; Language for Isso (from #+LANGUAGE: in Org file)
         (lang (or (plist-get info :language) "en")))
    (concat
     date-line
     ;; Isso comment section – only for blog articles, language-aware
     (unless is-special-page
       (concat
;; --- Temporary moderation banner (remove on return) ---
;;        "<div style='margin:1.2em 0;padding:.7em 1em;border:1px solid #b58900;border-radius:8px;background:rgba(181,137,0,0.08);font-size:0.9m;'>\n
;;        <strong>Moderator:</strong> away from the internet from 22 to 26 July 2026
;;        no comment can be published on this site during this period.\n</div>\n"
;;        ;; --- end banner ---
        (format "<script data-isso=\"/isso/\" data-isso-lang=\"%s\" data-isso-vote=\"false\" src=\"/isso/js/embed.min.js\"></script>\n" lang)
        (when raw-title
          (format "<section id=\"isso-thread\" data-title=\"%s\"></section>\n" raw-title))))
     "<footer>
    <p>Copyright 2026 Joseph Vidal-Rosset - Generated with Emacs Org-mode
       - <a href=\"legal.html\">Legal notice</a></p>
   <div id=\"footer\">
      <p style=\"text-align:center;margin-bottom:1em;color:#657b83;font-size:0.9em;\">
        Powered by Free Software & AI:
      </p>
      <ul>
        <li><a href=\"https://www.gnu.org/software/emacs/\" title=\"GNU Emacs\">
       <img src=\"images/emacs-logo.png\" alt=\"Emacs\" style=\"width:50px;height:50px;\"></a></li>
        <li><a href=\"https://orgmode.org/\" title=\"Org Mode\">
          <img src=\"images/orgmode-logo.png\" alt=\"Org Mode\" style=\"width:50px;height:50px;\"></a></li>
        <li><a href=\"https://www.debian.org/\" title=\"Debian GNU/Linux\">
          <img src=\"images/debian-logo.png\" alt=\"Debian\" style=\"width:50px;height:50px;\"></a></li>
        <li><a href=\"https://mxlinux.org/\" title=\"MX Linux\">
          <img src=\"images/mx-logo.png\" alt=\"MX Linux\" style=\"width:50px;height:50px;\"></a></li>
        <li><a href=\"https://posativ.org/isso/\" title=\"Isso Comments\">
          <img src=\"images/isso-logo.png\" alt=\"Isso\" style=\"width:50px;height:50px;\"></a></li>
        <li><a href=\"https://claude.ai/\" title=\"Claude AI Assistant\">
          <img src=\"images/claude-ai-logo.png\" alt=\"Claude AI\" style=\"width:50px;height:50px;\"></a></li>
      </ul>
    </div>
  </footer>")))

;; =================================================================
;; DATE MANAGEMENT SYSTEM
;; =================================================================
;;
;; Automatic update date management:
;; - When an article with #+DATE: is republished (HTML already exists),
;;   the #+UPDATED: field is automatically set to today's date
;; - Dates are in English format (e.g., "January 16, 2026")
;; - Original #+DATE: is preserved
;; - Footer displays both dates: "Published: DATE | Updated: UPDATED"
;;
;; Usage:
;; 1. Create article with #+DATE: January 1, 2026
;; 2. Publish site → HTML created
;; 3. Modify article and publish again → #+UPDATED: automatically added
;; 4. Further modifications → #+UPDATED: automatically updated
;;
;; =================================================================
;; SITEMAP FUNCTIONS
;; =================================================================

(defun get-current-date-english ()
  "Return current date in English format (January 16, 2026)"
  (format-time-string "%B %e, %Y"))

(defun get-current-date-iso ()
  "Return current date in ISO format (2026-01-16)"
  (format-time-string "%Y-%m-%d"))

(defun detect-date-format (file)
  "Detect the date format used in the file (iso or english).
Returns 'iso for format like 2025-11-17
Returns 'english for format like November 17, 2025
Returns nil if no date found"
  (when (and file (file-exists-p file))
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (when (re-search-forward "^#\\+DATE:\\s-*\\(.*\\)$" nil t)
        (let ((date-str (string-trim (match-string 1))))
          (cond
           ((string-match "^[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}$" date-str) 'iso)
           ((string-match "^[A-Z][a-z]+ [0-9]+, [0-9]\\{4\\}$" date-str) 'english)
           (t nil)))))))


(defun my-blog-content-hash (file)
  "Return a SHA-256 of FILE's *significant* content.
The two volatile metadata lines, #+UPDATED: and #+CONTENT_HASH:, are
removed before hashing, trailing whitespace on every line is stripped,
and trailing blank lines are dropped, so that a cosmetic edit which
leaves the real content unchanged (a character moved then restored, a
re-save, a `touch') produces the same hash as before."
  (when (and file (file-exists-p file))
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (flush-lines "^#\\+UPDATED:")
      (goto-char (point-min))
      (flush-lines "^#\\+CONTENT_HASH:")
      (goto-char (point-min))
      (while (re-search-forward "[ \t]+$" nil t)
        (replace-match ""))
      (goto-char (point-max))
      (skip-chars-backward "\n")
      (delete-region (point) (point-max))
      (secure-hash 'sha256 (buffer-string)))))

(defun extract-content-hash (file)
  "Return the #+CONTENT_HASH: value recorded in FILE, or nil if none."
  (when (and file (file-exists-p file))
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (when (re-search-forward "^#\\+CONTENT_HASH:\\s-*\\(.*\\)$" nil t)
        (string-trim (match-string 1))))))

(defun my-blog-write-content-hash (hash)
  "Create or refresh the #+CONTENT_HASH: line in the current buffer.
The line is inserted right after #+DATE: (or #+TITLE: as a fallback).
Org ignores unknown keywords, so this line never appears in the HTML."
  (goto-char (point-min))
  (if (re-search-forward "^#\\+CONTENT_HASH:\\s-*.*$" nil t)
      (replace-match (format "#+CONTENT_HASH: %s" hash))
    (goto-char (point-min))
    (cond
     ((re-search-forward "^#\\+DATE:.*$" nil t)
      (end-of-line) (insert (format "\n#+CONTENT_HASH: %s" hash)))
     ((progn (goto-char (point-min))
             (re-search-forward "^#\\+TITLE:.*$" nil t))
      (end-of-line) (insert (format "\n#+CONTENT_HASH: %s" hash))))))

(defun update-article-date-if-republishing (file)
  "Set #+UPDATED only when FILE's *content* actually changed since the
last publication.

Real change is detected by comparing a SHA-256 of the significant
content (see `my-blog-content-hash') against the #+CONTENT_HASH: recorded
at the previous publication.  This makes the stamp immune to cosmetic
edits that leave the content identical, which mere file mtime cannot
distinguish.

Behaviour:
- No hash on record yet (first run of this mechanism, or brand-new
  article): record the hash, write NO #+UPDATED:.  This is what stops a
  first roll-out from stamping today's date on every existing article.
- Hash present and identical: do nothing — no fallacious #+UPDATED:.
- Hash present and different, on a day later than #+DATE:: stamp
  #+UPDATED: with today and refresh the hash.
- Hash present and different, the same day as #+DATE:: refresh the hash
  but write no #+UPDATED: (a same-day update carries no information)."
  (when (and file (file-exists-p file))
    (let* ((html-file (concat public_html-dir
                             (file-name-sans-extension
                              (file-name-nondirectory file))
                             ".html"))
           (already-published (file-exists-p html-file))
           (date-format (detect-date-format file))
           (today (if (eq date-format 'iso)
                     (get-current-date-iso)
                   (get-current-date-english)))
           (new-hash (my-blog-content-hash file))
           (stored-hash (extract-content-hash file))
           (first-hash (null stored-hash))
           (real-change (and stored-hash new-hash
                             (not (string= new-hash stored-hash)))))

      (message "=== UPDATE DATE DEBUG ===")
      (message "File: %s" file)
      (message "Already published: %s | first hash: %s | real change: %s"
               already-published first-hash real-change)

      (cond
       ;; Hash on record and content identical: leave everything untouched.
       ((and (not first-hash) (not real-change))
        (message "No real change; #+UPDATED left untouched"))

       ;; First hash, or genuine change: (re)write the hash, and stamp
       ;; #+UPDATED only for a real change on a later day.
       (t
        (with-current-buffer (find-file-noselect file)
          (save-excursion
            (goto-char (point-min))
            (let ((pub-date (when (re-search-forward "^#\\+DATE:\\s-*\\(.*\\)$" nil t)
                              (string-trim (match-string 1)))))
              (when pub-date
                (cond
                 ;; Genuine change on a later day → stamp UPDATED.
                 ((and already-published real-change
                       (not (string= today pub-date)))
                  (goto-char (point-min))
                  (if (re-search-forward "^#\\+UPDATED:\\s-*\\(.*\\)$" nil t)
                      (replace-match (format "#+UPDATED: %s" today))
                    (goto-char (point-min))
                    (when (re-search-forward "^#\\+DATE:.*$" nil t)
                      (end-of-line)
                      (insert (format "\n#+UPDATED: %s" today))))
                  (message "✓ Content changed; #+UPDATED set to %s for %s"
                           today (file-name-nondirectory file)))
                 ;; Genuine same-day change → strip any stale UPDATED.
                 ((and real-change (string= today pub-date))
                  (goto-char (point-min))
                  (when (re-search-forward "^#\\+UPDATED:.*$" nil t)
                    (delete-region (line-beginning-position)
                                   (min (point-max) (1+ (line-end-position))))))
                 (t
                  (message "Recording content hash (no #+UPDATED) for %s"
                           (file-name-nondirectory file))))
                ;; Always record the fresh content hash.
                (my-blog-write-content-hash new-hash)
                (save-buffer)))))))
      (message "=== END UPDATE DATE DEBUG ==="))))

(defun blog-clear-updated (&optional file)
  "Remove a fallacious #+UPDATED: line from FILE (default: current buffer's
file) and refresh its #+CONTENT_HASH:, so the article shows only its
original date.  Use this for a legacy article stamped before the
content-hash mechanism existed."
  (interactive)
  (let ((file (or file (buffer-file-name))))
    (when (and file (file-exists-p file))
      (with-current-buffer (find-file-noselect file)
        (save-excursion
          (goto-char (point-min))
          (when (re-search-forward "^#\\+UPDATED:.*$" nil t)
            (delete-region (line-beginning-position)
                           (min (point-max) (1+ (line-end-position)))))
          (my-blog-write-content-hash (my-blog-content-hash file))
          (save-buffer)
          (message "Cleared #+UPDATED and refreshed hash for %s"
                   (file-name-nondirectory file)))))))

(defun extract-dates-from-file (file)
  "Extract both publication date and update date from org file"
  (when (and file (file-exists-p file))
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (let ((pub-date (when (re-search-forward "^#\\+DATE:\\s-*\\(.*\\)$" nil t)
                        (string-trim (match-string 1))))
            (update-date (progn
                           (goto-char (point-min))
                           (when (re-search-forward "^#\\+UPDATED:\\s-*\\(.*\\)$" nil t)
                             (string-trim (match-string 1))))))
        (list pub-date update-date)))))

(defun my-blog-format-date-display (pub-date update-date)
  "Return the date string shown next to an article link.
Show only PUB-DATE when there is no UPDATE-DATE, or when UPDATE-DATE is
identical to PUB-DATE: an \"update\" made the same day the article was
first published carries no information and must not be duplicated.
Otherwise show \"PUB-DATE, updated UPDATE-DATE\"."
  (if (and update-date
           (not (string-empty-p (string-trim update-date)))
           (not (string= (string-trim update-date)
                         (string-trim (or pub-date "")))))
      (format "%s, updated %s" pub-date update-date)
    pub-date))

;; (defun get-abstract-text (file-path)
;;   "Return the abstract content as a single-line string, or nil."
;;   (when (and file-path (file-exists-p file-path))
;;    (with-temp-buffer
;;      (insert-file-contents file-path)
;;      (goto-char (point-min))
;;      (when (re-search-forward "^#\\+BEGIN_abstract\\(.*\\)\n" nil t)
;;        (let* ((start (point))
;;              (end (if (re-search-forward "^#\\+END_abstract" nil t)
;;                        (match-beginning 0)
;;                      (point-max)))
;;               (content (buffer-substring-no-properties start end)))
;;          (unless (string-empty-p (string-trim content))
;;            (replace-regexp-in-string "\n+" " " (string-trim content))))))))

(defun get-abstract-text (file-path)
  "Return the abstract content as a single-line string, or nil.
The extract stops at the first Org link, which is replaced by an
ellipsis, so that no link markup ever reaches the index pages."
  (when (and file-path (file-exists-p file-path))
    (with-temp-buffer
      (insert-file-contents file-path)
      (goto-char (point-min))
      (when (re-search-forward "^#\\+BEGIN_abstract\\(.*\\)\n" nil t)
        (let* ((start (point))
               (end (if (re-search-forward "^#\\+END_abstract" nil t)
                        (match-beginning 0)
                      (point-max)))
               (content (buffer-substring-no-properties start end)))
          (unless (string-empty-p (string-trim content))
            (let ((txt (replace-regexp-in-string "\n+" " " (string-trim content))))
              (if (string-match "\\[\\[" txt)
                  (concat (string-trim-right (substring txt 0 (match-beginning 0))) " ...")
                txt))))))))

(defun my-blog-sitemap-post-date (post)
  "Return the ISO publication date of POST (a sitemap entry), or \"\".
POST is an entry from the list passed to the sitemap function; its car
is an org link of the form [[file:...][title]]."
  (let* ((link (car post))
         (file-path (when (string-match "\\[\\[file:\\([^]]+\\)\\]\\[.*\\]\\]" link)
                      (match-string 1 link)))
         (full-path (when file-path
                      (expand-file-name file-path blog-root-dir))))
    (or (and full-path
             (file-exists-p full-path)
             (car (extract-dates-from-file full-path)))
        "")))

(defun my-blog-sitemap-with-updates (title list)
  "Generate sitemap with posts organized by sections using tags and update dates,
with abstract text only (no 'Read more' link)."
  (let* ((posts (cdr list))
         (arguments-posts '())
         (code-posts '())
         (provers-posts '())
         (french-posts '()))

    ;; Categorize posts by tags
    (dolist (post posts)
      (let* ((link (car post))
             (file-path (when (string-match "\\[\\[file:\\([^]]+\\)\\]\\[.*\\]\\]" link)
                         (match-string 1 link)))
             (full-path (when file-path
                         (expand-file-name file-path blog-root-dir))))
        (when (and full-path (file-exists-p full-path))
          (with-temp-buffer
            (insert-file-contents full-path)
            (goto-char (point-min))
            (when (re-search-forward "^#\\+TAGS:\\s-*\\(.*\\)$" nil t)
              (let ((tags (string-trim (downcase (match-string 1)))))
                (cond
                 ((string= tags "code") (push post code-posts))
                 ((string= tags "prov") (push post provers-posts))
                 ((string= tags "french") (push post french-posts))
                 ((string= tags "arg") (push post arguments-posts)))))))))

    ;; Explicit anti-chronological sort by #+DATE (most recent first).
    ;; Do NOT rely on :sitemap-sort-files ordering: org-publish-find-date
    ;; only understands org timestamps like <2026-05-01>; with plain ISO
    ;; dates it silently falls back to file mtime, which is meaningless
    ;; here.  ISO dates sort correctly as strings.
    (let ((by-date-desc (lambda (a b)
                          (string> (my-blog-sitemap-post-date a)
                                   (my-blog-sitemap-post-date b)))))
      (setq arguments-posts (sort arguments-posts by-date-desc)
            code-posts (sort code-posts by-date-desc)
            provers-posts (sort provers-posts by-date-desc)
            french-posts (sort french-posts by-date-desc)))

    ;; Helper function to generate a post entry with abstract only
    (cl-flet ((format-post (post)
                (let* ((link (car post))
                       (file-path (when (string-match "\\[\\[file:\\([^]]+\\)\\]\\[.*\\]\\]" link)
                                   (match-string 1 link)))
                       (full-path (when file-path
                                   (expand-file-name file-path blog-root-dir)))
                       (dates (when full-path (extract-dates-from-file full-path)))
                       (pub-date (car dates))
                       (update-date (cadr dates))
                       (date-display (my-blog-format-date-display pub-date update-date))
                       (abstract (get-abstract-text full-path)))
                  (concat
                   (format "- %s" link)
                   (when date-display (format " (%s)" date-display))
                   "\n"
                   ;; Abstract inséré proprement avec @@html: sur une seule ligne
                   (when abstract
                     (concat "  @@html:<span class=\"abstract\">"
                             (replace-regexp-in-string "\"" "&quot;" abstract)
                             "</span>@@\n"))))))

    ;; Generate content with dates and abstracts
    (concat
     "#+OPTIONS: title:nil toc:nil num:nil\n"
     "#+LANGUAGE: en\n\n"

     (when arguments-posts
       (concat "* Arguments\n\n"
               (mapconcat (lambda (post) (format-post post))
                          arguments-posts "")))

     (when code-posts
       (concat "\n* Code\n\n"
               (mapconcat (lambda (post) (format-post post))
                          code-posts "")))

     (when provers-posts
       (concat "\n* Provers\n\n"
               (mapconcat (lambda (post) (format-post post))
                          provers-posts "")))

     (when french-posts
       (concat "\n* En français\n\n"
               (mapconcat (lambda (post) (format-post post))
                          french-posts "")))))))

;; =================================================================
;; SECTION PAGE CREATION
;; =================================================================

(defun create-section-page (section-name tag page-filename)
  "Create an index page for a section based on a tag"
  (let ((section-file (concat blog-root-dir page-filename))
        (filtered-posts '()))
    (with-temp-buffer
      (insert (format "#+TITLE: %s\n" section-name))
      (insert (format "#+AUTHOR: %s\n" my-blog-author))
      (insert "#+OPTIONS: title:nil toc:nil num:nil\n")
      (insert "#+LANGUAGE: en\n\n")
      (insert (format "* %s\n\n" section-name))

      ;; Generate list of articles with the exact tag
      (let ((org-files (directory-files blog-root-dir t "\\.org$")))
        (dolist (file org-files)
          (when (and (file-readable-p file)
                     (not (member (file-name-nondirectory file)
                                  '("index.org" "arguments.org" "provers.org"
                                    "code.org" "french.org" "jvr.org"))))
            (with-temp-buffer
              (insert-file-contents file)
              (goto-char (point-min))
              (when (re-search-forward "^#\\+TAGS:\\s-*\\(.*\\)$" nil t)
                (let ((file-tag (string-trim (downcase (match-string 1)))))
                  (when (string= file-tag tag)
                    (let* ((title (progn
                                    (goto-char (point-min))
                                    (if (re-search-forward "^#\\+TITLE:\\s-*\\(.*\\)$" nil t)
                                        (match-string 1)
                                      (file-name-base file))))
                           (dates (extract-dates-from-file file))
                           (pub-date (car dates))
                           (update-date (cadr dates))
                           (date-display (my-blog-format-date-display pub-date update-date))
                           (filename (file-name-nondirectory file))
                           (html-name (concat (file-name-sans-extension filename) ".html")))
                      (push (list title date-display html-name file) filtered-posts))))))))

        ;; Sort by publication date (most recent first)
        (setq filtered-posts
              (sort filtered-posts
                    (lambda (a b)
                      (let ((date-a (car (split-string (cadr a) ",")))
                            (date-b (car (split-string (cadr b) ","))))
                        (string> date-a date-b)))))

        ;; Generate content
        (if filtered-posts
            (dolist (post filtered-posts)
              (let ((title (car post))
                    (date-display (cadr post))
                    (html-name (caddr post)))
                (insert (format "- [[file:%s][%s]] (%s)\n" html-name title date-display))))
          (insert "No articles in this section yet.\n")))

      (write-file section-file)
      (message "Page %s created: %s with %d articles" section-name section-file
               (length filtered-posts)))))

(defun create-about-page ()
  "Create the About page with the updated, more sober content."
  (let ((about-file (concat blog-root-dir "jvr.org")))
    (with-temp-buffer
      (insert "#+TITLE: About Joseph Vidal-Rosset\n")
      (insert (format "#+AUTHOR: %s\n" my-blog-author))
      (insert "#+OPTIONS: title:nil toc:nil num:nil\n")
      (insert "#+LANGUAGE: en\n\n")
      (insert "* About me\n\n")
      (insert "** Academic Background\n\n")
      (insert "As  Associate   Professor  (i.e.  Maître  de   conférences),  I  teach
philosophy and logic at [[https://philo.shs-nancy.univ-lorraine.fr/][the Philosophy Department of Lorraine University (Nancy - France)]].


")
      (insert "** Research Interests\n")
      (insert "- Logic\n")
      (insert "- Proof Theory\n")
      (insert "- Philosophy of Knowledge\n\n")
      (insert "** Contact\n\n")
      (insert (format "Email: %s\n\n" my-blog-author-email))
      (insert "** Tools & Workflow\n\n")
      (insert "This blog is entirely written and maintained using:\n")
      (insert "- GNU Emacs\n")
      (insert "- Org-mode\n")
      (insert "- Free Software tools\n\n")
      (insert "Everything is published using Emacs Org-publish with custom CSS.\n")
      (write-file about-file)
      (message "About page created: %s" about-file))))

(defun create-all-section-pages ()
  "Create all section pages"
  (interactive)
  ;; (create-about-page)  ;; à désactiver pour modifier jvr.org le cas échéant
  (create-section-page "Arguments" "arg" "arguments.org")
  (create-section-page "Provers" "prov" "provers.org")
  (create-section-page "Code" "code" "code.org")
  (create-section-page "En français" "french" "french.org")
  (message "All section pages have been created!"))

;; =================================================================
;; LATEX CLASS SELECTION FUNCTIONS
;; =================================================================

(defun get-file-tag ()
  "Get the tag of current org file"
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^#\\+TAGS:\\s-*\\(.*\\)$" nil t)
      (string-trim (downcase (match-string 1))))))

(defun get-latex-class ()
  "Get LaTeX class from current org file"
  (save-excursion
    (goto-char (point-min))
    (if (re-search-forward "^#\\+LATEX_CLASS:\\s-*\\(.*\\)$" nil t)
        (string-trim (match-string 1))
      nil)))

(defun get-file-language ()
  "Get language from current org file"
  (save-excursion
    (goto-char (point-min))
    (if (re-search-forward "^#\\+LANGUAGE:\\s-*\\(.*\\)$" nil t)
        (string-trim (downcase (match-string 1)))
      "en")))

(defun is-math-heavy-content ()
  "Detect if content is math-heavy for SMF class selection"
  (save-excursion
    (goto-char (point-min))
    (let ((math-indicators 0))
      ;; Count mathematical indicators
      (when (re-search-forward "\\\\begin{\\(theorem\\|lemma\\|proof\\|proposition\\|definition\\)" nil t)
        (setq math-indicators (+ math-indicators 2)))
      (goto-char (point-min))
      (while (re-search-forward "\\$\\$\\|\\\\\\[\\|\\\\begin{equation}" nil t)
        (setq math-indicators (+ math-indicators 1)))
      (goto-char (point-min))
      (when (re-search-forward "\\(logic\\|theorem\\|proof\\|mathematics\\|formal\\)" nil t)
        (setq math-indicators (+ math-indicators 1)))
      (> math-indicators 3))))

(defun determine-optimal-latex-class ()
  "Intelligently determine the best LaTeX class for current document"
  (let* ((tag (get-file-tag))
         (language (get-file-language))
         (explicit-class (get-latex-class))
         (is-blog-post (member tag '("arg" "code" "prov" "french")))
         (is-academic (string= tag "academic"))
         (is-jar (string= tag "jar"))  ; ← NOUVEAU
         (is-letter (string= tag "letter"))
         (is-beamer (string= tag "beamer"))
         (math-heavy (is-math-heavy-content)))

    (cond
     ;; Explicit class takes precedence
     (explicit-class explicit-class)

     ;; JAR submission - use Springer Nature with referee mode
     (is-jar "sn-jnl-jar")  ; ← NOUVEAU

     ;; Special document types
     (is-letter (if (string= language "fr") "lettre-koma" "koma-article"))
     (is-beamer (if (string= language "fr") "beamer-fr" "beamer-en"))

     ;; Blog posts: ALWAYS KOMA regardless of math content
     (is-blog-post "koma-article")

     ;; Academic papers: SMF for math-heavy, KOMA for general
     (is-academic
      (if math-heavy
          (if (string= language "fr") "smfart-fr" "smfart-en")
        "koma-article"))

     ;; Default: for documents outside blog, apply math detection
     (t (if math-heavy
            (if (string= language "fr") "smfart-fr" "smfart-en")
          "koma-article")))))

;; =================================================================
;; PDF EXPORT FUNCTIONS
;; =================================================================

(defun export-to-pdf ()
  "Smart PDF export with intelligent class selection and directory routing"
  (interactive)
  (let* ((org-file (buffer-file-name))
         (file-tag (get-file-tag))
         (optimal-class (determine-optimal-latex-class))
         (is-blog-post (member file-tag '("arg" "code" "prov" "french")))
         (pdf-name (concat (file-name-sans-extension
                           (file-name-nondirectory org-file)) ".pdf"))
         (target-dir (if is-blog-post public_html-pdf-dir academic-pdf-dir))
         (pdf-path (concat target-dir pdf-name)))

    ;; Ensure target directory exists
    (unless (file-exists-p target-dir)
      (make-directory target-dir t))

    ;; Message about class selection
    (message "Exporting with class: %s (detected from content)" optimal-class)

    ;; Export with determined class
    (let ((org-latex-default-class optimal-class))
      (org-latex-export-to-pdf))

    ;; Move PDF to appropriate directory
    (let ((generated-pdf (concat (file-name-sans-extension org-file) ".pdf")))
      (when (file-exists-p generated-pdf)
        (copy-file generated-pdf pdf-path t)
        (delete-file generated-pdf)
        (message "PDF exported to %s using %s class (%s)"
                 pdf-path
                 optimal-class
                 (if is-blog-post "blog post" "academic paper"))))))

(defun export-academic-pdf ()
  "Force academic PDF export using SMF class based on language"
  (interactive)
  (let* ((org-file (buffer-file-name))
         (pdf-name (concat (file-name-sans-extension
                           (file-name-nondirectory org-file)) ".pdf"))
         (pdf-path (concat academic-pdf-dir pdf-name))
         (language (get-file-language))
         (academic-class (if (string= language "fr") "smfart-fr" "smfart-en")))

    ;; Ensure directory exists
    (unless (file-exists-p academic-pdf-dir)
      (make-directory academic-pdf-dir t))

    ;; Export with SMF class
    (let ((org-latex-default-class academic-class))
      (org-latex-export-to-pdf))

    ;; Move PDF to academic directory
    (let ((generated-pdf (concat (file-name-sans-extension org-file) ".pdf")))
      (when (file-exists-p generated-pdf)
        (copy-file generated-pdf pdf-path t)
        (delete-file generated-pdf)
        (message "Academic PDF exported to %s using %s class" pdf-path academic-class)))))

(defun get-available-latex-classes ()
  "Extract all available LaTeX class names from org-latex-classes"
  (mapcar #'car org-latex-classes))

(defun export-with-class (class-name)
  "Export PDF with specified LaTeX class - auto-detects available classes"
  (interactive
   (list (completing-read "LaTeX class: "
                          (get-available-latex-classes) nil t)))
  (let* ((org-file (buffer-file-name))
         (file-tag (get-file-tag))
         (is-blog-post (member file-tag '("arg" "code" "prov" "french")))
         (pdf-name (concat (file-name-sans-extension
                           (file-name-nondirectory org-file)) ".pdf"))
         (target-dir (if is-blog-post public_html-pdf-dir academic-pdf-dir))
         (pdf-path (concat target-dir pdf-name)))

    (unless (file-exists-p target-dir)
      (make-directory target-dir t))

    (message "Exporting with class: %s" class-name)
    (let ((org-latex-default-class class-name))
      (org-latex-export-to-pdf))

    (let ((generated-pdf (concat (file-name-sans-extension org-file) ".pdf")))
      (when (file-exists-p generated-pdf)
        (copy-file generated-pdf pdf-path t)
        (delete-file generated-pdf)
        (message "PDF exported to %s using %s class" pdf-path class-name)))))

;; =================================================================
;; AUTHOR-DATE BIBTEX EXPORT (plain article + natbib)
;; =================================================================
;;
;; Rationale: when org-ref is loaded, citation links such as
;; [[citep:&key]] or [[cite:&key]] are exported through org-ref's
;; own link machinery, which ends up producing bare \cite{} commands
;; and therefore NUMERIC references, whatever natbib or biblatex
;; options are declared in the file.  The functions below bypass
;; org-ref entirely: they work on a temporary copy of the buffer
;; (the original .org file is never modified), translate citation
;; links into raw natbib commands, translate bibliography: and
;; bibliographystyle: links into raw LaTeX, make sure natbib is
;; loaded, and run the full pdflatex -> bibtex -> pdflatex -> pdflatex
;; cycle.  Plain BibTeX only: no biblatex, no biber, no CSL.
;;
;; Commands:
;;   M-x export-article-authordate      -> author-date PDF via BibTeX
;;   M-x export-article-authordate-tex  -> .tex file only

(defvar my-authordate-bibstyle "plainnat"
  "Default BibTeX style for author-date export.
`plainnat' ships with natbib and is always available in TeX Live.
Other author-date .bst choices: apalike, authordate1..4,
chicagoa (from the chicago package).")

(defvar my-authordate-numeric-styles
  '("plain" "abbrv" "unsrt" "alpha" "ieeetr" "acm" "siam" "smfplain" "splncs04")
  "BibTeX styles known to produce NUMERIC citations.
When one of these appears in a bibliographystyle: link during an
author-date export, it is silently replaced by
`my-authordate-bibstyle', otherwise the export would produce
numbers again.")

(defun my-authordate--natbib-command (type path)
  "Build a raw natbib command from an org-ref citation link.
TYPE is the link type (\"cite\", \"citep\", \"citet\", ...), PATH
its path, e.g. \"&key\", \"&key1;&key2\" or \"see &key p. 146\".
Pre-notes (text before the first &key) and post-notes (text after
the last key) are turned into natbib optional arguments."
  (let* ((cmd (pcase type
                ;; with natbib in authoryear mode, \cite behaves as \citet
                ("cite" "citet")
                ("textcite" "citet")
                ("parencite" "citep")
                ("autocite" "citep")
                (_ type)))
         (keys '())
         (first-amp (string-match "&" path))
         (last-end nil)
         (start 0))
    (while (string-match "&\\([-A-Za-z0-9_:.+/]+\\)" path start)
      (push (match-string 1 path) keys)
      (setq last-end (match-end 0)
            start (match-end 0)))
    (setq keys (nreverse keys))
    (if (null keys)
        ;; org-ref v2 path without &: the whole path is the key list
        (format "\\%s{%s}" cmd (string-trim path))
      (let* ((keystr (mapconcat #'identity keys ","))
             (prenote (when (and first-amp (> first-amp 0))
                        (let ((s (string-trim (substring path 0 first-amp)
                                              "[ \t;,]+" "[ \t;,]+")))
                          (unless (string-empty-p s) s))))
             (postnote (let ((s (string-trim (substring path last-end)
                                             "[ \t;,]+" "[ \t;,]+")))
                         (unless (string-empty-p s) s))))
        (cond
         ((and prenote postnote)
          (format "\\%s[%s][%s]{%s}" cmd prenote postnote keystr))
         (postnote (format "\\%s[%s]{%s}" cmd postnote keystr))
         (prenote  (format "\\%s[%s][]{%s}" cmd prenote keystr))
         (t        (format "\\%s{%s}" cmd keystr)))))))

(defun my-authordate--convert-buffer ()
  "Translate citation and bibliography links into raw LaTeX.
Handles org-ref bracketed links ([[citep:&key]]), org-cite links
([cite:@key]) and plain org-ref links (citep:&key).  Also
converts bibliography: and bibliographystyle: lines and makes
sure natbib is loaded.  This function modifies the CURRENT
buffer: it must only be called inside `org-export-with-buffer-copy'."
  (let ((case-fold-search nil)
        (style-found nil))
    ;; 1. Bracketed org-ref citation links, with optional description
    (goto-char (point-min))
    (while (re-search-forward
            "\\[\\[\\(cite[a-z]*\\|nocite\\|textcite\\|parencite\\|autocite\\):\\([^][]+\\)\\]\\(?:\\[[^][]*\\]\\)?\\]"
            nil t)
      (let ((rep (save-match-data
                   (my-authordate--natbib-command (match-string 1)
                                                  (match-string 2)))))
        (replace-match (concat "@@latex:" rep "@@") t t)))
    ;; 2. org-cite links: [cite:@key], [cite/t:@key1;@key2 p. 12]
    (goto-char (point-min))
    (while (re-search-forward
            "\\[cite\\(?:/\\([a-z/]+\\)\\)?:\\([^][]+\\)\\]" nil t)
      (let ((rep (save-match-data
                   (let* ((style (match-string 1))
                          (path (replace-regexp-in-string
                                 "@" "&" (match-string 2)))
                          (type (pcase style
                                  ("t" "citet")
                                  ("na" "citeauthor")
                                  ("noauthor" "citeyear")
                                  (_ "citep"))))
                     (my-authordate--natbib-command type path)))))
        (replace-match (concat "@@latex:" rep "@@") t t)))
    ;; 3. Plain (non-bracketed) org-ref citation links: citep:&key1;&key2
    (goto-char (point-min))
    (while (re-search-forward
            "\\_<\\(cite[a-z]*\\|nocite\\):\\(&[-A-Za-z0-9_:.+/&;]+\\)" nil t)
      (let ((rep (save-match-data
                   (my-authordate--natbib-command (match-string 1)
                                                  (match-string 2)))))
        (replace-match (concat "@@latex:" rep "@@") t t)))
    ;; 4. bibliographystyle: links -> \bibliographystyle{...}
    ;;    (numeric styles are upgraded to `my-authordate-bibstyle')
    (goto-char (point-min))
    (while (re-search-forward
            "^[ \t]*\\(?:\\[\\[\\)?bibliographystyle:\\([^][ \t\n]+\\)\\(?:\\]\\]\\)?[ \t]*$"
            nil t)
      (let ((style (match-string 1)))
        (when (member style my-authordate-numeric-styles)
          (message "Author-date export: numeric style '%s' replaced by '%s'"
                   style my-authordate-bibstyle)
          (setq style my-authordate-bibstyle))
        (replace-match (format "#+LATEX: \\bibliographystyle{%s}" style) t t)
        (setq style-found t)))
    ;; 5. bibliography: links -> \bibliography{...} (paths expanded,
    ;;    .bib extension stripped, default style inserted if missing)
    (goto-char (point-min))
    (while (re-search-forward
            "^[ \t]*\\(?:\\[\\[\\)?bibliography:\\([^][\n]+?\\)\\(?:\\]\\]\\)?[ \t]*$"
            nil t)
      (let ((clean (save-match-data
                     (mapconcat
                      (lambda (p)
                        (file-name-sans-extension (expand-file-name p)))
                      (split-string (match-string 1) "[,;]" t "[ \t]+")
                      ","))))
        (replace-match
         (concat (unless style-found
                   (format "#+LATEX: \\bibliographystyle{%s}\n"
                           my-authordate-bibstyle))
                 (format "#+LATEX: \\bibliography{%s}" clean))
         t t)
        (setq style-found t)))
    ;; 6. Purge any biblatex machinery: header lines loading biblatex
    ;;    or declaring bib resources, and org-cite bibliography keyword.
    ;;    biblatex breaks the plain BibTeX cycle (\bibliographystyle
    ;;    becomes a fatal error and biber is required).
    (goto-char (point-min))
    (let ((kill-re (concat "^[ \t]*#\\+\\(?:LATEX_HEADER\\|LATEX_HEADER_EXTRA\\):"
                           ".*\\(?:biblatex\\|addbibresource\\|printbibliography\\).*\n?")))
      (while (re-search-forward kill-re nil t)
        (replace-match "" t t)))
    (goto-char (point-min))
    (while (re-search-forward "^[ \t]*#\\+print_bibliography:.*\n?" nil t)
      (replace-match "" t t))
    (goto-char (point-min))
    (while (re-search-forward "^[ \t]*\\\\printbibliography[ \t]*$" nil t)
      (replace-match "" t t))
    ;; 7. Force the dedicated clean class, whatever the file declares
    (goto-char (point-min))
    (if (re-search-forward "^#\\+LATEX_CLASS:.*$" nil t)
        (replace-match "#+LATEX_CLASS: authordate-article" t t)
      (goto-char (point-min))
      (insert "#+LATEX_CLASS: authordate-article\n"))
    ;; 8. Make sure natbib is loaded (plain, no options: options are
    ;;    set with \\setcitestyle to avoid any option clash)
    (goto-char (point-min))
    (unless (re-search-forward "natbib" nil t)
      (goto-char (point-min))
      (insert "#+LATEX_HEADER: \\usepackage{natbib}\n"))))

(defvar my-authordate-pdf-process
  '("pdflatex -interaction nonstopmode -output-directory %o %f"
    "bibtex %b"
    "pdflatex -interaction nonstopmode -output-directory %o %f"
    "pdflatex -interaction nonstopmode -output-directory %o %f")
  "Compilation cycle for author-date export: plain BibTeX, no biber.")

(defun my-authordate--ensure-article-class ()
  "Define the dedicated \"authordate-article\" LaTeX class.
A plain article class fully controlled by this file, so that no
external configuration (myorgexport.el, org-cite, custom
\"article\" class) can inject biblatex or anything else into
its skeleton.  Redefined at each call to stay canonical."
  (setq org-latex-classes
        (cons '("authordate-article"
                "\\documentclass[11pt]{article}"
                ("\\section{%s}" . "\\section*{%s}")
                ("\\subsection{%s}" . "\\subsection*{%s}")
                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                ("\\paragraph{%s}" . "\\paragraph*{%s}")
                ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
              (assoc-delete-all "authordate-article" org-latex-classes))))

(defun export-article-authordate ()
  "Export current org file to an author-date PDF via plain BibTeX.
Bypasses org-ref completely (see comment block above).  Uses the
file's #+LATEX_CLASS if declared, plain \"article\" otherwise.
The PDF is moved to `academic-pdf-dir'.  The .org file itself is
never modified."
  (interactive)
  (my-authordate--ensure-article-class)
  (let* ((org-file (buffer-file-name))
         (tex-file (concat (file-name-sans-extension org-file) ".tex"))
         (pdf-name (concat (file-name-sans-extension
                            (file-name-nondirectory org-file)) ".pdf"))
         (pdf-path (concat academic-pdf-dir pdf-name)))
    (unless (file-exists-p academic-pdf-dir)
      (make-directory academic-pdf-dir t))
    (org-export-with-buffer-copy
     (my-authordate--convert-buffer)
     (let ((org-latex-default-class "authordate-article")
           (org-latex-pdf-process my-authordate-pdf-process)
           ;; Neutralize org-ref's CSL preprocessing (citeproc), which
           ;; is installed globally via these hooks and would otherwise
           ;; re-render citations numerically during export.
           (org-export-before-processing-functions nil)
           (org-export-before-parsing-functions nil)
           ;; Keep biblatex out of the preamble, wherever it comes from
           (org-latex-packages-alist
            (seq-remove (lambda (e) (string-match-p "biblatex" (format "%S" e)))
                        org-latex-packages-alist))
           ;; And prevent oc-biblatex from injecting \usepackage{biblatex}
           (org-cite-export-processors '((t basic)))
           ;; The author line matters for a paper; the global blog
           ;; config may disable it.  In-file #+OPTIONS: author:nil
           ;; still takes precedence over this binding if needed.
           (org-export-with-author t))
       (org-export-to-file 'latex tex-file
         nil nil nil nil nil
         (lambda (file) (org-latex-compile file)))))
    (let ((generated-pdf (concat (file-name-sans-extension org-file) ".pdf")))
      (if (file-exists-p generated-pdf)
          (progn
            (copy-file generated-pdf pdf-path t)
            (delete-file generated-pdf)
            (message "Author-date PDF exported to %s (BibTeX style: %s)"
                     pdf-path my-authordate-bibstyle))
        (message "PDF not produced - check *Org PDF LaTeX Output* buffer")))))

(defun export-article-authordate-tex ()
  "Export current org file to a .tex file (article + natbib,
author-date citations), without compiling.  Compile then with:
pdflatex -> bibtex -> pdflatex -> pdflatex."
  (interactive)
  (my-authordate--ensure-article-class)
  (let* ((org-file (buffer-file-name))
         (tex-file (concat (file-name-sans-extension org-file) ".tex")))
    (org-export-with-buffer-copy
     (my-authordate--convert-buffer)
     (let ((org-latex-default-class "authordate-article")
           (org-export-before-processing-functions nil)
           (org-export-before-parsing-functions nil)
           (org-latex-packages-alist
            (seq-remove (lambda (e) (string-match-p "biblatex" (format "%S" e)))
                        org-latex-packages-alist))
           (org-cite-export-processors '((t basic)))
           (org-export-with-author t))
       (org-export-to-file 'latex tex-file)))
    (message "LaTeX exported to %s (compile: pdflatex, bibtex, pdflatex x2)"
             tex-file)))

;; =================================================================
;; FILE CREATION FUNCTIONS
;; =================================================================

(defun my-blog-slugify (title)
  "Convert TITLE to a slug suitable for a filename.
Runs of non-alphanumeric characters collapse to a single hyphen, and
leading or trailing hyphens are stripped afterwards -- so a title ending
in punctuation no longer yields a trailing dash."
  (let ((slug (downcase (replace-regexp-in-string "[^a-zA-Z0-9]+" "-" title))))
    (replace-regexp-in-string "\\`-+\\|-+\\'" "" slug)))

(defun new-org-file (title)
  "Create new org file with unified tag selection for blog or academic use.

Blog posts land in BLOG-ROOT-DIR/drafts/, which org-publish excludes and
git ignores.  Move the file up into BLOG-ROOT-DIR when you judge it ready
for a first publication.  Academic papers are unaffected: they still go
straight to ACADEMIC-DIR.

The date is asked rather than assumed, defaulting to today.  A draft
written in August and published in October must carry October's date,
both in its filename and in its #+DATE: header."
  (interactive "sTitle: ")
  (let* ((slug (my-blog-slugify title))
         (tag (completing-read "Choose tag: " '("arg" "code" "prov" "french" "aca" "jar") nil t))
         (is-jar (string= tag "jar"))
         (is-academic (or (string= tag "aca") is-jar))
         (date (read-string "Date (YYYY-MM-DD): " (format-time-string "%Y-%m-%d")))
         (base-dir (if is-academic
                       academic-dir
                     (concat blog-root-dir "drafts/")))
         (filename (format "%s%s-%s.org" base-dir date slug)))

    ;; Ensure target directory exists
    (unless (file-exists-p base-dir)
      (make-directory base-dir t))

    (find-file filename)
    (insert (format "#+TITLE: %s\n" title))
    (insert (format "#+AUTHOR: %s\n" my-blog-author))
    (insert (format "#+EMAIL: %s\n" my-blog-author-email))
    (insert (format "#+DATE: %s\n" date))
    (insert (format "#+UPDATED: %s\n" date))
    (insert (format "#+INSTITUTION: %s\n" my-blog-institution))
    (insert "#+LANGUAGE: en\n")
    (when is-jar
      (insert "#+LATEX_CLASS: sn-jnl-jar\n")
      (insert "#+LATEX_HEADER: \\jyear{2026}\n"))
    (insert "#+OPTIONS: toc:t num:t\n")
    ;; Only add CSL config for blog posts, academic uses org-ref
    (when (and (not is-academic) (file-exists-p public_html-csl-dir))
      (insert (format "#+csl-style: %soil-shale.csl\n" emacs-personal-csl-dir))
      (insert "#+csl-locale: en-US\n"))
    ;; Use "academic" as the actual tag for consistency with the system
    (insert (format "#+TAGS: %s\n"
                    (cond (is-jar "jar")
                          (is-academic "academic")
                          (t tag))))
    (insert "\n#+BEGIN_abstract\n\n#+END_abstract\n\n")
    (insert "* Introduction\n\n")
    (insert "\n* Conclusion\n\n")
    ;; Bibliography for all files. Blog posts default to blog.bib
    ;; (in blog-root-dir); academic papers keep references.bib.
    ;; A "* References" heading before the bibliography: line, plus an
    ;; explicit bibliographystyle:, is required for the CSL/org-cite
    ;; HTML export path to find a bibliography layout — otherwise it
    ;; fails with "NO BIBLIOGRAPHY LAYOUT IN CSL STYLE" even with a
    ;; valid .csl file and a valid .bib file.
    (insert "* References\n\n")
    (if is-academic
        (progn
          (insert (format "bibliography:%sreferences.bib\n" dropbox-tex-dir))
          (insert "bibliographystyle:smfplain\n"))
      (insert (format "bibliography:%s\n" blog-bibliography-file))
      (insert "bibliographystyle:plain\n"))
    (goto-char (point-min))
    (re-search-forward "^#+TAGS: ")
    (end-of-line)
    (if is-academic
        (message "New academic paper created: %s" filename)
      (message "New draft created: %s  --  move it to %s when ready"
               filename blog-root-dir))))

(defun new-letter (title)
  "Create new letter using KOMA letter class"
  (interactive "sSubject: ")
  (let* ((slug (my-blog-slugify title))
         (date (format-time-string "%Y-%m-%d"))
         (academic-dir (expand-file-name "~/Dropbox/org/"))
         (filename (format "%sletter-%s-%s.org" academic-dir date slug)))
    (unless (file-exists-p academic-dir)
      (make-directory academic-dir t))
    (find-file filename)
    (insert (format "#+TITLE: Letter: %s\n" title))
    (insert (format "#+AUTHOR: %s\n" my-blog-author))
    (insert (format "#+EMAIL: %s\n" my-blog-author-email))
    (insert (format "#+DATE: %s\n" date))
    (insert "#+LANGUAGE: en\n")
    (insert "#+LATEX_CLASS: lettre-koma\n")
    (insert "#+OPTIONS: toc:nil num:nil\n")
    (insert "#+TAGS: letter\n\n")
    (insert "#+LATEX_HEADER: \\setkomavar{subject}{" title "}\n")
    (insert "#+LATEX_HEADER: \\setkomavar{toname}{Recipient Name}\n")
    (insert "#+LATEX_HEADER: \\setkomavar{toaddress}{Recipient Address}\n\n")
    (insert "Dear ...,\n\n")
    (insert "\n\nSincerely,\n\n")
    (insert my-blog-author)
    (goto-char (point-min))
    (re-search-forward "Dear ")
    (message "New letter created: %s using KOMA letter class" filename)))

;; =================================================================
;; JAR PAPER CREATION
;; =================================================================

(defun new-jar-paper (title)
  "Create new paper for Journal of Automated Reasoning submission"
  (interactive "sPaper title: ")
  (let* ((slug (my-blog-slugify title))
         (date (format-time-string "%Y-%m-%d"))
         (filename (format "%s%s-jar-%s.org" academic-dir date slug)))

    (unless (file-exists-p academic-dir)
      (make-directory academic-dir t))

    (find-file filename)
    (insert (format "#+TITLE: %s\n" title))
    (insert (format "#+AUTHOR: %s\n" my-blog-author))
    (insert (format "#+EMAIL: %s\n" my-blog-author-email))
    (insert (format "#+DATE: %s\n" date))
    (insert (format "#+INSTITUTION: %s\n" my-blog-institution))
    (insert "#+LANGUAGE: en\n")
    (insert "#+LATEX_CLASS: sn-jnl-jar\n")
    (insert "#+OPTIONS: toc:nil num:t\n")
    (insert "#+TAGS: jar\n\n")

    ;; Springer Nature specific headers
    (insert "#+LATEX_HEADER: \\jyear{2026}\n")
    (insert "# Add these for final submission:\n")
    (insert "# #+LATEX_HEADER: \\doi{10.1007/...}\n")
    (insert "# #+LATEX_HEADER: \\received{Day Month Year}\n")
    (insert "# #+LATEX_HEADER: \\revised{Day Month Year}\n")
    (insert "# #+LATEX_HEADER: \\accepted{Day Month Year}\n\n")

    (insert "#+BEGIN_abstract\n")
    (insert "Write your abstract here (150-250 words).\n")
    (insert "Clearly state: problem, method, results, significance.\n")
    (insert "#+END_abstract\n\n")

    (insert "#+KEYWORDS: automated reasoning, proof theory, theorem proving, ")
    (insert "sequent calculus, natural deduction\n\n")

    (insert "* Introduction\n\n")
    (insert "Introduce the problem and your contribution.\n\n")

    (insert "* Background and Related Work\n\n")
    (insert "Review relevant literature.\n\n")

    (insert "* Methodology\n\n")
    (insert "Describe your approach.\n\n")

    (insert "** Definitions\n\n")
    (insert "#+BEGIN_definition\n")
    (insert "Define key concepts.\n")
    (insert "#+END_definition\n\n")

    (insert "** Main Results\n\n")
    (insert "#+BEGIN_theorem\n")
    (insert "State your main theorem.\n")
    (insert "#+END_theorem\n\n")

    (insert "#+BEGIN_proof\n")
    (insert "Provide the proof.\n")
    (insert "#+END_proof\n\n")

    (insert "* Implementation\n\n")
    (insert "Describe implementation details.\n\n")

    (insert "* Evaluation\n\n")
    (insert "Present experimental results.\n\n")

    (insert "* Conclusion\n\n")
    (insert "Summarize contributions and future work.\n\n")

    ;; Acknowledgments section
    (insert "* Acknowledgments\n\n")
    (insert "Acknowledge funding, colleagues, etc.\n\n")

    ;; Bibliography
    (insert "bibliographystyle:splncs04\n")
    (insert (format "bibliography:%sreferences.bib\n" dropbox-tex-dir))

    (goto-char (point-min))
    (re-search-forward "^\\* Introduction")
    (forward-line 2)
    (message "New JAR paper created: %s" filename)))

;; =================================================================
;; ORG-REF PUBLISHING FUNCTION
;; =================================================================

(defun org-ref-html-publish-to-html (plist filename pub-dir)
  "Publish HTML with org-ref bibliography processing"
  (unless (file-exists-p pub-dir)
    (make-directory pub-dir t))
  ;; Automatically update #+UPDATED date if article has been published before
  (update-article-date-if-republishing filename)
  (let* ((visitingp (find-buffer-visiting filename))
         (work-buffer (or visitingp (find-file-noselect filename))))
    (prog1
        (with-current-buffer work-buffer
          (let ((output-file (org-export-output-file-name ".html" nil pub-dir))
                (org-export-with-broken-links t))
            (condition-case err
                (if (featurep 'org-ref)
                    (org-ref-export-to-file-nomarks-noopen 'html output-file
                                                            nil nil nil nil plist)
                  (org-export-to-file 'html output-file nil nil nil nil plist))
              (error
               (message "Export error for %s: %s" filename err)
               (org-export-to-file 'html output-file nil nil nil nil plist)))))
      (unless visitingp
        (kill-buffer work-buffer)))))

(defun my-html-publish-to-html (plist filename pub-dir)
  "Wrapper for standard HTML publishing with automatic date updates"
  (unless (file-exists-p pub-dir)
    (make-directory pub-dir t))
  ;; Automatically update #+UPDATED date if article has been published before
  (update-article-date-if-republishing filename)
  ;; Call the standard org-html-publish-to-html function
  (org-html-publish-to-html plist filename pub-dir))

(defun my-org-buffer-has-real-citations-p ()
  "Return non-nil if the current buffer contains at least one actual
citation reference: a legacy org-ref link (cite:&key, citep:&key,
[[cite:&key]]...) or a modern org-cite link ([cite:@key],
[cite/t:@key]...). A bare `bibliography:' / `#+BIBLIOGRAPHY:'
declaration with nothing citing into it does not count."
  (save-excursion
    (goto-char (point-min))
    (or (re-search-forward
         "\\(?:\\[\\[\\)?\\_<\\(?:cite[a-z]*\\|nocite\\|textcite\\|parencite\\|autocite\\):&" nil t)
        (progn (goto-char (point-min))
               (re-search-forward "\\[cite\\(?:/[a-z/]+\\)?:@" nil t)))))

(defun my-org-neutralize-unused-bibliography ()
  "Safety net, not the primary fix: comment out bibliography
declarations (and a now-empty \"* References\" heading) if no real
citation is found in the text. The actual cause of the
\"NO BIBLIOGRAPHY LAYOUT IN CSL STYLE\" (wrong-type-argument listp)
crash turned out to be structural — the CSL/org-cite HTML export path
needs a \"* References\" heading above the bibliography: line plus an
explicit bibliographystyle:, both of which `new-org-file' now inserts
by default. This function just keeps things tidy for the rare file
that has the default lines but never actually cites anything. Only
ever called on the disposable export copy made by
`org-export-with-buffer-copy', never on the real .org file on disk."
  (unless (my-org-buffer-has-real-citations-p)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward
              "^[ \t]*\\(?:#\\+BIBLIOGRAPHY:\\|bibliographystyle:\\|bibliography:\\).*$"
              nil t)
        (replace-match (concat "# " (match-string 0)) t t))
      (goto-char (point-min))
      (while (re-search-forward "^\\*+[ \t]+References[ \t]*$" nil t)
        (replace-match (concat "# " (match-string 0)) t t)))))

(defun org-ref-export-to-file-nomarks-noopen (backend filename &optional async subtreep visible-only body-only info)
  "Export org-ref with citation processing and error handling"
  (org-export-with-buffer-copy
   (my-org-neutralize-unused-bibliography)
   (condition-case err
       (progn
         (org-export-expand-include-keyword)
         (when (featurep 'org-ref)
           (org-ref-process-buffer backend subtreep))
         (org-export-to-file backend filename async subtreep visible-only body-only info))
     (error
      (message "org-ref error for %s: %s" filename err)
      (org-export-to-file backend filename async subtreep visible-only body-only info)))))

(defun filter-local-links (link backend info)
  "Filter that converts all the /index.html links to /"
  (if (org-export-derived-backend-p backend 'html)
      (replace-regexp-in-string "/index.html" "/" link)))

(add-to-list 'org-export-filter-link-functions 'filter-local-links)

;; =================================================================
;; ORG-PUBLISH CONFIGURATION
;; =================================================================

(setq org-publish-project-alist
      `(("website-content"
         :base-directory ,blog-root-dir
         :base-extension "org"
         :publishing-directory ,public_html-dir
         :publishing-function ,(if (featurep 'org-ref)
                                   'org-ref-html-publish-to-html
                                 'my-html-publish-to-html)
         :recursive t
         :with-author t
         :with-date t
         :with-latex t
         :html-mathjax nil
         :section-numbers nil
         :html-head-extra ,my-blog-html-head
         :html-head-include-default-style nil
         :html-head-include-scripts nil
         :html-preamble my-blog-header
         :html-postamble my-blog-footer
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Joseph Vidal-Rosset - Philosophy, Logic & Emacs"
         :sitemap-function my-blog-sitemap-with-updates
         :sitemap-sort-files anti-chronologically
         :exclude "drafts/.*"
         :language "en")

        ;; Note: Images, CSS, PDF are directly in public_html/ subdirectories
        ;; No need to "publish" them - they are already where they need to be
        ;; Only .org files from blog-root-dir are published to HTML

        ("website" :components ("website-content"))))

;; =================================================================
;; SITE MANAGEMENT FUNCTIONS
;; =================================================================

(defun stamp-all-updated-dates ()
  "Run `update-article-date-if-republishing' on every article BEFORE
section pages and the sitemap are generated, so that fresh #+UPDATED:
dates are visible to them.  Only articles actually modified since their
last publication are stamped (see that function's criterion)."
  (let ((org-files (directory-files blog-root-dir t "\\.org$")))
    (dolist (file org-files)
      (when (and (file-readable-p file)
                 (not (member (file-name-nondirectory file)
                              '("index.org" "arguments.org" "provers.org"
                                "code.org" "french.org" "jvr.org"))))
        (update-article-date-if-republishing file)))))

(defun publish-site ()
  "Publish the complete site with automatic section page regeneration"
  (interactive)
  (message "Stamping updated dates on modified articles...")
  (stamp-all-updated-dates)
  (message "Regenerating section pages...")
  (create-all-section-pages)
  (message "Publishing site...")
  (org-publish "website" t)
  (message "Site published successfully!"))

(defun complete-site-rebuild-and-publish ()
  "Complete site reconstruction and publication"
  (interactive)
  (condition-case err
      (progn
        (message "START - Complete site reconstruction...")
        (message "Stamping updated dates on modified articles...")
        (stamp-all-updated-dates)
        (message "Regenerating section pages...")
        (create-all-section-pages)
        (message "Publishing complete site...")
        (org-publish "website" t)
        (message "COMPLETED - Site completely regenerated and published!"))
    (error
     (message "ERROR during reconstruction: %s" err))))

(defun complete-site-rebuild-and-publish-verbose ()
  "Verbose version of complete reconstruction"
  (interactive)
  (condition-case err
      (progn
        (message "=== START COMPLETE RECONSTRUCTION ===")
        (message "STEP 1/5 : Stamping updated dates on modified articles...")
        (stamp-all-updated-dates)
        (message "STEP 2/5 : About page skipped (jvr.org is hand-edited)...")
        ;; (create-about-page)  NEUTRALISE : ecrasait jvr.org edite a la main
        (message "STEP 3/5 : Regenerating Arguments, Provers, Code, French pages...")
        (create-section-page "Arguments" "arg" "arguments.org")
        (create-section-page "Provers" "prov" "provers.org")
        (create-section-page "Code" "code" "code.org")
        (create-section-page "En français" "french" "french.org")
        (message "STEP 4/5 : Cleaning publication cache...")
        (org-publish-remove-all-timestamps)
        (message "STEP 5/5 : Complete site publication...")
        (org-publish "website" t)
        (message "=== RECONSTRUCTION COMPLETED SUCCESSFULLY ==="))
    (error
     (message "=== RECONSTRUCTION ERROR: %s ===" err))))

(defun regenerate-sections-and-publish ()
  "Regenerate section pages and publish site (alias for publish-site)"
  (interactive)
  (publish-site))

(defun check-article-tags ()
  "Check tags of all articles"
  (interactive)
  (let ((org-files (directory-files blog-root-dir t "\\.org$")))
    (dolist (file org-files)
      (when (and (file-readable-p file)
                 (not (string-match "index\\.org$" file)))
        (with-temp-buffer
          (insert-file-contents file)
          (goto-char (point-min))
          (if (re-search-forward "^#\\+TAGS:\\s-*\\(.*\\)$" nil t)
              (let ((tags (string-trim (match-string 1))))
                (message "✓ %s → TAG: '%s'" (file-name-nondirectory file) tags))
            (message "✗ %s → NO TAG" (file-name-nondirectory file))))))))

(defun debug-and-republish ()
  "Complete debug and republication"
  (interactive)
  (message "=== START DEBUG ===")
  (check-article-tags)
  (message "=== CREATING SECTION PAGES ===")
  (create-all-section-pages)
  (message "=== PUBLICATION ===")
  (publish-site)
  (message "=== END DEBUG ==="))

;; =================================================================
;; INITIALIZATION
;; =================================================================

(dolist (dir (list blog-root-dir public_html-dir public_html-csl-dir
                   public_html-css-dir public_html-images-dir public_html-pdf-dir
                   academic-pdf-dir))
  (unless (file-exists-p dir)
    (make-directory dir t)))

;; =================================================================
;; HELP MESSAGES
;; =================================================================

(message "Complete blog configuration loaded with intelligent LaTeX class selection")
(message "=== BLOG FUNCTIONS ===")
(message "  M-x new-org-file - Create any org file (blog: arg/code/prov/french, academic: aca)")
(message "  M-x publish-site - Quick publish")
(message "  M-x export-to-pdf - Smart export (detects math→SMF, simple→KOMA)")
(message "=== ACADEMIC FUNCTIONS ===")
(message "  M-x new-letter - Create letter with KOMA letter class")
(message "  M-x export-academic-pdf - Force SMF export")
(message "  M-x export-with-class - Manual class selection")
(message "  M-x export-article-authordate - Author-date PDF (natbib+BibTeX, bypasses org-ref)")
(message "  M-x export-article-authordate-tex - Same, .tex only")
(message "=== SITE MANAGEMENT ===")
(message "  M-x create-all-section-pages - Create section pages")
(message "  M-x complete-site-rebuild-and-publish - Full rebuild")
(message "  M-x debug-and-republish - Debug and republish")
(message "=== INTELLIGENT CLASS SELECTION ===")
(message "  Blog posts → KOMA (simple & universal)")
(message "  Math-heavy content → SMF (optimal typography)")
(message "  Letters → KOMA scrlttr2")
(message "  Presentations → Beamer")
(message "  General academic → KOMA or SMF (auto-detected)")
(message "  Available classes: xxllp, corporate-fr, asl, smfart-en, koma-article,")
(message "                     smfart-fr, svjour3, smfbook-fr, beamer-fr, beamer-en,")
(message "                     lettre-koma, org-article")
(message "=== JAR SUBMISSION FUNCTIONS ===")
(message "  M-x new-jar-paper - Create paper for Journal of Automated Reasoning")
(message "  Available Springer classes: sn-jnl, sn-jnl-basic, sn-jnl-nature,")
(message "                             sn-jnl-aps, sn-jnl-jar (with referee mode)")
(message "  Available classes: xxllp, corporate-fr, asl, smfart-en, koma-article,")
(message "                     smfart-fr, svjour3, smfbook-fr, beamer-fr, beamer-en,")
(message "                     lettre-koma, org-article,")
(message "                     sn-jnl, sn-jnl-jar, sn-jnl-basic, sn-jnl-nature, sn-jnl-aps")


;; =================================================================
;; GLOBAL TITLE RENAMING
;; =================================================================

(defvar jvr-title-old
  "A Triple Certified Proof that Core Logic is not Paraconsistent"
  "Former title of the article, to be replaced everywhere.")

(defvar jvr-title-new
  "Core Logic is not paraconsistent: one proof, six certifications"
  "Current title of the article.")

(defun jvr--loose-regexp (s)
  "Return a regexp matching S with any run of whitespace between words.
This makes the search immune to the line breaks introduced by filling."
  (mapconcat #'regexp-quote (split-string s "[ \t\n]+" t) "[ \t\n]+"))

(defun jvr--blog-org-files ()
  "Every Org source of the blog.  Generated HTML is never touched."
  (directory-files-recursively blog-root-dir "\\.org\\'"))

(defun jvr--file-matches-p (file re)
  "Non-nil when FILE contains RE, ignoring case."
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (let ((case-fold-search t))
      (re-search-forward re nil t))))

(defun jvr-blog-scan-title (text)
  "Report every occurrence of TEXT in the blog Org sources.
Case is ignored and line breaks are tolerated.  Each hit is shown as
it is actually written, so that spelling variants become visible."
  (interactive (list (read-string "Search for: " jvr-title-old)))
  (let ((re (jvr--loose-regexp text))
        (hits nil)
        (total 0))
    (dolist (f (jvr--blog-org-files))
      (with-temp-buffer
        (insert-file-contents f)
        (goto-char (point-min))
        (let ((case-fold-search t))
          (while (re-search-forward re nil t)
            (setq total (1+ total))
            (push (list (file-relative-name f blog-root-dir)
                        (line-number-at-pos (match-beginning 0))
                        (replace-regexp-in-string "[ \t\n]+" " "
                                                  (match-string 0)))
                  hits)))))
    (with-current-buffer (get-buffer-create "*blog title scan*")
      (erase-buffer)
      (insert (format "%d occurrence(s) of:\n  %s\n\n" total text))
      (dolist (h (nreverse hits))
        (insert (format "%s:%d: %s\n" (nth 0 h) (nth 1 h) (nth 2 h))))
      (goto-char (point-min))
      (display-buffer (current-buffer)))
    (message "%d occurrence(s) found." total)
    total))

(defun jvr-blog-replace-title (old new)
  "Replace OLD by NEW in every Org source of the blog.
Matching ignores case and tolerates line breaks.  Only the files that
actually contain OLD are visited, and they are saved on the spot."
  (interactive (list (read-string "Old title: " jvr-title-old)
                     (read-string "New title: " jvr-title-new)))
  (let ((re (jvr--loose-regexp old))
        (files 0)
        (total 0))
    (dolist (f (jvr--blog-org-files))
      (when (jvr--file-matches-p f re)
        (let ((buf (find-file-noselect f))
              (n 0))
          (with-current-buffer buf
            (save-excursion
              (goto-char (point-min))
              (let ((case-fold-search t))
                (while (re-search-forward re nil t)
                  (replace-match new t t)
                  (setq n (1+ n)))))
            (when (> n 0)
              (save-buffer)
              (setq files (1+ files))
              (setq total (+ total n)))))))
    (message "%d replacement(s) in %d file(s)." total files)))


(provide 'publish)

;;; publish.el ends here
