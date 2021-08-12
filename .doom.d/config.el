;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

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

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "AJ Carvajal"
      user-mail-address "alanjcarv@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-opera)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

; Disable company completion in org-mode
(use-package! company
  :config (setq company-global-modes '(not org-mode)))

;; Set the default browser for WSL
(defun my--browse-url (url &optional _new-window)
;; new-window ignored
"Opens link via powershell.exe"
(interactive (browse-url-interactive-arg "URL: "))
(let ((quotedUrl (format "start '%s'" url)))
(apply 'call-process "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe" nil
0 nil
(list "-Command" quotedUrl))))

(setq-default browse-url-browser-function 'my--browse-url)


(defun aj-org-paste-image ()
  "Paste an image into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (let* ((target-file
          (concat
           (make-temp-name
            (concat (buffer-file-name)
                    "_"
                    (format-time-string "%Y%m%d_%H%M%S_")))
           ".png"))
         (wsl-path
          (concat (as-windows-path(file-name-directory target-file))
                  "\\"
                  (file-name-nondirectory target-file)))
         (ps-script
          (concat "(Get-Clipboard -Format image).Save('" wsl-path "')")))

    (powershell ps-script)

    (if (file-exists-p target-file)
        (progn (insert (concat "[[" target-file "]]"))
               (org-display-inline-images))
      (user-error
       "Error pasting the image, make sure you have an image in the clipboard!"))
    ))

(defun as-windows-path (unix-path)
  "Takes a unix path and returns a matching WSL path"
  ;; substring removes the trailing \n
  (substring
   (shell-command-to-string
    (concat "wslpath -w " unix-path)) 0 -1))

(defun powershell (script)
  "executes the given script within a powershell and returns its return value"
  (call-process "powershell.exe" nil nil nil
                "-Command" (concat "& {" script "}")))


(evil-define-operator wsl-copy (start end type register yank-handler)
  :move-point nil
  :repeat nil
  (interactive "<R><x><y>")
  (shell-command-on-region start end "clip.exe")
  (deactivate-mark))

(defun wsl-paste ()
  (interactive)
  (let ((clipboard
     (shell-command-to-string "powershell.exe -command 'Get-Clipboard' 2> /dev/null")))
    (setq clipboard (replace-regexp-in-string "\r" "" clipboard)) ; Remove Windows ^M characters
    (setq clipboard (substring clipboard 0 -1)) ; Remove newline added by Powershell
    (insert clipboard)))

(defun aj-org-home ()
  (interactive)
  (find-file "~/org/home.org"))

(map! :desc "Copies to Windows clipboard" "M-y" #'wsl-copy)
(map! :desc "Pastes from windows clipboard" "M-p" #'wsl-paste)
(map! :leader :desc "Open org home" "f o" #'aj-org-home)

(setq initial-buffer-choice "~/org/home.org")
