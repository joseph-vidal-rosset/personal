;;; org-export.el --- org-export settings            -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2020  Joseph Vidal-Rosset

;; Author: Joseph Vidal-Rosset <joseph.vidal.rosset@gmail.com>
;; Keywords: files

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

;; in this file org-export settings
(require 'org)
(require 'ox-latex)
;(require 'org-ref)
;;; Code:
;; bibliography - notes - etc.
(setq reftex-default-bibliography '("~/Dropbox/tex/references.bib"))
;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "~/Dropbox/tex/notes.org"
      org-ref-default-bibliography '("~/Dropbox/tex/references.bib")
      org-ref-pdf-directory "~/MEGA/Documents/")
;(setq helm-bibtex-bibliography "~/Dropbox/tex/references.bib")
(setq bibtex-completion-bibliography "~/Dropbox/tex/references.bib")
;(setq helm-bibtex-library-path "~/Dropbox/tex/")
(setq bibtex-completion-library-path "~/Dropbox/tex/")

(setq bibtex-completion-bibliography "~/Dropbox/tex/references.bib"
      bibtex-completion-library-path "~/Dropbox/tex"
      bibtex-completion-notes-path "~/Dropbox/tex")


(defun cite-with-pages (key page)
  (interactive
   (list
    (car (reftex-citation t))
    (read-from-minibuffer "page: ")))
  (insert (format "[[cite:%s][page %s]]" key page)))

;; make sure `org-auctex-key-bindings.el' is in your `load-path'
(add-to-list 'load-path "~/.emacs.d/core/org-auctex-keys")

;;* Export settings
(setq org-latex-default-packages-alist
      '(("AUTO" "inputenc" t)
	;;("english,francais" "babel" t)
	("" "siunitx" nil)
	("" "lmodern" nil)
	("T1" "fontenc" t)
	("" "natbib" t)
	("" "graphicx" t)
	("" "etex" t)
	("" "xcolor" t)
	("normalem" "ulem" t)
	("" "textcomp" t)
	("" "marvosym" t)
	("" "wasysym" t)
	("" "amssymb" t)
	("" "amsmath" t)
	("" "amsthm" t)
	("" "qtree" t)
	("" "bussproofs" t)
	("" "proof" t)
	("" "cancel" t)
	("" "url" t)
	("" "pdflscape" t)
	;("" "fontawesome" t)
	("" "tikz" t)
	("" "enumerate" t)
	("" "epigraph" t)
					;("" "fourier" t)
					;("" "smfenum" t)
					;("" "smfthm" t)
        ("linktocpage,pdfstartview=FitH,colorlinks,linkcolor=blue,anchorcolor=blue,citecolor=blue,filecolor=blue,menucolor=blue,urlcolor=blue" "hyperref" nil)
	)
      )

;(setq org-latex-inputenc-alist '(("utf8" . "utf8x")))
(setq org-latex-packages-alist
      '(("utf8" "inputenc" t)
	("" "siunitx" nil)
	("" "natbib" t)
	("" "lmodern" nil)
	("T1" "fontenc" t)
	("" "graphicx" t)
	("" "etex" t)
	("" "xcolor" t)
	("normalem" "ulem" t)
	("" "textcomp" t)
	("" "pdflscape" t)
	("" "marvosym" t)
	("" "amssymb" t)
	("" "amsmath" t)
	("" "amsthm" t)
	("" "qtree" t)
	("" "bussproofs" t)
	("" "proof" t)
        ("" "fitch" t)
	("" "cancel" t)
	("" "url" t)
	("" "tikz" t)
	("" "enumerate" t)
	("" "epigraph" t)
	)
      )
;; do not put in \hypersetup use your own
;; \hypersetup{pdfkeywords={%s},\n pdfsubject={%s},\n pdfcreator={%s}
(setq org-latex-hyperref-template nil)

;; this is for code syntax highlighting in export
(setq org-latex-listings 'minted)
(setq org-latex-minted-options
      '(("frame" "lines")
        ("fontsize" "\\scriptsize")
        ("linenos" "")))

;; for minted you must run latex with -shell-escape because it calls pygmentize as an external program
(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %b"
        "bibtex %b"
        "makeindex %b"
	"pdflatex -shell-escape -interaction nonstopmode -output-directory %o %b"
	"pdflatex -shell-escape -interaction nonstopmode -output-directory %o %b"))

(add-to-list 'org-latex-classes
               '("xxllp"
               "\\documentclass\[oumk,xs]\{xxllp\}
 [NO-DEFAULT-PACKAGES]
 [NO-PACKAGES]
\\usepackage{amsmath}
\\usepackage{amssymb}
\\usepackage{stmaryrd}
\\usepackage{amsfonts}
\\usepackage[mathscr]{euscript}
\\usepackage\[TS1,T1]\{fontenc\}
\\usepackage{xlmodern}
\\usepackage{xxllp}
\\usepackage{LLPthm}
\\usepackage{enumerate}
\\usepackage{lscape}
\\usepackage[numbers]{natbib}
\\usepackage{proof}
\\usepackage{bussproofs}
\\usepackage{fitch}
\\usepackage{fancyvrb}
\\usepackage{verbatim}
\\usepackage[shortlabels]{enumitem}
\\usepackage[hyphens]{url}
\\usepackage\[breaklinks,colorlinks,citecolor=blue,urlcolor=blue]\{hyperref\}
\\usepackage[hyphenbreaks]\{breakurl\}
\\usepackage{doi}
\\newcommand{\\MGTT}{\\text{\\textnormal{MGTT}}}
\\newcommand{\\Formuly}{\\text{\\textnormal{Form}}}
\\newtheorem{theorem}{Theorem}[section]
\\newtheorem{lemma}{Lemma}[section]
\\newtheorem{coro}{Corollary}[section]
\\newtheorem{proposition}{Proposition}[section]
\\newtheorem{question}{Question}[section]
\\theoremstyle{definition}
\\newtheorem{defn}{Definition}[section]
\\newtheorem{pb}{Problem}[section]
\\newtheorem{rema}{Remark}[section]
\\newtheorem{exem}{Example}[section]
\\setcounter{pubyear}{2018}
\\renewcommand{\\pubonline}{??, 2018}
\\newcommand*{\\mies}{September}
\\setcounter{dzien}{1}
\\setcounter{rok}{2016}
\\newcommand*{\\rmies}{March}
\\setcounter{rdzien}{31}
\\setcounter{rrok}{2018}
\\renewcommand\\figurename{\\small Figure}
\\renewcommand\\tablename{\\small Table}
\\newcommand{\\coloneqq}{\\mathrel{\\mathord{:}\mathord{=}}}
"
	       ("\\section{%s}" . "\\section*{%s}")
	       ("\\subsection{%s}" . "\\subsection*{%s}")
	       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	       ("\\paragraph{%s}" . "\\paragraph*{%s}")
	       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("corporate-fr"
               "\\documentclass\[a4paper,american,frenchb]\{article\}
 \\usepackage[blackLinks=false, logo = false]{corporate}
 [NO-DEFAULT-PACKAGES]
 [PACKAGES]
\\usepackage{hyperref}
\\hypersetup{colorlinks=true, breaklinks=true, citecolor=blue, linkcolor=blue, menucolor=blue, urlcolor=blue}
               \\author\{Joseph Vidal-Rosset\}
	      \\bibliography{/home/joseph/MEGA/org/references}"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))


(add-to-list 'org-latex-classes
             '("asl"
               "\\documentclass\[reqno]\{asl\}
[DEFAULT-PACKAGES]
[NO-PACKAGES]
[NO-EXTRA]
\\newtheorem{Theorem}{Theorem}[section]
\\newtheorem{Corollary}[Theorem]{Corollary}
\\newtheorem{Lemma}[Theorem]{Lemma}
\\newtheorem{question}[Theorem]{Question}
\\renewcommand{\\qed}{\\hfill\\(\\square\\)}
\\newcommand{\\qedwhite}{\\hfill \\ensuremath{\\(\\Box\\)}}
\\theoremstyle{definition}
\\newtheorem{Proposition}[Theorem]{Proposition}
\\newtheorem{remark}[Theorem]{Remark}
\\newtheorem{definition}[Theorem]{Definition}
\\newtheorem{Conjecture}[Theorem]{Conjecture}
\\newtheorem{example}[Theorem]{Example}
\\newtheorem{statement}[Theorem]{Statement}
              \\author\{Joseph Vidal-Rosset\}
	       \\address\{Universit\\'e de Lorraine, D\\'epartement de philosophie, Archives Poincar\\'e, UMR 7117 du CNRS, 91 bd Lib\\'eration, 54000 Nancy, France\}
               \\email\{joseph.vidal-rosset@univ-lorraine.fr\}"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

;(add-to-list 'org-latex-exam
;             '("documentclass"
;               "\\classes\[12pt,addpoints,answers]\{exam\}
;[DEFAULT-PACKAGES]
;[NO-PACKAGES]
;[NO-EXTRA]
; "))

(add-to-list 'org-latex-classes
             '("smfart-fr"
               "\\documentclass\[article,reqno,times,12pt,francais]\{smfart\}
                \\usepackage[francais,english]{babel}
                \\usepackage{smfenum}
                \\theoremstyle{plain}% default
                 \\newtheorem{theo}{Theorem}
                 \\newtheorem{lemm}[theo]{Lemme}
                 \\newtheorem{prop}{Proposition}
                  \\newtheorem{coro}{Corollaire}
                  \\newtheorem*{corol}{Corollaire}
                  \\theoremstyle{definition}
                  \\newtheorem{defi}{Définition}
                  \\newtheorem{conj}{Conjecture}
                   \\newtheorem{exem}{Exemple}
                  \\newtheorem{sco}{Scolie}
                  \\newtheorem*{scol}{Scolie}
                  \\usepackage[square,numbers]{natbib}
 [NO-DEFAULT-PACKAGES]
 [PACKAGES]
\\usepackage{hyperref}
\\hypersetup{colorlinks=true, breaklinks=true, citecolor=blue, linkcolor=blue, menucolor=blue, urlcolor=blue}
               \\author\{Joseph Vidal-Rosset\}
	       \\address\{Universit\\'e de Lorraine, D\\'epartement de philosophie,\}
                \\address\{Archives Poincar\\'e, UMR 7117 du CNRS,\}
                 \\address\{ 91 bd Lib\\'eration, 54000 Nancy, France.\}
               \\email\{joseph.vidal-rosset@univ-lorraine.fr\}"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

(add-to-list 'org-latex-classes
             '("smfart-en"
               "\\documentclass[article,english,reqno,times,12pt]{smfart}
                \\usepackage{smfenum}
                \\usepackage{smfthm}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{hyperref}
\\usepackage{amsmath,varwidth,bussproofs}
\\newenvironment{mathprooftree}
  {\\varwidth{0.9\\textwidth}\\centering\\leavevmode}
  {\\DisplayProof\\endvarwidth}
\\hypersetup{colorlinks=true, breaklinks=true, citecolor=blue, linkcolor=blue, menucolor=blue, urlcolor=blue}
              \\author{Joseph Vidal-Rosset}
	       \\address{Université de Lorraine, Département de philosophie, Archives Poincaré, UMR 7117 du CNRS, 91 bd Libération, 54000 Nancy, France}
               \\email{joseph.vidal-rosset@univ-lorraine.fr}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))


(add-to-list 'org-latex-classes
             '("beamer-fr"
               "\\documentclass\[10pt,svgnames,fragile]\{beamer\}
\\usepackage[english,frenchb]{babel}
                [NO-DEFAULT-PACKAGES]
                [PACKAGES]
                [NO-EXTRA]
\\theoremstyle{plain}% default
\\newtheorem{thm}{Theorem}[section]
\\newtheorem{theo}{Théorème}[section]
\\newtheorem{lem}[thm]{Lemma}
\\newtheorem{prop}[thm]{Proposition}
\\newtheorem*{cor}{Corollary}
\\theoremstyle{definition}
\\newtheorem{defi}{Définition}[section]
\\newtheorem{rema}[thm]{Remarque}
\\newtheorem{Conjecture}[theorem]{Conjecture}
\\newtheorem{conj}[theorem]{Conjecture}
\\newtheorem{exa}{Example}[section]
\\newtheorem{exem}{Exemple}[section]
\\\hypersetup{colorlinks,
citecolor=blue,
linkcolor=.,
menucolor=white,
filecolor=pink,
anchorcolor=yellow
}
\\AtBeginSection\[\]\{\\begin\{frame\}<beamer>\\frametitle\{\}\\tableofcontents\[currentsection,hideothersubsections\]\\end\{frame\}\}
\\subtitle\{\}
\\institute\[Université de Lorraine\]\{Département de philosophie \\\\ Archives Henri Poincaré - UMR 7117 du CNRS \\\\ Université de Lorraine \\\\ 91 bd Libération, 54000 Nancy \\\\ France \}
\\titlegraphic\{\\includegraphics\[height=1cm\]\{ahp\}\\includegraphics\[height=1cm\]\{udl\}\\includegraphics\[height=1cm\]\{cnrs\}\}
\\usetheme\{CambridgeUS\}
\\usepackage\{beamer_udl_theme\}
\\setbeamertemplate\{navigation symbols\}{%
	%insertslidenavigationsymbol%
	%insertframenavigationsymbol%
	%insertsubsectionnavigationsymbol%
	%insertsectionnavigationsymbol%
	%insertdocnavigationsymbol%
	%insertbackfindforwardnavigationsymbol%
}
\\setbeamertemplate{theorems}[numbered]
"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

(add-to-list 'org-latex-classes
             '("beamer-en"
               "\\documentclass\[10pt,svgnames,fragile]\{beamer\}
\\usepackage[english]{babel}
                [NO-DEFAULT-PACKAGES]
                [PACKAGES]
                [NO-EXTRA]
\\theoremstyle{plain}% default
\\newtheorem{thm}{Theorem}[section]
\\newtheorem{theo}{Théorème}[section]
\\newtheorem{lem}[thm]{Lemma}
\\newtheorem{prop}[thm]{Proposition}
\\newtheorem*{cor}{Corollary}
\\theoremstyle{definition}
\\newtheorem{defi}{Definition}[section]
\\newtheorem{rema}[thm]{Remarque}
\\newtheorem{Conjecture}[theorem]{Conjecture}
\\newtheorem{exa}{Example}[section]
\\newtheorem{exem}{Exemple}[section]
\\\hypersetup{colorlinks,
citecolor=blue,
linkcolor=.,
menucolor=white,
filecolor=pink,
anchorcolor=yellow
}
\\AtBeginSection\[\]\{\\begin\{frame\}<beamer>\\frametitle\{\}\\tableofcontents\[currentsection,hideothersubsections\]\\end\{frame\}\}
\\subtitle\{\}
\\institute\[Université de Lorraine\]\{Département de philosophie \\\\ Archives Henri Poincaré - UMR 7117 du CNRS \\\\ Université de Lorraine \\\\ 91 bd Libération, 54000 Nancy \\\\ France \}
\\titlegraphic\{\\includegraphics\[height=1cm\]\{ahp\}\\includegraphics\[height=1cm\]\{udl\}\\includegraphics\[height=1cm\]\{cnrs\}\}
\\usetheme\{CambridgeUS\}
\\usepackage\{beamer_udl_theme\}
\\setbeamertemplate\{navigation symbols\}{%
	%insertslidenavigationsymbol%
	%insertframenavigationsymbol%
	%insertsubsectionnavigationsymbol%
	%insertsectionnavigationsymbol%
	%insertdocnavigationsymbol%
	%insertbackfindforwardnavigationsymbol%
}
\\setbeamertemplate{theorems}[numbered]
"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

(eval-after-load "ox-latex"
  '(add-to-list 'org-latex-classes
                '("koma-article" "\\documentclass{scrartcl}"
                  ("\\section{%s}" . "\\section*{%s}")
                  ("\\subsection{%s}" . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph{%s}" . "\\paragraph*{%s}")
                  ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(eval-after-load "ox-latex"
  '(add-to-list 'org-latex-classes
                '("org-article" "\\documentclass{org-article}
                 [NO-DEFAULT-PACKAGES]
                 [PACKAGES]
                 [EXTRA]
                    \\author\{Joseph Vidal-Rosset\}
		  \\usepackage{hyperref}
\\usepackage{amsmath,varwidth,bussproofs}
\\newenvironment{mathprooftree}
  {\\varwidth{0.9\\textwidth}\\centering\\leavevmode}
  {\\DisplayProof\\endvarwidth}
\\hypersetup{colorlinks=true, breaklinks=true, citecolor=blue, linkcolor=blue, menucolor=blue, urlcolor=blue}"
                  ("\\section{%s}" . "\\section*{%s}")
                  ("\\subsection{%s}" . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph{%s}" . "\\paragraph*{%s}")
                  ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))




;;;;;;email : j'exporte avec l'adresse gmail
(setq user-mail-address "joseph@vidal-rosset.net")
(setq org-export-with-email nil)
(setq org-export-with-author nil)
(setq org-export-default-language "fr")
(setq org-export-with-smart-quotes 't)
; (require 'autopair)

;;; produce beautiful letters using the Org-mode LaTeX exporter and the KOMA-Script scrlttr2 letter class.

;(add-to-list 'load-path "~/git/org-mode/contrib/lisp/" t)
;(require ox-koma-letter)
;(add-to-list 'org-latex-classes
;             '("my-letter"
;               "\\documentclass\{scrlttr2\}
;\\usepackage[english]{babel}
;\[NO-DEFAULT-PACKAGES]
;\[NO-PACKAGES]
					; \[EXTRA]"))


;(require 'ox-koma-letter)
;(eval-after-load 'ox '(require 'ox-koma-letter))
     (add-to-list 'org-latex-classes
                  '("lettre-koma"
		    "\\documentclass\[symbolicnames,firstfoot=false,paper=a4, colorlinks=true, pagenumber=true,parskip=half,foldmarks=false,addrfield=true,french,bibliography]\{scrlttr2\}
\\makeatletter
\\newenvironment{thebibliography}[1]
     {\\list{\\@biblabel{\\@arabic\\c@enumiv}}%
           {\\settowidth\\labelwidth{\\@biblabel{#1}}%
            \\leftmargin\\labelwidth
            \\advance\\leftmargin\\labelsep
            \\usecounter{enumiv}
            \\let\\p@enumiv\\@empty
            \\renewcommand\\theenumiv{\\@arabic\\c@enumiv}}%
      \\sloppy
      \\clubpenalty4000
      \\@clubpenalty \\clubpenalty
      \\widowpenalty4000%
      \\sfcode`\\.\\@m}
     {\\def\\@noitemerr
       {\\@latex@warning{Empty `thebibliography' environment}}%
      \\endlist}
\\newcommand\\newblock{\\hskip .11em\\@plus.33em\\@minus.07em}
\\makeatother
\\usepackage\[numbers]\{natbib\}
\\let\\bibsection\\relax
     \\usepackage[english,frenchb]{babel}
\\usepackage{hyperref}
\\hypersetup{colorlinks=true, breaklinks=true, citecolor=blue, linkcolor=blue, menucolor=blue, urlcolor=blue}
\\usepackage[T1]{fontenc}
\\usepackage[utf8]{inputenc}
\\usepackage{graphicx}
\\usepackage{newcent}
\\usepackage{palatino}
\\usepackage{marvosym}
\\usepackage{blindtext}
\\usepackage{xcolor}
\\usepackage{hyperref}
\\hypersetup{colorlinks=true,breaklinks=true, citecolor=blue,linkcolor=blue, menucolor=blue, urlcolor=blue}
\\newcommand\{\\mailto\}\[1]\{\\href{mailto:#1\}\{#1}\}
\\LoadLetterOption{NF}
\\KOMAoptions{fromphone=true,fromemail=true,fromurl=true,backaddress=false,subject=beforeopening,fromrule=afteraddress}
\\KOMAoptions{enlargefirstpage}
     \[NO-DEFAULT-PACKAGES]
     \[NO-PACKAGES]"
		    ("\\section{%s}" . "\\section*{%s}")
        ("\\subsection{%s}" . "\\subsection*{%s}")
        ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
        ("\\paragraph{%s}" . "\\paragraph*{%s}")
        ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
     	    ))
(setq org-koma-letter-default-class "lettre-koma")

(setq koma-article-class
      '("koma-article" "\\documentclass[12pt]{scrartcl}
\\usepackage[symbolicnames,firstfoot=false,paper=a4, colorlinks=true, pagenumber=true,parskip=half,foldmarks=false,addrfield=true,french,bibliography]{scrletter}
\\makeatletter
\\newenvironment{thebibliography}[1]
     {\\list{\\@biblabel{\\@arabic\\c@enumiv}}%
           {\\settowidth\\labelwidth{\\@biblabel{#1}}%
            \\leftmargin\\labelwidth
            \\advance\\leftmargin\\labelsep
            \\usecounter{enumiv}
            \\let\\p@enumiv\\@empty
            \\renewcommand\\theenumiv{\\@arabic\\c@enumiv}}%
      \\sloppy
      \\clubpenalty4000
      \\@clubpenalty \\clubpenalty
      \\widowpenalty4000%
      \\sfcode`\\.\\@m}
     {\\def\\@noitemerr
       {\\@latex@warning{Empty `thebibliography' environment}}%
      \\endlist}
\\newcommand\\newblock{\\hskip .11em\\@plus.33em\\@minus.07em}
\\makeatother
  \\usepackage[english,frenchb]{babel}
\\usepackage{hyperref}
\\hypersetup{colorlinks=true, breaklinks=true, citecolor=blue, linkcolor=blue, menucolor=blue, urlcolor=blue}
\\usepackage[T1]{fontenc}
\\usepackage[utf8]{inputenc}
\\usepackage{graphicx}
\\usepackage{newcent}
\\usepackage{palatino}
\\usepackage{marvosym}
\\usepackage{blindtext}
\\usepackage{xcolor}
\\usepackage{hyperref}
\\hypersetup{colorlinks=true,breaklinks=true, citecolor=blue,linkcolor=blue, menucolor=blue, urlcolor=blue}
\\newcommand\{\\mailto\}\[1]\{\\href{mailto:#1\}\{#1}\}
\\LoadLetterOption{NF}
\\KOMAoptions{fromphone=true,fromemail=true,fromurl=true,backaddress=false,subject=beforeopening,fromrule=afteraddress}
\\KOMAoptions{enlargefirstpage}
     \[NO-DEFAULT-PACKAGES]
     \[NO-PACKAGES]"
        ("\\section{%s}" . "\\section*{%s}")
        ("\\subsection{%s}" . "\\subsection*{%s}")
        ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
        ("\\paragraph{%s}" . "\\paragraph*{%s}")
        ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(eval-after-load "ox-latex"
  '(add-to-list 'org-latex-classes
                '("koma-article" "\\documentclass{scrartcl}"
                  ("\\section{%s}" . "\\section*{%s}")
                  ("\\subsection{%s}" . "\\subsection*{%s}")
                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                  ("\\paragraph{%s}" . "\\paragraph*{%s}")
                  ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(progn
    (require 'ox-latex)
    (add-to-list 'org-latex-classes koma-article-class t))



;; autoinsert
(require 'autoinsert)
(auto-insert-mode)  ;;; Adds hook to find-files-hook
    (setq auto-insert-directory "~/.emacs.d/personal/my_org-templates/") ;;; Or use custom, *NOTE* Trailing slash important
(setq auto-insert-query nil) ;;; If you don't want to be prompted before insertion
(define-auto-insert "\.beamer-fr.org" "beamer-fr.org")
(define-auto-insert "\.beamer-en.org" "beamer-en.org")
(define-auto-insert "\.smfart-en.org" "smfart-en.org")
(define-auto-insert "\.smfart-fr.org" "smfart-fr.org")
(define-auto-insert "\.svjour3.org" "svjour3.org")
(define-auto-insert "\.wiley-thought.org" "wiley-thought.org")
(define-auto-insert "\.xxllp.org" "xxllp.org")
(define-auto-insert "\.lettre.org" "lettre.org")


;(add-to-list 'load-path ".")

;(require 'org-ref)
;(require 'citeproc)
;(require 'citeproc-org)



;(require 'ox-bibtex)
;(require citeproc)

;(add-to-list 'load-path ".")
;(require org-ref-citeproc)

;(when (file-exists-p "readme.html") (delete-file "readme.html"))
;(let ((org-export-before-parsing-hook '(orcp-citeproc)))
;(browse-url (org-html-export-to-html)))

;(add-to-list 'load-path ".")
;(require org-ref-citeproc)

;(let ((org-export-before-parsing-hook '(orcp-citeproc)))
;(org-open-file (org-org-export-to-org)))
;(require citeproc)
;(require citeproc-org)
;(citeproc-org-setup)
;(setq citeproc-org-html-bib-header "<h2>References</h2>\n")
;(setq citeproc-org-default-style-file "~/.emacs.d/personal/oil-shale.csl")


;(require 'org-ref-citeproc)
;(require 'unsrt)

(defun org-repair-export-blocks ()
  "Repair export blocks and INCLUDE keywords in current buffer."
  (when (eq major-mode 'org-mode)
    (let ((case-fold-search t)
          (back-end-re (regexp-opt
                        '("HTML" "ASCII" "LATEX" "ODT" "MARKDOWN" "MD" "ORG"
                          "MAN" "BEAMER" "TEXINFO" "GROFF" "KOMA-LETTER")
                        t)))
      (org-with-wide-buffer
       (goto-char (point-min))
       (let ((block-re (concat "^[ \t]*#\\+BEGIN_" back-end-re)))
         (save-excursion
           (while (re-search-forward block-re nil t)
             (let ((element (save-match-data (org-element-at-point))))
               (when (eq (org-element-type element) 'special-block)
                 (save-excursion
                   (goto-char (org-element-property :end element))
                   (save-match-data (search-backward "_"))
                   (forward-char)
                   (insert "EXPORT")
                   (delete-region (point) (line-end-position)))
                 (replace-match "EXPORT \\1" nil nil nil 1))))))
       (let ((include-re
              (format "^[ \t]*#\\+INCLUDE: .*?%s[ \t]*$" back-end-re)))
         (while (re-search-forward include-re nil t)
           (let ((element (save-match-data (org-element-at-point))))
             (when (and (eq (org-element-type element) 'keyword)
                        (string= (org-element-property :key element) "INCLUDE"))
               (replace-match "EXPORT \\1" nil nil nil 1)))))))))
(with-eval-after-load 'org
  (add-to-list 'org-mode-hook 'org-repair-export-blocks))

(setq org-preview-latex-default-process 'dvipng)

; (setq org-preview-latex-default-process 'imagemagick)

(setq org-html-htmlize-output-type 'css)


(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; LateX begin end   fontify latex embedded fragments

(defun my-org-extend-region (beg end) ;;(beg end old-len)
  (let ((begin-re "[\t ]*\\(#\\+BEGIN\\|\\\\begin{\\)")
        (end-re "[\t ]*\\(#\\+END\\|\\\\end{\\)"))
    (save-excursion
      (goto-char beg)
      (beginning-of-line)
      (if (looking-at end-re)
          (setq beg (or (re-search-backward begin-re nil t) beg))
        (when (looking-at begin-re)
          (setq end (or (re-search-forward end-re nil t) end))))))
  (cons beg end))



(setq org-link-search-must-match-exact-headline nil)


(add-to-list 'org-latex-classes
             '("springer-jar"
               "\\documentclass[referee,pdflatex,sn-mathphys-num]{sn-jnl}
\\usepackage{graphicx}
\\usepackage{multirow}
\\usepackage{amsmath,amssymb,amsfonts}
\\usepackage{amsthm}
\\usepackage{mathrsfs}
\\usepackage[title]{appendix}
\\usepackage{xcolor}
\\usepackage{textcomp}
\\usepackage{manyfoot}
\\usepackage{booktabs}
\\usepackage{algorithm}
\\usepackage{algorithmicx}
\\usepackage{algpseudocode}
\\usepackage{listings}
\\theoremstyle{thmstyleone}
\\newtheorem{theorem}{Theorem}
\\newtheorem{proposition}[theorem]{Proposition}
\\theoremstyle{thmstyletwo}
\\newtheorem{example}{Example}
\\newtheorem{remark}{Remark}
\\theoremstyle{thmstylethree}
\\newtheorem{definition}{Definition}
\\raggedbottom
[NO-DEFAULT-PACKAGES]
[PACKAGES]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))


(provide 'org-export)
;;; org-export.el ends here
