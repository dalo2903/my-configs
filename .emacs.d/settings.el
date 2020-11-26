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
      (setq zoom-size '(0.618 . 0.618))

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
      (setq sml/no-confirm-load-theme t)
      (sml/setup)
      )

    (use-package nyan-mode
      :init
      (setq nyan-wavy-trail t)
      (setq nyan-animation-frame-interval 0.1)
      :config
      (nyan-start-animation)
      )
;;    (setq zone-timer (run-with-idle-timer  t 'zone))

(setq c-default-style "linux")
(setq c-basic-offset 4)
;; Auto close brackets
(electric-pair-mode)

;; Redo
(add-to-list 'load-path "~/.emacs.d/redo+")
(require 'redo+)
(define-key global-map (kbd "C-/") 'undo)
(define-key global-map (kbd "C-x C-_") 'redo)

;; linker scrip mode
(add-to-list 'load-path "~/.emacs.d/ld-mode")
(require 'ld-mode)
(ld-mode)


;; Configs from tuhdo
(add-to-list 'load-path "~/.emacs.d/custom")
(require 'setup-general)
(require 'setup-helm)
(require 'setup-cedet)
;; Mouse?
(setq helm-allow-mouse t)

(require 'setup-helm-gtags)
(require 'setup-editing)

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

(defun reload-configs ()
  ;; Reload the config file
  (interactive)
  (load-file "~/.emacs.d/init.el")
  )
(defun open-config-file ()
  ;; Open this file
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

(setq org-support-shift-select t)
;; Save sessions
(setq desktop-save-mode t)
;; Mouse scrolling in terminal
(global-set-key (kbd "<mouse-4>") 'scroll-down-line)
(global-set-key (kbd "<mouse-5>") 'scroll-up-line)

;; Mouse clicks
(xterm-mouse-mode +1)
;; terminal


(define-key global-map (kbd "<f2>") 'vterm )
(global-auto-revert-mode t)
(add-hook 'emacs-startup-hook 'desktop-read)