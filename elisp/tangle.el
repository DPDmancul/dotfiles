(require 'org)
(require 'ob-tangle)

(let ((org-confirm-babel-evaluate nil)
      (files command-line-args-left))
  (dolist (file files)
    (with-current-buffer (find-file-noselect file)
                         (org-babel-tangle))))

