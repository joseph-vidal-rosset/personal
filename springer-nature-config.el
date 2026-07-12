;;; springer-nature-config.el --- Springer Nature journal class for Org-mode export -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2025 Joseph Vidal-Rosset

;; Configuration for exporting Org-mode documents to Springer Nature journal format
;; using the sn-jnl.cls class file

;;; Commentary:

;; This configuration adds the Springer Nature journal class (sn-jnl.cls)
;; to the available LaTeX export classes in org-mode.
;; 
;; The sn-jnl class is specifically designed for Springer Nature journals
;; and includes support for:
;; - Multiple reference styles (basic, mathphys, APS, Vancouver, APA, Chicago, Nature)
;; - Single or double column layouts
;; - Line numbering for referee mode
;; - Professional journal formatting
;;
;; USAGE:
;; In your org file, add:
;;   #+LATEX_CLASS: sn-jnl
;; Or use the tag "jar" to automatically select this class

;;; Code:

(require 'ox-latex)

;; Add Springer Nature journal class to org-latex-classes
(add-to-list 'org-latex-classes
             '("sn-jnl"
               "\\documentclass[sn-mathphys-num]{sn-jnl}
[DEFAULT-PACKAGES]
[PACKAGES]

% Recommended packages for Springer Nature journals
\\usepackage{graphicx}
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

% Theorem environments - using Springer Nature style
\\theoremstyle{plain}
\\newtheorem{theorem}{Theorem}[section]
\\newtheorem{lemma}[theorem]{Lemma}
\\newtheorem{proposition}[theorem]{Proposition}
\\newtheorem{corollary}[theorem]{Corollary}

\\theoremstyle{definition}
\\newtheorem{definition}[theorem]{Definition}
\\newtheorem{example}[theorem]{Example}
\\newtheorem{remark}[theorem]{Remark}
\\newtheorem{note}[theorem]{Note}

% Proof environment
\\renewenvironment{proof}[1][Proof]{\\par
  \\pushQED{\\qed}%
  \\normalfont \\topsep6\\p@\\@plus6\\p@\\relax
  \\trivlist
  \\item[\\hskip\\labelsep
        \\itshape
    #1\\@addpunct{.}]\\ignorespaces
}{%
  \\popQED\\endtrivlist\\@endpefalse
}

[EXTRA]
"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Springer Nature with Basic reference style
(add-to-list 'org-latex-classes
             '("sn-jnl-basic"
               "\\documentclass[sn-basic]{sn-jnl}
[DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{graphicx}
\\usepackage{amsmath,amssymb,amsfonts}
\\usepackage{amsthm}
[EXTRA]
"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Springer Nature with Nature reference style
(add-to-list 'org-latex-classes
             '("sn-jnl-nature"
               "\\documentclass[sn-nature]{sn-jnl}
[DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{graphicx}
\\usepackage{amsmath,amssymb,amsfonts}
\\usepackage{amsthm}
[EXTRA]
"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Springer Nature with APS reference style
(add-to-list 'org-latex-classes
             '("sn-jnl-aps"
               "\\documentclass[sn-aps]{sn-jnl}
[DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage{graphicx}
\\usepackage{amsmath,amssymb,amsfonts}
\\usepackage{amsthm}
[EXTRA]
"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Springer Nature for JAR - Referee mode with line numbers
(add-to-list 'org-latex-classes
             '("sn-jnl-jar"
               "\\documentclass[referee,lineno,sn-mathphys-num]{sn-jnl}
[DEFAULT-PACKAGES]
[PACKAGES]

% Packages for automated reasoning / logic papers
\\usepackage{graphicx}
\\usepackage{amsmath,amssymb,amsfonts}
\\usepackage{amsthm}
\\usepackage{mathrsfs}
\\usepackage{stmaryrd}
\\usepackage{proof}
\\usepackage{bussproofs}
\\usepackage[title]{appendix}
\\usepackage{xcolor}
\\usepackage{textcomp}
\\usepackage{booktabs}
\\usepackage{algorithm}
\\usepackage{algorithmicx}
\\usepackage{algpseudocode}
\\usepackage{listings}

% Theorem environments
\\theoremstyle{plain}
\\newtheorem{theorem}{Theorem}[section]
\\newtheorem{lemma}[theorem]{Lemma}
\\newtheorem{proposition}[theorem]{Proposition}
\\newtheorem{corollary}[theorem]{Corollary}

\\theoremstyle{definition}
\\newtheorem{definition}[theorem]{Definition}
\\newtheorem{example}[theorem]{Example}
\\newtheorem{remark}[theorem]{Remark}
\\newtheorem{note}[theorem]{Note}

% Proof environment
\\renewenvironment{proof}[1][Proof]{\\par
  \\pushQED{\\qed}%
  \\normalfont \\topsep6\\p@\\@plus6\\p@\\relax
  \\trivlist
  \\item[\\hskip\\labelsep
        \\itshape
    #1\\@addpunct{.}]\\ignorespaces
}{%
  \\popQED\\endtrivlist\\@endpefalse
}

% Sequent calculus commands
\\newcommand{\\seq}[2]{#1 \\vdash #2}
\\newcommand{\\seqempty}[1]{\\vdash #1}

[EXTRA]
"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(message "Springer Nature journal classes loaded: sn-jnl, sn-jnl-basic, sn-jnl-nature, sn-jnl-aps, sn-jnl-jar")

(provide 'springer-nature-config)

;;; springer-nature-config.el ends here
