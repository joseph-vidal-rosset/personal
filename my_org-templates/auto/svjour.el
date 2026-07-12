;;; -*- lexical-binding:  t -*-
(TeX-add-style-hook
 "svjour"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("natbib" "numbers" "sort&compress") ("hyperref" "linktocpage" "pdfstartview=FitH" "colorlinks" "linkcolor=blue" "anchorcolor=blue" "citecolor=blue" "filecolor=blue" "menucolor=blue" "urlcolor=blue")))
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "svjour3"
    "svjour310"
    "hyperref"
    "inputenc"
    "fixltx2e"
    "url"
    "graphicx"
    "color"
    "amsmath"
    "textcomp"
    "marvosym"
    "wasysym"
    "latexsym"
    "amssymb"
    "listings"
    "longtable"
    "natbib")
   (LaTeX-add-labels
    "sec:org0e29b45"
    "sec:org2e22f28"
    "sec:orgf384698"
    "eq:balance"
    "sec:org850d84f"
    "sec:org711284a"
    "sec:org72b0728"
    "sec:orgeb17f9b"
    "sec:orgc238097"
    "sec:org3b8de96")
   (LaTeX-add-bibliographies
    "references"))
 :latex)

