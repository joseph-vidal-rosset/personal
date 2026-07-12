;;; org-latex-fitch.el --- Fix org-latex-preview for wide Fitch proofs  -*- lexical-binding: t; -*-
;;; org-latex-fitch.el --- Fix org-latex-preview for wide Fitch proofs
;;; Place in ~/.emacs.d/personal/

(with-eval-after-load 'org
  (setq org-format-latex-header
        "\\documentclass[fleqn]{article}
\\usepackage[paperwidth=50cm,paperheight=100cm,margin=0.5cm]{geometry}
\\usepackage{amsmath,amssymb}
\\usepackage{fitch}
\\pagestyle{empty}"))
