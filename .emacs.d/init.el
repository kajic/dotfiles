;;; .emacs --- kajic emacs

(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

;; Load utility function to avoid undefined errors in case init.el is broken
(add-to-list 'load-path "~/.emacs.d")
(load "defun.el")

;; Turn off mouse interface early in startup to avoid momentary display
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please... jeez
(setq inhibit-startup-screen t)

;;;; customization
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;;; aliases
(defalias 'qrr 'query-replace-regexp)
(defalias 'qr 'query-replace)
(defalias 'yes-or-no-p 'y-or-n-p)


;;;; generic
(blink-cursor-mode nil)
(column-number-mode t)
(global-auto-revert-mode t)
(savehist-mode t)
(show-paren-mode t)
(winner-mode t)
(delete-selection-mode t)
(which-function-mode t)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)


;;;; path
(add-to-list 'load-path "~/.emacs.d/elisp")


;;;; env
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))


;;; hooks
(add-hook 'before-save-hook 'cleanup-buffer-safe)


;;;; package.el
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/")
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(setq package-user-dir "~/.emacs.d/elpa/")
(defvar mp-rad-packages
  '(
    ag
    auto-complete
    epc ;; jedi dependency
    jedi
    find-file-in-project
    virtualenv
    ;; browse-kill-ring
    ;; dired+
    ;; git-commit-mode
    ;; gist
    ;; dropdown-list
    ))
(package-initialize)

(defun mp-install-rad-packages ()
  "Install only the sweetest of packages."
  (interactive)
  (package-refresh-contents)
  (mapc #'(lambda (package)
            (unless (package-installed-p package)
              (package-install package)))
        mp-rad-packages))


(defun mp-build-rad-packages ()
  (interactive)
  (mapc #'(lambda (package)
            (package-build-archive package))
        mp-rad-packages))


