;; Load settings from org
;; (org-babel-load-file
;;  (expand-file-name "settings.org"
;;                    user-emacs-directory))
;;;Code:
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package)
  )
(setq use-package-always-ensure t)
(setq make-backup-files nil)


;; Directory tree
(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle)
  )
;;Auto resize windows
(use-package zoom
  :config
  (zoom-mode)
  (setq zoom-size '(0.618 . 0.8))

  )
;; Dashboard
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  )
;; Dim other panels when not used
(use-package dimmer
  :config
  ;;  (dimmer-mode +1)
  (dimmer-configure-helm)
  (dimmer-configure-which-key)
  ;; (dimmer-fraction 0.6)
  )
;; Centaur tabs
(use-package centaur-tabs
  :init
  (centaur-tabs-mode +1)
  (global-set-key (kbd "C-x <left>")  'centaur-tabs-backward)
  (global-set-key (kbd "C-x <right>") 'centaur-tabs-forward)
  (centaur-tabs-headline-match)
  (centaur-tabs-group-by-projectile-project)
  :config
  (setq centaur-tabs-style "wave")
  (setq centaur-tabs-set-icons t)
  )

(use-package smart-mode-line
  :init
  (use-package smart-mode-line-atom-one-dark-theme
    :config


    )
  (setq sml/no-confirm-load-theme t)
  (setq sml/theme 'atom-one-dark)
  :config

  (sml/setup)
  )
(use-package nyan-mode
  :init
  (setq nyan-wavy-trail t)
  (setq nyan-animation-frame-interval 0.1)
  :config
  (nyan-start-animation)
  )
;;(setq zone-timer (run-with-idle-timer  t 'zone))
(use-package material-theme
  :config
  (add-hook 'after-init-hook (lambda () (load-theme 'material t)))
  )





;;;;;;;;;;;;;;;;;;;;;;;
;; PROGRAMMING
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package jedi
  :init
  (add-hook 'python-mode-hook 'jedi:setup)
  (setq jedi:complete-on-dot t)
  (setq jedi:get-in-function-call-delay 5000)
  (setq jedi:tooltip-medthod nil)
  :config
  (jedi:install-server))
(use-package elpy
  :config
  (elpy-enable)
  (setq elpy-rpc-backend "jedi")
  )
(setq c-default-style "linux")
(setq c-basic-offset 2)
;;    Auto close brackets
(electric-pair-mode)

;; Redo
(add-to-list 'load-path "~/.emacs.d/redo+")
(require 'redo+)
(define-key global-map (kbd "C-/") 'undo)
(define-key global-map (kbd "C-x C-/") 'redo)

;; linker scrip mode
(add-to-list 'load-path "~/.emacs.d/ld-mode")
(require 'ld-mode)
(ld-mode)

(use-package flycheck
  :init
  (add-hook 'c++-mode-hook
            (lambda () (setq flycheck-clang-language-standard "c++11")))
  (global-flycheck-mode)
  (defun include-paths ()
    ;; Add include dir to path
    (setq flycheck-clang-include-path (list (expand-file-name "../include"))))

  (add-hook 'c++-mode-hook 'include-paths)
  (add-hook 'c-mode-hook 'include-paths)
  )
;; Configs from tuhdo
(add-to-list 'load-path "~/.emacs.d/custom")
(require 'setup-general)
;;    (require 'setup-helm)
;; (require 'setup-cedet)
;; Mouse?
;;  (setq helm-allow-mouse t)

;;(require 'setup-helm-gtags)
(require 'setup-editing)

;; company

;;  (define-key c-mode-map  [(control tab)] 'company-complete)
;;  (define-key c++-mode-map  [(control tab)] 'company-complete)

(use-package projectile
  :bind-keymap ("C-x p" . projectile-command-map)
  :init
  (projectile-global-mode)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'ivy)

  )
;; (use-package helm
;;   :config
;;   (use-package helm-gtags
;;     :init

;;     (setq helm-gtags-ignore-case t
;;           helm-gtags-auto-update t
;;           helm-gtags-use-input-at-cursor t
;;           helm-gtags-pulse-at-cursor t
;;           helm-gtags-prefix-key "\C-cg"
;;           helm-gtags-suggested-key-mapping t)

;;     ;; Enable helm-gtags-mode in Dired so you can jump to any tag
;;     ;; when navigate project tree with Dired
;;     (add-hook 'dired-mode-hook 'helm-gtags-mode)

;;     ;; Enable helm-gtags-mode in Eshell for the same reason as above
;;     (add-hook 'eshell-mode-hook 'helm-gtags-mode)

;;     ;; Enable helm-gtags-mode in languages that GNU Global supports
;;     (add-hook 'c-mode-hook 'helm-gtags-mode)
;;     (add-hook 'c++-mode-hook 'helm-gtags-mode)
;;     (add-hook 'java-mode-hook 'helm-gtags-mode)
;;     (add-hook 'asm-mode-hook 'helm-gtags-mode)

;;     ;; key bindings

;;     (define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
;;     (define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
;;     (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
;;     (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
;;     (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
;;     (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
;;     )
;;   )

(use-package ggtags
  :init
  (add-hook 'c-mode-hook 'ggtags-mode)
  (add-hook 'c++-mode-hook 'ggtags-mode)
  )

(use-package ivy
  :init
  (ivy-mode 1)
  (global-set-key (kbd "M-s o") 'swiper)
  (use-package ivy-posframe
    :init
    (ivy-posframe-mode 1)
    (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display))))
  (use-package counsel
    :init
    (counsel-mode 1)
    )
  ;; (use-package counsel-etags
  ;;   :ensure t
  ;;   :bind (("M-." . counsel-etags-find-tag-at-point)
  ;;          ("M-t" . counsel-etags-grep-symbol-at-point))
  ;;   :config
  ;;   (add-hook 'prog-mode-hook
  ;;             (lambda ()
  ;;               (add-hook 'after-save-hook
  ;;                         'counsel-etags-virtual-update-tags 'append 'local)))
  ;;   :config
  ;;   (setq counsel-etags-update-interval 60)
  ;;   (push "build" counsel-etags-ignore-directories)
  ;;   (defun my-scan-dir (src-dir &optional force)
  ;;     "Create tags file from SRC-DIR. \
  ;;    If FORCE is t, the commmand is executed without \
  ;;    checking the timer."
  ;;     (let* ((find-pg (or
  ;;                      counsel-etags-find-program
  ;;                      (counsel-etags-guess-program "find")))
  ;;            (ctags-pg (or
  ;;                       counsel-etags-tags-program
  ;;                       (format "%s -e -L" (counsel-etags-guess-program
  ;;                                           "ctags"))))
  ;;            (default-directory src-dir)
  ;;            ;; run find&ctags to create TAGS
  ;;            (cmd (format
  ;;                  "%s . \\( %s \\) -prune -o -type f -not -size +%sk %s | %s -"
  ;;                  find-pg
  ;;                  (mapconcat
  ;;                   (lambda (p)
  ;;                     (format "-iwholename \"*%s*\"" p))
  ;;                   counsel-etags-ignore-directories " -or ")
  ;;                  counsel-etags-max-file-size
  ;;                  (mapconcat (lambda (n)
  ;;                               (format "-not -name \"%s\"" n))
  ;;                             counsel-etags-ignore-filenames " ")
  ;;                  ctags-pg))
  ;;            (tags-file (concat (file-name-as-directory src-dir) "TAGS"))
  ;;            (doit (or force (not (file-exists-p tags-file)))))
  ;;       ;; always update cli options
  ;;       (when doit
  ;;         (message "%s at %s" cmd default-directory)
  ;;         (async-shell-command cmd)
  ;;         (visit-tags-table tags-file t))))

  ;; (setq counsel-etags-update-tags-backend
  ;;       (lambda ()
  ;;         (interactive)
  ;;         (let* ((tags-file (counsel-etags-locate-tags-file)))
  ;;           (when tags-file
  ;;             (my-scan-dir (file-name-directory tags-file) t)
  ;;             (run-hook-with-args
  ;;              'counsel-etags-after-update-tags-hook tags-file)
  ;;             (unless counsel-etags-quiet-when-updating-tags
  ;; (message "%s is updated!" tags-file))))))


  (use-package flyspell-correct-ivy
    :ensure t
    :after (:all flyspell ivy)
    )
  )


;; (use-package counsel-gtags
;;   :bind-keymap ("C-c g" . counsel-gtags-command-map)
;;   :config
;;   (counsel-gtags-mode 1)
;;   (add-hook 'c-mode-hook 'counsel-gtags-mode)
;;   (add-hook 'c++-mode-hook 'counsel-gtags-mode)
;;   (define-key counsel-gtags-mode-map (kbd "M-t") 'counsel-gtags-find-definition)
;;   (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
;;   (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
;;   (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward)
;;   (define-key counsel-gtags-mode-map (kbd "M-.") 'counsel-gtags-dwim))
(use-package counsel-projectile
  :config
  (counsel-projectile-mode 1)
  )

(use-package ede
  :init
  (global-ede-mode)
  )
(use-package semantic
  :init
  ;; (global-semanticdb-minor-mode 1)
  ;; (global-semantic-idle-scheduler-mode 1)
  (semantic-mode 1)

  (setq semantic-new-buffer-setup-functions
        (remove-if (lambda (buffer-setup-function)
                     (member (car buffer-setup-function)
                             '(python-mode html-mode)))
                   semantic-new-buffer-setup-functions))

  (remove-hook 'python-mode-hook 'wisent-python-default-setup)
  )



(use-package irony
  :init
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)

  (defun my-irony-mode-hook ()
    "Custom irony mode hook to remap keys."
    (define-key irony-mode-map [remap completion-at-point]
      'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
      'irony-completion-at-point-async))

  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)


  (setq-mode-local c-mode semanticdb-find-default-throttle
                   '(local project unloaded recursive))
  (setq-mode-local c++-mode semanticdb-find-default-throttle
                   '(local project unloaded recursive))

  (semantic-remove-system-include "/usr/include/" 'c++-mode)
  (semantic-remove-system-include "/usr/local/include/" 'c++-mode)
  (add-hook 'semantic-init-hooks
            'semantic-reset-system-include)
  )

(use-package company
  :ensure t
  :defer t
  :bind (:map company-active-map ("<tab>" . company-complete-selection))
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (use-package rtags
    :init
    (use-package company-rtags))
  ;; (use-package company-c-headers
  ;;   :init
  ;;   (add-to-list 'company-backends 'company-c-headers))
  (use-package company-irony
    :init
    (use-package company-irony-c-headers
      :init
      (add-to-list 'company-backends 'company-irony-c-headers)
      ))

  :config
  (setq company-backends (delete 'company-semantic company-backends))
  (setq company-idle-delay 0.2)
  (add-to-list
   'company-backends '(company-irony
                       company-yasnippet
                       company-clang company-rtags))

  )


;; Folding code
(use-package hideshow
  :init
  (defun toggle-selective-display (column)
    (interactive "P")
    (set-selective-display
     (or column
         (unless selective-display
           (1+ (current-column))))))

  (defun toggle-hiding (column)
    (interactive "P")
    (if hs-minor-mode
        (if (condition-case nil
                (hs-toggle-hiding)
              (error t))
            (hs-show-all))
      (toggle-selective-display column)))
  (global-set-key (kbd "M-<up>") 'beginning-of-defun)
  (global-set-key (kbd "M-<down>") 'end-of-defun)
  (global-set-key (kbd "C-x \\") 'toggle-hiding)
  (global-set-key (kbd "C-\\") 'toggle-selective-display)
  (add-hook 'c-mode-common-hook  'hs-minor-mode)
  (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
  (use-package aggressive-indent
    :init
    (global-aggressive-indent-mode 1)
    (add-to-list 'aggressive-indent-excluded-modes 'html-mode)
    )
  )

;; Fix indent in orgmode
(setq org-src-tab-acts-natively t)
(defun my-org-mode-hook ()
  (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))
(add-hook 'org-mode-hook #'my-org-mode-hook)
(use-package helm-ag)
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))



(use-package tex
  :defer t
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)

  (setq TeX-save-query nil)
  ;; (setq-default TeX-master nil)

  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (setq reftex-plug-into-AUCTeX t)

  (setq TeX-PDF-mode t)





  (defun guess-TeX-master (filename)
    "Guess the master file for FILENAME from currently open .tex files."
    (let ((candidate nil)
          (filename (file-name-nondirectory filename)))
      (save-excursion
        (dolist (buffer (buffer-list))
          (with-current-buffer buffer
            (let ((name (buffer-name))
                  (file buffer-file-name))
              (if (and file (string-match "\\.tex$" file))
                  (progn
                    (goto-char (point-min))
                    (if (re-search-forward (concat "\\\\input{" filename "}") nil t)
                        (setq candidate file))
                    (if (re-search-forward (concat "\\\\include{" (file-name-sans-extension filename) "}") nil t)
                        (setq candidate file))))))))
      (if candidate
          (message "TeX master document: %s" (file-name-nondirectory candidate)))
      candidate))
  (add-hook 'LaTeX-mode-hook
            '(lambda ()
               (setq TeX-master (guess-TeX-master (buffer-file-name)))))


  (use-package pdf-tools
    :init
    (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
          TeX-source-correlate-start-server t
          )
    ;; revert pdf-view after compilation
    (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
    )


  )


;; Disable temp files
(setq create-lockfiles nil)
(setq auto-save-default nil)
(use-package sublimity
  :init
  (sublimity-mode 1))


(setq  helm-display-function 'helm-display-buffer-in-own-frame
       ;; helm-display-function 'my-helm-display-child-frame
       helm-display-buffer-reuse-frame t
       helm-display-buffer-width 100)

(defun reload-configs ()
  ;; Reload the config file
  (interactive)
  (load-file "~/.emacs.d/init.el")
  )
(defun open-config-file ()
  "Open this file"
  (interactive)
  (find-file "~/.emacs.d/settings.org")
  (org-mode)

  )
(define-key global-map (kbd "<f9>") 'reload-configs)
(define-key global-map (kbd "<f5>") 'redraw-display)

;; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
  )

;;    (use-package jupyter
;;    :init
;;  (use-package zmq))
(use-package ace-window
  :bind
  (("M-o". 'ace-window))
  )
(use-package avy
  :init
  :bind
  (("C-c SPC". 'avy-goto-word-1))
  (("M-g g". 'avy-goto-line))
  )

(use-package auto-complete
  :init
  (use-package popup))
(use-package ein
  :init
  (setq ein:use-auto-complete-superpack t)
  :bind
  (("C-<return>". 'ein:worksheet-execute-cell-km))
  )
(setq org-support-shift-select t)
;; Save sessions
;; (setq desktop-save-mode t)
;; ;;
;; Mouse scrolling in terminal
(global-set-key (kbd "<mouse-4>") 'scroll-down-line)
(global-set-key (kbd "<mouse-5>") 'scroll-up-line)

;; Mouse clicks
(xterm-mouse-mode +1)
;; terminal

(use-package vterm
  :init
  (define-key global-map (kbd "<f2>") 'vterm )
  )
(global-auto-revert-mode t)
;;(add-hook 'emacs-startup-hook 'desktop-read)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   (quote
    (((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "Okular")
     (output-html "xdg-open"))))
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#ffffff" "#f36c60" "#8bc34a" "#fff59d" "#4dd0e1" "#b39ddb" "#81d4fa" "#263238"))
 '(company-idle-delay 0)
 '(custom-enabled-themes (quote (smart-mode-line-respectful)))
 '(custom-safe-themes
   (quote
    ("edb73be436e0643727f15ebee8ad107e899ea60a3a70020dfa68ae00b0349a87" "81ac4d57e649127d2d92a5803e4bdc7852fe00f15d9e75957d69b35e9056fd7a" "87de2a48139167bfe19e314996ee0a8d081a6d8803954bafda08857684109b4e" "409e4d689f1e29e5a18f536507e6dc760ee9da76dc56481aaa0696705e6be968" "b89ae2d35d2e18e4286c8be8aaecb41022c1a306070f64a66fd114310ade88aa" "5b7c31eb904d50c470ce264318f41b3bbc85545e4359e6b7d48ee88a892b1915" "43f03c7bf52ec64cdf9f2c5956852be18c69b41c38ab5525d0bedfbd73619b6a" "b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "a06658a45f043cd95549d6845454ad1c1d6e24a99271676ae56157619952394a" "939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a" "aded61687237d1dff6325edb492bde536f40b048eab7246c61d5c6643c696b7f" "4cf9ed30ea575fb0ca3cff6ef34b1b87192965245776afa9e9e20c17d115f3fb" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "4b6deee4167dfdb24ead4b3f717fa4b8109dd1cf71cdc9b59e05cc0f6588ee33" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "60940e1f2fa3f4e61e7a7ed9bab9c22676aa25f927d5915c8f0fa3a8bf529821" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "d1af5ef9b24d25f50f00d455bd51c1d586ede1949c5d2863bef763c60ddf703a" "d4f8fcc20d4b44bf5796196dbeabec42078c2ddb16dcb6ec145a1c610e0842f3" "afd761c9b0f52ac19764b99d7a4d871fc329f7392dfc6cd29710e8209c691477" "dcdd1471fde79899ae47152d090e3551b889edf4b46f00df36d653adc2bf550d" default)))
 '(default-input-method "rfc1345")
 '(dimmer-mode t nil (dimmer))
 '(helm-mode t)
 '(hl-todo-keyword-faces
   (quote
    (("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2aa198")
     ("PROG" . "#268bd2")
     ("OKAY" . "#268bd2")
     ("DONT" . "#d70000")
     ("FAIL" . "#d70000")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#875f00")
     ("KLUDGE" . "#875f00")
     ("HACK" . "#875f00")
     ("TEMP" . "#875f00")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f"))))
 '(nyan-mode t)
 '(package-selected-packages
   (quote
    (counsel-etags pdf-tools auctex semantics company-irony elpy ace-window avy ace-jump-mode jedi auto-complete jupyter vterm cmake-mode helm-ag zone-nyan nyan-mode org-beautify-theme company-c-headers redo+ centaur-tabs selectrum helm-smex smex function-args aggressive-indent immaterial-theme atom-dark-theme badger-theme gruvbox-theme nimbus-theme docker-compose-mode dashboard vimish-fold dimmer neotree zoom spacemacs-theme smart-mode-line-atom-one-dark-theme atom-one-dark-theme material-theme flycheck dracula-theme zygospore yasnippet ws-butler volatile-highlights use-package undo-tree iedit dtrt-indent counsel-projectile company clean-aindent-mode anzu)))
 '(pdf-view-midnight-colors (quote ("#b2b2b2" . "#262626")))
 '(projectile-mode t nil (projectile))
 '(safe-local-variable-values
   (quote
    ((eval setq flycheck-clang-include-path
           (quote
            ("/home/khadinh/projects/pim-sgx/remote_attestation/oram/include" "/home/khadinh/projects/pim-sgx/remote_attestation/oram/include/
syslib" "/home/khadinh/projects/pim-sgx/remote_attestation/oram/include/stdlib"))))))
 '(tetris-x-colors
   [[229 192 123]
    [97 175 239]
    [209 154 102]
    [224 108 117]
    [152 195 121]
    [198 120 221]
    [86 182 194]])
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#B71C1C")
     (40 . "#FF5722")
     (60 . "#FFA000")
     (80 . "#558b2f")
     (100 . "#00796b")
     (120 . "#2196f3")
     (140 . "#4527A0")
     (160 . "#B71C1C")
     (180 . "#FF5722")
     (200 . "#FFA000")
     (220 . "#558b2f")
     (240 . "#00796b")
     (260 . "#2196f3")
     (280 . "#4527A0")
     (300 . "#B71C1C")
     (320 . "#FF5722")
     (340 . "#FFA000")
     (360 . "#558b2f"))))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#272c34" :foreground "#ffffff" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "PfEd" :family "DejaVu Sans Mono"))))
 '(mouse ((t (:background "white smoke")))))
