;;; -*- lexical-binding:  t -*-
(TeX-add-style-hook
 "svjour3"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("natbib" "numbers" "sort&compress")))
   (add-to-list 'LaTeX-verbatim-environments-local "lstlisting")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "lstinline")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "lstinline")
   (TeX-run-style-hooks
    "latex2e"
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
    "bussproofs"
    "proof"
    "listings"
    "longtable"
    "natbib")
   (LaTeX-add-labels
    "sec:org1f12002"
    "sec:org112e8a3"
    "sec:orge799fb3"
    "sec:orge002199"
    "sec:org0054721"
    "sec:org5ca073a")
   (LaTeX-add-bibliographies
    "../reforg"))
 :latex)

