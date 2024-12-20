;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; TODO: consider using org file as config (then tangle to config.el)
;;
(setq menu-bar-mode nil
      company-idle-delay nil
      ;; Switch to the new window after splitting
      evil-split-window-below t
      evil-vsplit-window-right t
      direnv-always-show-summary nil
      json-reformat:indent-width 2
      js2-basic-offset 2
      js-indent-level 2
      typescript-indent-level 2
      global-undo-tree-mode t
      ;; plantuml-default-exec-mode "jar"
      ;; magit
      magit-inhibit-save-previous-winconf t
      magit-todos-exclude-globs '(".git/" ".node_modules/" "dist/" "target/" "*.map" "*.json")
      forge-buffer-draft-p t
      ;; flycheck
      flycheck-stylelintrc ".stylelintrc.json"
      flycheck-display-errors-function nil
      ;; lsp
      ;; performance tuning
      ;; https://emacs-lsp.github.io/lsp-mode/page/performance/
      gc-cons-threshold 100000000
      read-process-output-max (* 2048 2048) ;; 4mb
      ;; modeline
      all-the-icons-scale-factor 1.1
      ;; display time
      display-time-day-and-date t
      ;; eww
      eww-bookmarks-directory "~/freizl/doom.d/backups/"
      ;; bookmark
      bookmark-default-file "~/freizl/doom.d/backups/emacs-bookmarks"
      ;; shr/eww related config
      shr-inhibit-images nil
      shr-use-colors nil
      shr-use-fonts nil
      shr-bullet "• "
      shr-image-animate nil
      url-privacy-level '(email lastloc os cookies)
      url-user-agent "User-Agent: Mozilla/5.0 (iPad; CPU OS 13_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/87.0.4280.77 Mobile/15E148 Safari/604.1"
      ;;
      deft-directory "~/Downloads/markdowns"
      deft-extensions '("md", "markdown")
      deft-recursive t
      deft-use-filename-as-title t
      ;;
      fill-column 100
      )

(setq-default line-spacing 2)

;; display-line-numbers-type nil
;; ranger-excluded-extensions '("mkv" "iso" "mp4", "mov")
;; ranger-max-preview-size 5

(display-time)
(fringe-mode 16)

