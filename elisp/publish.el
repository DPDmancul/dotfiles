(require 'org)
(require 'ox-publish)

(defun format-postamble (info)
  (let ((buffer (plist-get info :input-buffer)))
    (concat "<hr>
            <p>
            <p class=\"Source\">Source: "
            (format "<a href=\"%s/%s\">%s</a></p>"
                    "https://gitlab.com/DPDmancul/dotfiles/blob/nix"
                    buffer buffer)
            (unless (equal buffer "README.org")
              "<p>Return to <a href=\"index.html\">index</a>.</p>"))))

(defvar files
  (list
    (list "site-org"
          :base-directory "."
          :base-extension "org"
          :recursive t
          :publishing-function 'org-html-publish-to-html
          :publishing-directory "./public"
          :auto-sitemap t
          :sitemap-title "Sitemap"
          :sitemap-style 'tree
          :sitemap-sort-files 'alphabetically
          :html-head-include-default-style nil
          :html-head-include-scripts nil
          :html-htmlized-css-url "https://gongzhitaao.org/orgcss/org.css"
          :html-head-extra "<link rel=\"icon\" type=\"image/png\" href=\"img/icon.png\" />\n<link rel=\"stylesheet\" href=\"style.css\" type=\"text/css\" />"
          :html-postamble 'format-postamble
          )
    (list "site-static"
          :base-directory "."
          :exclude (regexp-opt '("public/" "img/design/"))
          :base-extension (regexp-opt '("jpg" "jpeg" "gif" "png" "svg"
                                        "ico" "cur" "css" "js"
                                        "eot" "woff" "woff2" "ttf"
                                        "html" "pdf"))
          :publishing-directory "./public"
          :publishing-function 'org-publish-attachment
          :recursive t)
    (list "site"
          :components '("site-org" "site-static"))
    ))


(let ((org-publish-project-alist       files)
      (org-publish-timestamp-directory "./.timestamps/")
      ;;(user-full-name                  nil) ; avoid "Author: x" at the bottom
      (org-export-with-section-numbers nil)
      (org-export-with-smart-quotes    t)
      (org-export-with-toc             t)
      (org-html-divs '((preamble  "header" "top")
                       (content   "main"   "content")
                       (postamble "footer" "postamble")))
      (org-html-container-element         "section")
      (org-html-metadata-timestamp-format "%Y/%m/%d")
      (org-html-checkbox-type             'html)
      (org-html-html5-fancy               t)
      (org-html-validation-link           nil)
      (org-html-doctype                   "html5")
      (org-html-htmlize-output-type       'css)
      (org-export-headline-levels 6)
      (org-confirm-babel-evaluate nil))
  (org-publish-all))