;;;; macros
(defmacro after (mode &rest body)
  "`eval-after-load' MODE evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,mode
     '(progn ,@body)))


;;;; mac keybindings
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;;;; global key bindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-x n") 'cleanup-buffer)
(global-set-key (kbd "C-c y") 'bury-buffer)

(global-set-key (kbd "M-i") 'back-to-indentation)

(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-n") 'forward-paragraph)

(global-set-key (kbd "C-x O") 'other-window-reverse)
(global-set-key (kbd "M-`") 'other-frame)
(global-set-key (kbd "M-[") 'previous-buffer)
(global-set-key (kbd "M-]") 'next-buffer)

(global-set-key (kbd "M-RET") 'open-next-line)
(global-set-key (kbd "C-o") 'open-line-indent)
(global-set-key (kbd "M-o") 'open-previous-line)
(global-set-key (kbd "C-M-<return>") 'new-line-in-between)

(global-set-key (kbd "C-x m") 'point-to-register)
(global-set-key (kbd "C-x j") 'jump-to-register)

(global-set-key (kbd "C-c v") 'eval-buffer)
(global-set-key (kbd "C-c b") 'create-scratch-buffer)

(global-set-key (kbd "C-c +") 'increment-number-at-point)
(global-set-key (kbd "C-c -") 'decrement-number-at-point)

(global-set-key (kbd "C-.") 'repeat)

(global-set-key (kbd "M-%") 'query-replace-regexp)
(global-set-key (kbd "C-M-%") 'query-replace)

(global-set-key (kbd "C-c o") 'occur)
(global-set-key (kbd "M-s m") 'multi-occur)
(global-set-key (kbd "M-s M") 'multi-occur-in-matching-buffers)

(global-set-key (kbd "C-x -") 'toggle-window-split)
(global-set-key (kbd "C-x C--") 'rotate-windows)

(global-set-key (kbd "C-x C-r") 'rename-current-buffer-and-file)

(global-set-key (kbd "C-c h") 'help-command)
(define-key 'help-command "a" 'apropos)

;;;; desktop
(make-directory "~/.emacs.d/desktop/" t)
(setq desktop-dirname             "~/.emacs.d/desktop/"
      desktop-base-file-name      "emacs.desktop"
      desktop-base-lock-name      "lock"
      desktop-path                (list desktop-dirname)
      desktop-save                t
      desktop-files-not-to-save   "^$" ;reload tramp paths
      desktop-load-locked-desktop nil)
(desktop-save-mode 1)

;;;; windows
(setq revive:configuration-file "~/.emacs.d/revive.el")
(global-set-key (kbd "C-+") 'enlarge-window)
(global-set-key (kbd "C--") 'shrink-window)
(global-set-key (kbd "M-+") 'enlarge-window-horizontally)
(global-set-key (kbd "M--") 'shrink-window-horizontally)

;; ack
(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)

;; go
(add-hook 'before-save-hook #'gofmt-before-save)
(eval-after-load "go-mode"
  '(progn
     (flycheck-declare-checker go-fmt
       "A Go syntax and style checker using the gofmt utility."
       :command '("gofmt" source-inplace)
       :error-patterns '(("^\\(?1:.*\\):\\(?2:[0-9]+\\):\\(?3:[0-9]+\\): \\(?4:.*\\)$" error))
       :modes 'go-mode)
     (add-to-list 'flycheck-checkers 'go-gofmt)))
(add-hook 'go-mode-hook 'flycheck-mode)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; git
(defun git-grep (search) "git-grep the entire current repo"
  (interactive (list (completing-read "Search for: " nil nil nil (current-word))))
  (grep-find (concat "git --no-pager grep -P -n " search " `git rev-parse --show-toplevel`")))


;; ror
(setq load-path (cons (expand-file-name "~/.emacs.d/elisp/emacs-rails-reloaded") load-path))
(require 'rails-autoload)

;; erc
(require 'erc)
(setq erc-auto-reconnect t)
(add-hook 'erc-text-matched-hook 'erc-beep-on-match)
(setq erc-beep-match-types '(current-nick keyword))

;; joining && autojoing
;; make sure to use wildcards for e.g. freenode as the actual server
;; name can be be a bit different, which would screw up autoconnect
(erc-autojoin-mode t)
(setq erc-autojoin-channels-alist
      '((".*\\.freenode.net" "#kozmoeraser")))

;; check channels
(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                 "324" "329" "332" "333" "353" "477"))

(defun djcb-erc-start-or-switch ()
  "Connect to ERC, or switch to last active buffer"
  (interactive)
  (if (get-buffer "irc.freenode.net:6667") ;; ERC already active?
      (erc-track-switch-buffer 1) ;; yes: switch to last active
    (when (y-or-n-p "Start ERC? ") ;; no: maybe start ERC
      (erc :server "irc.freenode.net" :port 6667 :nick "kajic" :full-name "Robert Kajic"))))

;; switch to ERC with Ctrl+c e
(global-set-key (kbd "C-c e") 'djcb-erc-start-or-switch)

;; identify automatically
(load "~/.ercpw")
(require 'erc-services)
(erc-services-mode 1)
(setq erc-prompt-for-nickserv-password nil)
(setq erc-nickserv-passwords
      `((freenode     (("kajic" . ,freenode-kajic-pass)))))


;;;; python
;; (virtualenv-workon "default/")

;;;; auto-complete
;; (setq py-load-pymacs-p nil)
;; (add-to-list 'load-path "~/.emacs.d/elisp/Pymacs")

;; (after 'auto-complete
;;   (setq ac-auto-show-menu .1)
;;   (setq ac-use-menu-map t)
;;   (setq ac-disable-inline t)
;;   (setq ac-candidate-menu-min 0))

;; (after 'auto-complete-config
;;   ;; (ac-config-default)
;;   (add-hook 'ein:notebook-multilang-mode-hook 'auto-complete-mode)
;;   (setq-default ac-sources (append '(ac-source-yasnippet ac-source-imenu) ac-sources))
;;   (when (file-exists-p (expand-file-name "~/.emacs.d/elisp/Pymacs"))
;;     (ac-ropemacs-initialize)
;;     (ac-ropemacs-setup)))

;; (after "auto-complete-autoloads"
;;   (require 'auto-complete-config))

;; auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)

;; python
(defun project-directory (buffer-name)
  (interactive)
  (let ((git-dir (file-name-directory buffer-name)))
    (while (and (not (file-exists-p (concat git-dir ".git")))
                git-dir)
      (setq git-dir
            (if (equal git-dir "/")
                nil
              (file-name-directory (directory-file-name git-dir)))))
    git-dir))

(defun project-name (buffer-name)
  (let ((git-dir (project-directory buffer-name)))
    (if git-dir
        (file-name-nondirectory
         (directory-file-name git-dir))
      nil)))

(defun virtualenv-directory (buffer-name)
  (let ((venv-dir (expand-file-name
                   (concat "~/.virtualenvs/" (project-name buffer-name)))))
    (if (and venv-dir (file-exists-p venv-dir))
        venv-dir
      nil)))

(defun setup-jedi-server-args ()
  (let ((venv-dir (virtualenv-directory buffer-file-name)))
    (when venv-dir (set 'jedi:server-args (list "--virtual-env" venv-dir)))))

(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)
(add-hook 'python-mode-hook 'setup-jedi-server-args)
(add-hook 'python-mode-hook 'jedi:setup)