;; Looks like the alert (https://github.com/jwiegley/alert) package
;; has been load already (probably as dependency of other package)
;; Also org-mode timers notification use osx-notifier as well. `org-timer-set-timer'
;; TODO: consider to use different style base on `system-type' (OS)
(after! alert
  (setq alert-default-style 'osx-notifier))

;;(add-hook 'evil-local-mode-hook 'turn-on-undo-tree-mode)
(pushnew! +lookup-provider-url-alist
          '("Hackage" "https://hackage.haskell.org/package/%s")
          '("Hoogle" "https://hoogle.haskell.org/?hoogle=%s")
          '("Merriam Webster" "https://www.merriam-webster.com/dictionary/%s")
          '("Haskell Errors" "https://errors.haskell.org/messages/%s")
          )

(setq Info-directory-list
      (append '("~/freizl/doom.d/info") Info-directory-list))

(setq restclient-log-request nil)

(after! lsp-mode
  (setq lsp-log-io nil
        ;; lsp-diagnostics-provider :none
        lsp-ui-sideline-enable nil
        lsp-enable-file-watchers nil
        ;; FIXME: will cause too many files open error and emacs become useless.
        ;; lsp-file-watch-threshold 3000
        lsp-headerline-breadcrumb-enable nil
        )
  (pushnew! lsp-file-watch-ignored-directories
            "[/\\\\]\\.hiefiles\\'"
            "[/\\\\]\\.packages\\'"
            )
  )

(after! projectile
  (pushnew! projectile-globally-ignored-directories
            "^dist-newstyle$" "^dist$" "^.storybook$" "^build$"
            "^.hiefiles$" "^.packages$"))

;; (after! sqlformat
;;   (setq sqlformat-command 'pgformatter
;;         sqlformat-args '("-c" "~/Downloads/pg_format.conf"))
;;   (add-hook 'sql-mode-hook 'sqlformat-on-save-mode)
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;            ChatGPT-shell            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'auth-source)
;; (require 'chatgpt-shell)
;; (require 'ob-chatgpt-shell)
;; (setq chatgpt-shell-openai-key
;;       (auth-source-pick-first-password
;;        :host "api.openai.com"
;;        :user "hw214@pm.me"))
;; (ob-chatgpt-shell-setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                Dired                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! dired-x
  :config
  (add-to-list 'dired-guess-shell-alist-user '("\\.mov\\'" "open"))
  (add-to-list 'dired-guess-shell-alist-user '("\\.svg\\'" "open"))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;               Org Mode              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(require 'org-web-tools)
(setq org-directory "~/freizl/my-notes/"
      org-attach-id-dir (concat org-directory ".attach")
      org-notes-directory (concat org-directory "00-orgs/")
      org-roam-directory (concat org-directory "20-roam-notes/")
      org-mobile-directory "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/"
      org-mobile-inbox-for-pull (concat org-notes-directory "from-mobile.org")
      ;; org-clock-sound "~/freizl/doom.d/traditional-asian-percussion.wav" ;; doesn't work at MacOS
      ;; org-clock-idle-time 5
      org-clock-auto-clockout-timer 600
      org-cycle-hide-block-startup t
      org-agenda-start-with-log-mode t
      org-agenda-skip-scheduled-if-done t
      org-deadline-warning-days 5
      org-agenda-custom-commands
      '(("y" "With Studies"
         ((agenda "")
          (tags-todo "study")
          (todo "Reading")
          ))
        ("p" agenda*) ;; "Appointments"
        )
      )

;; set my own org-capture-templates
;; mostly copied from "doomemacs/lang/org/config.el"
(after! org
  (setq +org-capture-journal-file (concat org-notes-directory "journal.org")
        +org-capture-personal-file (concat org-notes-directory "inbox.org")
        +org-capture-note-file (concat org-notes-directory "note.org")
        +org-capture-purchase-file (concat org-notes-directory "purchase.org")
        ;; https://orgmode.org/manual/Template-elements.html
        org-capture-templates
        '(("t" "Task" entry
           (file +org-capture-personal-file)
           "* TODO %?\n%i" :append t)

          ("j" "Journal" item
           (file+olp+datetree +org-capture-journal-file)
           "%U %?\n%i" :prepend t :jump-to-captured t)

          ("n" "Notes" entry
           (file +org-capture-note-file)
           "* %U %?\n%i" :append t)

          ("p" "Purchase" entry
           (file +org-capture-purchase-file)
           "* %U %?\n%i" :append t)
          )
        org-archive-location (concat org-directory "99-archive/%s::")
        org-agenda-files (list org-notes-directory
                               (concat org-directory "30-blogs/info/books.org"))
        org-todo-keywords (quote ((sequence "TODO(t)" "INPROGRESS(i!)" "CODEREVIEW(v!)" "DONE(d!)")
                                  (sequance "|" "BLOCK(b@/!)" "PAUSE(p@/!)")
                                  (sequence "|" "CANCELED(c@/!)")))
        org-todo-keyword-faces '(("TODO" . (:foreground "#e97107"))
                                 ("INPROGRESS" . (:foreground "#1662DD"))
                                 ("CODEREVIEW" . (:foreground "#a7b5ec"))
                                 ("DONE" . (:foreground "#84d2b1"))
                                 ("BLOCK" . (:foreground "#DA372C"))
                                 ("CANCELED" . (:foreground "#8c8c96" ))
                                 ("PAUSE" . (:foreground "#8c8c96" ))
                                 )

        org-html-doctype "html5"
        ;; org-agenda-span 'day
        ;; org-agenda-start-day (org-today)
        org-agenda-start-on-weekday 1
        org-log-done 'time
        org-log-into-drawer t
        org-hide-block-startup t
        ;; org-ellipsis " ▼ "
        org-ellipsis "…"
        org-hide-emphasis-markers t
        org-pretty-entities t ;; org-entities-help

        ;; org-noter
        org-noter-always-create-frame nil

        ;; Better support utf-8
        org-latex-pdf-process '("xelatex -interaction nonstopmode -output-directory %o %f"
                                "xelatex -interaction nonstopmode -output-directory %o %f"
                                "xelatex -interaction nonstopmode -output-directory %o %f")

        org-babel-default-header-args (append '((:comments . "link")
                                                (:mkdirp . "yes"))
                                              org-babel-default-header-args)

        ;; org-bullets-bullet-list '("•")
        ;; org-superstar-headline-bullets-list '("#")
        ;;
        ;; org-journal
        ;; org-journal-dir (concat org-directory "21-journal/")
        ;; org-journal-file-format "%Y%m%d.org"
        ;; org-journal-date-prefix "#+TITLE: "
        ;; org-journal-time-prefix "* "
        ;;
        ;; ditaa
        org-ditaa-jar-path (concat doom-private-dir "tools/ditaa0_9.jar")
        ;;
        )

  (org-clock-auto-clockout-insinuate)

  ;; (global-org-modern-mode)
  ;; (set-face-attribute 'org-modern-symbol nil :family "Iosevka")
  ;;
  ;; (org-roam-db-build-cache)
  )

(defun hw/org-retrieve-url-from-point ()
  "Copies the URL from an org link at the point"
  (interactive)
  (let ((plain-url (url-get-url-at-point)))
    (if plain-url
        (progn
          (kill-new plain-url)
          (message (concat "Copied: " plain-url)))
      (let* ((link-info (assoc :link (org-context)))
             (text (when link-info
                     (buffer-substring-no-properties
                      (or (cadr link-info) (point-min))
                      (or (caddr link-info) (point-max))))))
        (if (not text)
            (error "Oops! Point isn't in an org link")
          (string-match org-link-bracket-re text)
          (let ((url (substring text (match-beginning 1) (match-end 1))))
            (kill-new url)
            (message (concat "Copied: " url))))))))

(map! :map org-mode-map
      :localleader
      (:prefix ("l" . "links")
               "y" #'hw/org-retrieve-url-from-point))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;          Org Project Config         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; copy sitemap.html to index.html
;; <update at 2022-09>: use another approach, create "index.org" instead.
;;
;; (defun create-index-html (in out)
;;   (if (string= (car (last (split-string out "/"))) "sitemap.html")
;;       (progn
;;         (message "copy index.html from '%s'" out)
;;         (copy-file out (replace-regexp-in-string "sitemap.html" "index.html" out) t))))
;; (add-hook 'org-publish-after-publishing-hook 'create-index-html)

;; === reset cache
;; looks like the reset method does not remove cached file hence the work around
(defun hw/org-publish-reset-cache ()
  "Clean up org-publish cache and cache files"
  (interactive)
  (progn
    (org-publish-reset-cache)
    (delete-file "~/.emacs.d/.local/cache/org/timestamps/hw-posts.cache")
    (delete-file "~/.emacs.d/.local/cache/org/timestamps/hw-pages.cache")
    (delete-file "~/.emacs.d/.local/cache/org/timestamps/hw-info.cache")
    (delete-file "~/.emacs.d/.local/cache/org/timestamps/hw-static.cache")
    (delete-file "~/.emacs.d/.local/cache/org/timestamps/plantuml-examples.cache")
    ))

(defun hw/org-sitemap-date-entry-format (entry style project)
  "Format ENTRY in org-publish PROJECT Sitemap format ENTRY ENTRY STYLE format that includes date."
  (let ((filetitle (org-publish-find-title entry project))
        (file-prop-date (org-publish-find-property entry :date project))
        (filedate (org-publish-find-date entry project))
        )
    ;; debug
    ;; (message (format "%s - %s" entry filetitle))
    ;; (message (format "%s [[file:%s][%s]]"
    ;;         (if file-prop-date file-prop-date (format-time-string "%Y-%m-%d" filedate))
    ;;         entry
    ;;         filetitle))
    (format "%s [[file:%s][%s]]"
            (if file-prop-date file-prop-date (format-time-string "%Y-%m-%d" filedate))
            entry
            filetitle)))
(setq org-publish-project-alist
      '(("hw-pages"
         :base-directory "~/freizl/my-notes/30-blogs/"
         :base-extension "org"
         :publishing-function org-html-publish-to-html
         :publishing-directory "~/freizl/freizl.github.com/"
         :recursive nil
         :headline-levels 3
         :with-toc nil
         :section-numbers nil
         :auto-sitemap nil
         :makeindex nil
         :html-postamble nil
         :html-head-include-scripts nil
         :html-head-include-default-style nil
         :html-head-extra "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://js-fun.github.io/iosevka-webfont/iosevka-term-ss08-17.0.2/iosevka-term-ss08.css\"/>
                           <link rel=\"stylesheet\" type=\"text/css\" href=\"https://js-fun.github.io/iosevka-webfont/iosevka-etoile-17.0.2/iosevka-etoile.css\"/>
                           <link rel=\"stylesheet\" type=\"text/css\" href=\"/css/org-default.css\"/>
                           <link rel=\"stylesheet\" type=\"text/css\" href=\"/css/default.css\"/>"
         :html-html5-fancy t
         :html-doctype "html5"
         :html-link-home "/"
         :html-link-up "/"
         :html-validation-link t)
        ("hw-posts"
         :base-directory "~/freizl/my-notes/30-blogs/posts"
         :base-extension "org"
         :publishing-function org-html-publish-to-html
         :publishing-directory "~/freizl/freizl.github.com/posts"
         :recursive t
         :headline-levels 3
         :with-toc 3
         :time-stamp-file nil
         :auto-sitemap t
         :sitemap-title "All Posts Corner"
         :sitemap-filename "index.org"
         ;; :sitemap-sort-files alphabetically
         :sitemap-ignore-case t
         :sitemap-format-entry hw/org-sitemap-date-entry-format
         :makeindex nil
         :html-postamble "<hr/>
<footer>
  <div class=\"copyright\">Copyright &copy; 2012-present Haisheng Wu</div>
  <div class=\"generated\">Created at %d with %c</div>
</footer>"
         :html-head-include-scripts nil
         :html-head-include-default-style nil
         :html-head-extra "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://js-fun.github.io/iosevka-webfont/iosevka-term-ss08-17.0.2/iosevka-term-ss08.css\"/>
                           <link rel=\"stylesheet\" type=\"text/css\" href=\"https://js-fun.github.io/iosevka-webfont/iosevka-etoile-17.0.2/iosevka-etoile.css\"/>
                           <link rel=\"stylesheet\" type=\"text/css\" href=\"/css/org-default.css\"/>
                           <link rel=\"stylesheet\" type=\"text/css\" href=\"/css/default.css\"/>"
         :html-html5-fancy t
         :html-doctype "html5"
         :html-link-home "/"
         :html-link-up "/"
         :html-validation-link t)
        ("hw-info"
         :base-directory "~/freizl/my-notes/30-blogs/info"
         :base-extension "org"
         :publishing-function org-html-publish-to-html
         :publishing-directory "~/freizl/freizl.github.com/info"
         :recursive t
         :headline-levels 3
         :with-toc 3
         :time-stamp-file nil
         :auto-sitemap t
         :sitemap-title "All Information Corner"
         :sitemap-filename "index.org"
         ;; :sitemap-sort-files alphabetically
         :sitemap-ignore-case t
         :sitemap-format-entry hw/org-sitemap-date-entry-format
         :makeindex nil
         :html-postamble "<hr/>
<footer>
  <div class=\"copyright\">Copyright &copy; 2012-present Haisheng Wu</div>
  <div class=\"generated\">Created at %d with %c</div>
</footer>"
         :html-head-include-scripts nil
         :html-head-include-default-style nil
         :html-head-extra "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://js-fun.github.io/iosevka-webfont/iosevka-term-ss08-17.0.2/iosevka-term-ss08.css\"/>
                           <link rel=\"stylesheet\" type=\"text/css\" href=\"https://js-fun.github.io/iosevka-webfont/iosevka-etoile-17.0.2/iosevka-etoile.css\"/>
                           <link rel=\"stylesheet\" type=\"text/css\" href=\"/css/org-default.css\"/>
                           <link rel=\"stylesheet\" type=\"text/css\" href=\"/css/default.css\"/>"
         :html-html5-fancy t
         :html-doctype "html5"
         :html-link-home "/"
         :html-link-up "/"
         :html-validation-link t)
        ("hw-static"
         :base-directory "~/freizl/my-notes/30-blogs/imgs"
         :base-extension "svg\\|png\\|jpeg"
         :publishing-directory "~/freizl/freizl.github.com/imgs"
         :publishing-function org-publish-attachment
         )
        ("plantuml-examples"
         :base-directory "~/freizl/plantuml-examples"
         :base-extension "org"
         :publishing-function org-html-publish-to-html
         :publishing-directory "~/freizl/plantuml-examples"
         :recursive t
         :headline-levels 3
         :with-toc 3
         :time-stamp-file nil
         :auto-sitemap t
         :sitemap-title "Plantuml Examples"
         :sitemap-filename "index.org"
         :sitemap-sort-files alphabetically
         :sitemap-ignore-case t
         :html-postamble ""
         :makeindex nil
         :html-html5-fancy t
         :html-doctype "html5"
         :html-link-home "/"
         :html-link-up "/"
         :html-validation-link t)
        ("hw-site" :components ("hw-pages" "hw-posts" "hw-static"))
        ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;               Wakatime              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package! wakatime-mode)
(global-wakatime-mode)
(setq wakatime-api-key  "55e867fe-4c74-4167-9beb-3624ba90ce5e"
      wakatime-cli-path "/opt/homebrew/bin/wakatime-cli")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;               Treemacs              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; by default doom use 'variable-pitch-font' for treemacs
;; TODO: what is 'variable-pitch'?
(setq doom-themes-treemacs-enable-variable-pitch nil)
(after! treemacs
  (setq treemacs-set-width 50
        treemacs-follow-mode t)
  (treemacs-toggle-fixed-width))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;               Haskell               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; does not work for me
;; (add-hook 'hack-local-variables-hook
;; (lambda () (when (derived-mode-p 'haskell-mode) (lsp))))

;; (setq lsp-haskell-check-project nil)
;; (setq lsp-haskell-server-args `("-l" ,lsp-haskell-server-log-file))

(after! haskell-mode
  (setq haskell-process-type 'cabal-repl
        lsp-haskell-server-path "~/.ghcup/bin/haskell-language-server-9.8.2~2.9.0.0"
        lsp-haskell-formatting-provider "fourmolu"
        lsp-haskell-plugin-splice-global-on nil
        lsp-haskell-plugin-haddock-comments-global-on nil
        lsp-haskell-plugin-retrie-global-on nil
        lsp-haskell-plugin-refine-imports-global-on nil
        lsp-haskell-plugin-tactics-global-on nil
        ;; lsp-haskell-plugin-module-name-global-on
        ))

;; for Yesod DSL files
;; (require 'yesod-mode)
;; (add-to-list 'auto-mode-alist '("\\.yesodroutes\\'" . yesod-routes-mode))

;; (require 'hiedb)
;; (add-hook 'haskell-mode-hook (lambda () (hiedb-mode)))
;; (setq mwb-project "/Users/hw/m/a-haskell-project")
;; (setq hiedb-project-root (concat mwb-project)
;;       hiedb-hiefiles (concat mwb-project "/.hiefiles")
;;       hiedb-dbfile (concat mwb-project "/.hiedb")
;;       hiedb-command "hiedb"
;;       )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;               LilyPond              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-load-path! "/opt/homebrew/Cellar/lilypond/2.24.3/share/emacs/site-lisp/lilypond")
(autoload 'LilyPond-mode "lilypond-mode" "LilyPond Editing Mode" t)
(add-to-list 'auto-mode-alist '("\\.ly\\'" . LilyPond-mode))
(add-to-list 'auto-mode-alist '("\\.ily\\'" . LilyPond-mode))
(add-hook 'LilyPond-mode-hook (lambda () (turn-on-font-lock)))

;; org-babel lilypond
(setq org-babel-lilypond-commands '("/opt/homebrew/bin/lilypond" "open" "open")
      ;; this is for arrange-mode
      org-babel-lilypond-arrange-mode t
      org-babel-lilypond-gen-html nil
      org-babel-lilypond-gen-pdf  nil
      org-babel-lilypond-use-eps  nil
      org-babel-lilypond-gen-svg  t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;              JavaScript             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fall back to `apheleia-format-buffer' (prettier)
(setq-hook! 'web-mode-hook +format-with-lsp nil)
(setq-hook! 'typescript-mode-hook +format-with-lsp nil)
(setq-hook! 'typescript-tsx-mode-hook +format-with-lsp nil)
;; feels unnecessary to run eslint on typing
(setq lsp-eslint-run "noSave")
;; not sure other command like run eslint for workspace
;; but following one works well for single file
(map! :leader
      :desc "Fixes all eslint"
      "c F" #'lsp-eslint-apply-all-fixes
      :mode (typescript-mode typescript-tsx-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                Format               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; auto-formating is annoying in existing project
;; which has established its own format
;; (setq +format-on-save-enabled-modes nil)
;; (add-hook 'haskell-mode-hook #'format-all-mode)
;; (add-hook 'js2-mode-hook #'format-all-mode)
;; (add-hook 'markdown-mode-hook #'format-all-mode)
;; (add-hook 'yaml-mode-hook #'format-all-mode)
;; (add-hook 'lisp-mode-hook #'format-all-mode)
;; (add-hook 'emacs-lisp-mode-hook #'format-all-mode)
;; (add-hook 'sql-mode-hook #'format-all-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;               KeyFreq               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)
(setq keyfreq-excluded-commands
      '(self-insert-command
        org-self-insert-command
        ;; mwheel-scroll
        evil-next-line
        evil-previous-line))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                 IRC                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after! circe
  (set-irc-server! "irc.libera.chat"
                   `(:tls t
                     :nick "freizl"
                     :channels ("#emacs"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                 Term                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq eshell-visual-commands nil)
(add-hook 'eshell-load-hook #'eat-eshell-mode)
(add-hook 'eshell-load-hook #'eat-eshell-visual-command-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;         OrgBabel Typescript         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ob-typescript)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((typescript . t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;               PlantUML              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ob-plantuml)
(after! ob-plantuml
  (add-to-list 'org-babel-default-header-args:plantuml
               '(:java . "-Djava.awt.headless=true")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                Email                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; brew install isync mu pass
;; create ~/.mbsyncrc
;; mbsync --all
;; mu init --maildir ~/mbsync --my-address freizl.em@gmail.com
;; mu index
;;
;; (set-email-account!
;;  "freizl.em"
;;  '(( mu4e-maildir . "~/mbsync")
;;    (mu4e-sent-folder       . "/[Gmail].Sent")
;;    (mu4e-drafts-folder     . "/[Gmail].Drafts")
;;    (mu4e-trash-folder      . "/[Gmail].Trash")
;;    (mu4e-refile-folder     . "/[Gmail].All Mail")
;;    (smtpmail-smtp-user     . "freizl.em@gmail.com")
;;    (smtpmail-smtp-server . "smtp.gmail.com")
;;    (mu4e-compose-signature . "Thanks.\nHaisheng"))
;;   t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                 RSS                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-hook! 'elfeed-search-mode-hook 'elfeed-update)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;           Customized Keys           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (map! :ne "SPC n t" #'counsel-org-capture)

(map! :ne "<f9>" #'org-tree-slide-move-previous-tree)
(map! :ne "<f10>" #'org-tree-slide-move-next-tree)

;; (map! :map org-tree-slide-mode-map
;;       :n "C-x s n" #'org-tree-slide-move-next-tree
;;       :n "C-x s p" #'org-tree-slide-move-previous-tree)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                 Font                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;;
;; (setq doom-font (font-spec :family "Input Mono" :size 12 :weight 'medium)
;;       doom-variable-pitch-font (font-spec :family "iA Writer Duospace" :size 12 :weight 'regular))
;;
;; Alternatives
;; https://typeof.net/Iosevka/
;; https://fonts.google.com/specimen/Roboto+Mono
;; https://fonts.google.com/specimen/Fira+Code
;; Linux Libertine: http://libertine-fonts.org/
;; ETBembo: https://github.com/edwardtufte/et-book
;; https://github.com/microsoft/cascadia-code
;; Deja Vu Sans Serif
;; Source Sans Pro
;;
;; (setq doom-font (font-spec :family "SF Mono" :size 15 :weight 'regular))
;; (setq doom-font (font-spec :family "JetBrains Mono" :size 15 :weight 'light))
;; (setq doom-font (font-spec :family "Cascadia code" :size 15 :weight 'regular))
;; (setq doom-font (font-spec :family "Roboto Mono" :size 15 :weight 'regular))
;; (setq doom-font (font-spec :family "Fira Code" :size 15 :weight 'light))
;; (setq doom-variable-pitch-font (font-spec :family "Deja Vu Sans" :size 15))
;; (setq doom-variable-pitch-font (font-spec :family "Linux Libertine O" :size 15))
;; (setq doom-variable-pitch-font (font-spec :family "ETBembo" :size 17))
;;
(setq doom-font (font-spec :family "Iosevka SS08" :size 15 :weight 'regular)
      doom-serif-font (font-spec :family "Iosevka Etoile" :size 15 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Iosevka SS08" :size 15 :weight 'regular))
;;
;; (setq doom-font (font-spec :family "Berkeley Mono" :size 15 :weight 'regular)
;;       doom-serif-font (font-spec :family "Berkeley Mono" :size 15 :weight 'regular)
;;       doom-variable-pitch-font (font-spec :family "Berkeley Mono" :size 15 :weight 'regular))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-dark-high-contrast)
;; (setq doom-theme 'doom-dracula)
;; (setq doom-theme 'doom-solarized-light)
;; (setq doom-theme 'doom-zenburn)
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-palenight)
;; (setq doom-theme 'modus-vivendi)
;; (setq doom-theme 'modus-operandi)

(defun hw/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'doom-solarized-dark-high-contrast t))
    ('dark (load-theme 'doom-solarized-dark-high-contrast t))))

(add-hook 'ns-system-appearance-change-functions #'hw/apply-theme)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;                Dired                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(after! dirvish
  (setq! dirvish-quick-access-entries
         `(("h" "~/"                "Home")
           ("E" ,doom-user-dir      "Emacs")
           ("D" ,doom-emacs-dir     "DoomEmacs")
           ("do" "~/Downloads/"     "Downloads")
           ("dc" "~/Documents/"     "Documents")
           ("ds" "~/Desktop/"       "Desktop")
           ("f" "~/freizl/"         "freizl")
           )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other tips
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Make Script Files Executable Automatically
;; https://emacsredux.com/blog/2021/09/29/make-script-files-executable-automatically/
;; (add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)


;; turn on debug
;; Hit C-g around 10 seconds into the hang
;; (toggle-debug-on-quit)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys


;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; doesn't work
;; just run `node --version` in terminal
;; then `doom env`
;;
;;(setq exec-path (append exec-path '("~/.nvm/versions/node/v12.13.0/bin")))
;;
