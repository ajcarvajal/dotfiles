;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Aj Carvajal"
      user-mail-address "alanjcarv@gmail.com")

(setq doom-font (font-spec
                 :family "Inconsolata"
                 :size 20))

(after! evil
  (evil-global-set-key 'motion ":" 'evil-repeat-find-char)
  (evil-global-set-key 'motion ";" 'evil-ex)  ;; evil-snipe must be disabled
  (evil-global-set-key 'motion "-" 'dired-jump))

(setq doom-theme 'doom-sourcerer)
(setq org-directory "~/org/")  ;; must be set before org loads
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
