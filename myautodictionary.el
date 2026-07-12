;;; spell-checking.el --- auto-dictionary            -*- lexical-binding: t; -*-
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2020  Joseph Vidal-Rosset

;; Author: Joseph Vidal-Rosset <joseph.vidal.rosset@gmail.com>
;; Keywords: abbrev, help

;; auto-dictionary  uncomment all what follows 
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(require 'auto-dictionary)
(add-hook 'flyspell-mode-hook (lambda () (auto-dictionary-mode 1)))



(provide 'spell-checking)
;;; spell-checking.el ends here
