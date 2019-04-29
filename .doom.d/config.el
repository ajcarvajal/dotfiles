;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
(setq doom-font (font-spec :family "Source Code Pro" :size 16))



;; syntax highlighting in org mode code snippets
(with-eval-after-load 'org
  (setq org-agenda-files '("~/org"))
	(require 'ox-latex)
	(add-to-list 'org-latex-packages-alist '("" "minted"))
	(setq org-latex-listings 'minted)

	(setq org-latex-pdf-process
				'("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
					"pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
					"pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

	(setq org-src-fontify-natively t)

	(org-babel-do-load-languages
	 'org-babel-load-languages
	 '((R . t)
		 (latex . t))))
