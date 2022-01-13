;;; publish --- Publish org files to GitLab Pages

;;; Commentary:

;; This file takes care of exporting org files to the public directory.
;; Images and such are also exported without any processing.

;;; Code:

(require 'package)
(package-initialize)
(unless package-archive-contents
  (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (package-refresh-contents))
(dolist (pkg '(org-contrib htmlize toml-mode lua-mode vimrc-mode fish-mode))
  (unless (package-installed-p pkg)
    (package-install pkg)))

(require 'org)
(require 'ox-publish)

(defun literate-dotfiles--postamble-format (info)
  "Function that formats the HTML postamble.
INFO is a plist used as a communication channel."
  (let ((buffer (plist-get info :input-buffer)))
    (concat "<hr>
<p>
<p class=\"Source\">Source: "
     (format "<a href=\"%s/%s\">%s</a></p>"
             "https://gitlab.com/DPDmancul/dotfiles/blob/main"
             buffer buffer)
     (unless (equal buffer "README.org")
       "<p>Return to <a href=\"index.html\">index</a>.</p>"))))

(defvar literate-dotfiles--site-attachments
  (regexp-opt '("jpg" "jpeg" "gif" "png" "svg"
                "ico" "cur" "css" "js"
                "eot" "woff" "woff2" "ttf"
                "html" "pdf"))
  "File types that are published as static files.")

(defvar literate-dotfiles--publish-project-alist
      (list
       (list "site-org"
             :base-directory "."
             :base-extension "org"
             :recursive t
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public"
             :exclude (regexp-opt '("unused/"))
             :auto-sitemap t
             :html-head-include-default-style nil
             :html-head-include-scripts nil
             :html-htmlized-css-url "https://gongzhitaao.org/orgcss/org.css"
             :html-head-extra "<link rel=\"icon\" type=\"image/png\" href=\"img/icon.png\" />\n<link rel=\"stylesheet\" href=\"style.css\" type=\"text/css\" />"
             :html-postamble 'literate-dotfiles--postamble-format
             :sitemap-style 'list
             :sitemap-sort-files 'alphabetically ;'anti-chronologically
             )
       (list "site-static"
             :base-directory "."
             :exclude (regexp-opt '("public/" "img/design/"))
             :base-extension literate-dotfiles--site-attachments
             :publishing-directory "./public"
             :publishing-function 'org-publish-attachment
             :recursive t)
       (list "site"
             :components '("site-org" "site-static"))
       ))

(defun literate-dotfiles-publish-all ()
  "Publish the literate dotfiles to HTML."
  (interactive)
  (let ((org-publish-project-alist       literate-dotfiles--publish-project-alist)
        (org-publish-timestamp-directory "./.timestamps/")
;;      (user-full-name                  nil) ;; avoid "Author: x" at the bottom
        (org-export-with-section-numbers nil)
        (org-export-with-smart-quotes    t)
        (org-export-with-toc             nil)
        (org-html-divs '((preamble  "header" "top")
                         (content   "main"   "content")
                         (postamble "footer" "postamble")))
        (org-html-container-element         "section")
        (org-html-metadata-timestamp-format "%Y-%m-%d")
        (org-html-checkbox-type             'html)
        (org-html-html5-fancy               t)
        (org-html-validation-link           nil)
        (org-html-doctype                   "html5")
        (org-html-htmlize-output-type       'css)
        (org-export-headline-levels 6)
        (org-confirm-babel-evaluate nil))

    (org-publish-all)))

;;; publish.el ends here
