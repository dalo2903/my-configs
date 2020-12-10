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


;; Configs from tuhdo
(add-to-list 'load-path "~/.emacs.d/custom")
(require 'setup-general)
(require 'setup-helm)
;; (require 'setup-cedet)
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

;; (defun my-helm-display-child-frame (buffer &optional resume)
;;   "Display `helm-buffer' in a separate frame.
;; Function suitable for `helm-display-function',
;; `helm-completion-in-region-display-function'
;; and/or `helm-show-completion-default-display-function'.
;; See `helm-display-buffer-height' and `helm-display-buffer-width' to
;; configure frame size."
;;   (if (not (display-graphic-p))
;;       ;; Fallback to default when frames are not usable.
;;       (helm-default-display-buffer buffer)
;;     (setq helm--buffer-in-new-frame-p t)
;;     (let* ((pos (window-absolute-pixel-position))
;;            (half-screen-size (/ (display-pixel-height x-display-name) 2))
;;            (frame-info (frame-geometry))
;;            (prmt-size (length helm--prompt))
;;            (line-height (frame-char-height))
;;            (default-frame-alist
;;              `((parent . ,(selected-frame))
;;                (width . ,helm-display-buffer-width)
;;                (height . ,helm-display-buffer-height)
;;                (undecorated . t)
;;                (left-fringe . 0)
;;                (right-fringe . 0)
;;                (tool-bar-lines . 0)
;;                (line-spacing . 0)
;;                (desktop-dont-save . t)
;;                (no-special-glyphs . t)
;;                (inhibit-double-buffering . t)
;;                (tool-bar-lines . 0)
;;                (left . ,(- (car pos)
;;                            (* (frame-char-width)
;;                               (if (< (- (point) (point-at-bol)) prmt-size)
;;                                   (- (point) (point-at-bol))
;;                                 prmt-size))))
;;                ;; Try to put frame at the best possible place.
;;                ;; Frame should be below point if enough
;;                ;; place, otherwise above point and
;;                ;; current line should not be hidden
;;                ;; by helm frame.
;;                (top . ,(if (> (cdr pos) half-screen-size)
;;                            ;; Above point
;;                            (- (cdr pos)
;;                               ;; add 2 lines to make sure there is always a gap
;;                               (* (+ helm-display-buffer-height 2) line-height)
;;                               ;; account for title bar height too
;;                               (cddr (assq 'title-bar-size frame-info)))
;;                          ;; Below point
;;                          (+ (cdr pos) line-height)))
;;                (title . "Helm")
;;                (vertical-scroll-bars . nil)
;;                (menu-bar-lines . 0)
;;                (fullscreen . nil)
;;                (visible . ,(null helm-display-buffer-reuse-frame))
;;                (minibuffer . t)))
;;            display-buffer-alist)
;;       ;; Add the hook inconditionally, if
;;       ;; helm-echo-input-in-header-line is nil helm-hide-minibuffer-maybe
;;       ;; will have anyway no effect so no need to remove the hook.
;;       (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)
;;       (with-helm-buffer
;;         (setq-local helm-echo-input-in-header-line
;;                     (not (> (cdr pos) half-screen-size))))
;;       (helm-display-buffer-popup-frame buffer default-frame-alist))
;;     (helm-log-run-hook 'helm-window-configuration-hook)))


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
  ;;
  Open this file
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

(use-package vterm
  :init
  (define-key global-map (kbd "<f2>") 'vterm )
  )
(global-auto-revert-mode t)
(add-hook 'emacs-startup-hook 'desktop-read)
