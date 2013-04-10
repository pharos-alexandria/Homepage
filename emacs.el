;;(setq custom-file "~/.emacs-custom.el")
;;(load custom-file)

; (add-to-list 'exec-path "~/bin/")
; (add-to-list 'exec-path "~/lib/elisp/")
; (add-to-list 'load-path "~/lib/elisp/")
; (add-to-list 'load-path "~/lib/elisp/ess/lisp/")
; (add-to-list 'load-path "~/git/org-mode-release/")
;;(add-to-list 'load-path "~/git/org-mode/lisp/")
;;(add-to-list 'load-path "~/git/org-mode/contrib/lisp/")

; (load "~/lib/elisp/htmlize.el")
; (load "~/lib/elisp/gnuplot.el")
; (global-font-lock-mode 1)
;;(show-paren-mode 1)
;;(menu-bar-mode 0)
;;(set-face-foreground 'font-lock-keyword-face "DeepSkyBlue1")
;;(set-face-foreground 'font-lock-string-face "pale goldenrod")

;;(require 'org)
;;(require 'org-html)
;;(require 'htmlize)

(eval-after-load "org-html"
'(setq org-export-html-scripts
       (concat org-export-html-scripts "\n"
	       "<script type=\"text/javascript\">
    function rpl(expr,a,b) {
      var i=0
      while (i!=-1) {
         i=expr.indexOf(a,i);
         if (i>=0) {
            expr=expr.substring(0,i)+b+expr.substring(i+a.length);
            i+=b.length;
         }
      }
      return expr
    }

    function show_org_source(){
       document.location.href = rpl(document.location.href,\"html\",\"org.html\");
    }
</script>
")))

;;(setq make-backup-files nil)

(setq org-export-default-language "de"
      org-export-html-extension "html"
      org-export-with-timestamps nil
      org-export-with-section-numbers nil
      org-export-with-tags 'not-in-toc
      org-export-with-drawers nil
      org-export-skip-text-before-1st-heading nil
      org-export-with-sub-superscripts '{}
      org-export-with-LaTeX-fragments t
      org-export-with-archived-trees nil
      org-export-highlight-first-table-line t
      org-export-latex-listings-w-names nil
      org-export-html-style-include-default nil
      org-export-htmlize-output-type 'css
      org-startup-folded t
      org-publish-list-skipped-files t
      org-publish-use-timestamps-flag t
      org-export-babel-evaluate nil
      org-confirm-babel-evaluate nil)

;; re-export everything regardless of whether or not it's been modified
(setq org-publish-use-timestamps-flag nil)

(defun set-org-publish-project-alist ()
  (interactive)
  (setq org-publish-project-alist
	`(("orgweb" :components ("orgwebpages" "orgweb-extra"))
	  ("orgwebpages"
	   :base-directory "~/Private/Homepage"
	   :base-extension "org"
	   :html-extension "html"
	   :publishing-directory "~/Sites/Privat"
	   :publishing-function org-publish-org-to-html
	   :auto-sitemap t
	   :sitemap-title "Überblick"
	   :sitemap-filename "sitemap-gen.org"
	   :sitemap-file-entry-format "%t"
	   :sitemap-date-format "%d.%m.%Y"
	   :section-numbers nil
	   :table-of-contents nil
	   :style "<link rel=\"SHORTCUT ICON\" href=\"gravatar-mini.jpg\" type=\"image/jpg\" />
<link rel=\"icon\" href=\"gravatar-mini.jpg\" type=\"image/jpg\" />
<link rel=\"publisher\" href=\"https://plus.google.com/102778904320752967064\" />
<script src=\"http://use.edgefonts.net/lato;alexa-std.js\"></script>"
	   :html-preamble ,(org-get-file-contents "~/Private/Homepage/preamble.html")
	   :html-postamble "<p class=\"date\">Zuletzt geändert: %d von %a</p><p class=\"creator\">Generated by %c, hosted on <a href='https://github.com/pharos-alexandria/Homepage'>Github</a></p><p><a rel=\"license\" href=\"http://creativecommons.org/licenses/by-sa/3.0/de/\">©</a> 2012–2013 <a href=\"mailto:annette@vonstockhausen.eu\">Annette von Stockhausen</a>, Vierzigmannstr. 12, 91054 Erlangen, Tel. 09131-9209175.</a></p><p><img alt=\"Creative Commons Lizenzvertrag\" style=\"border-width:0\" src=\"http://i.creativecommons.org/l/by-sa/3.0/de/80x15.png\" /></p>"
	   :exclude "sitemap-gen.html,emacs.el"
	   :recursive t)
	  ("orgweb-extra"
	   :base-directory "~/Private/Homepage"
	   :base-extension "css\\|html\\|png\\|jpg\\|js"
	   :publishing-directory "~/Sites/Privat"
	   :publishing-function org-publish-attachment
	   :recursive t)
	  )))

(set-org-publish-project-alist)

(defun worg-fix-symbol-table ()
  (when (string-match "org-symbols\\.html" buffer-file-name)
    (goto-char (point-min))
    (while (re-search-forward "<td>&amp;\\([^<;]+;\\)" nil t)
      (replace-match (concat "<td>&" (match-string 1)) t t))))


(defun publish-orgweb nil
   "Publish Org web pages."
   (interactive)
   (add-hook 'org-publish-after-export-hook 'worg-fix-symbol-table)
   (let ((org-format-latex-signal-error nil))
     (org-publish-project "orgweb")))


;; Org-Feed-Einstellungen
(setq org-feed-alist
      '(
        ("Zotero-AvS-Bib"
         "https://api.zotero.org/users/7164/items/top?start=0&limit=5"
         "~/Private/Homepage/index.org" "Zuletzt bibliographiert"
         :parse-entry org-feed-parse-atom-entry
         :parse-feed org-feed-parse-atom-feed
         :template "* %h\n %a\n"
         )
        ("Bibsonomy-Bookmarks"
         "http://www.bibsonomy.org/rss/user/avs?lang=de&bookmark.entriesPerPage=5"
         "~/Private/Homepage/index.org" "Neue Lesezeichen"
         :template "* %h\n %a\n"
         )
        )
      )


;; Falsche Links im Zotero-Feed ausbessern
(defun clear-feed-links ()
  (interactive)
  (goto-char 1)
  (while (search-forward "https://api.zotero.org/users/7164/" nil t) (replace-match "http://zotero.org/avs/" t nil))
)
