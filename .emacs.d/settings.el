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



    (use-package irony
      :init
      (use-package rtags
        :init
        (use-package company-rtags))
      (use-package company-irony-c-headers)
      (use-package company-irony)
      (use-package semantic
        :init
        (semantic-mode 1))

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


      (setq company-backends (delete 'company-semantic company-backends))
      (eval-after-load 'company
        '(add-to-list
          'company-backends '(company-irony-c-headers
                              company-irony company-yasnippet
                              company-clang company-rtags)
          )
        )
      ;;    (setq company-idle-delay 0)
      ;;       (define-key c-mode-map [(tab)] 'company-complete)
      ;;      (define-key c++-mode-map [(tab)] 'company-complete)
      ;; ;; Delay
      ;;           when idle because I want to be able to think
      (setq company-idle-delay 0.2)

      (setq-mode-local c-mode semanticdb-find-default-throttle
                       '(local project unloaded recursive))
      (setq-mode-local c++-mode semanticdb-find-default-throttle
                       '(local project unloaded recursive))

      (semantic-remove-system-include "/usr/include/" 'c++-mode)
      (semantic-remove-system-include "/usr/local/include/" 'c++-mode)
      (add-hook 'semantic-init-hooks
                'semantic-reset-system-include)
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
