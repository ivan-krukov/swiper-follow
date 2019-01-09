;;; swiper-follow.el --- Follow trough on swiper search results -*- lexical-binding: t -*-

;; Author: Ivan Krukov
;; Maintainer: Ivan Krukov
;; Version: 0.0
;; Package-Requires: (swiper)
;; Homepage: homepage
;; Keywords: matching


;; This file is not part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; Follow to the next/previous swiper match without invoking swiper again.
;; Provides two functions:
;; `swiper-follow-forward' jumps to the next swiper match
;; `swiper-follow-backward' jumpts to the previous swiper match
;; The match and the matching line will be highlighted for `swiper-follow-timeout' seconds

;;; Code:

(require 'swiper)

(defgroup swiper-follow nil
  "`swiper' hacks"
  :group 'matching
  :prefix "swiper-follow-")

(defcustom swiper-follow-timeout 0.5
  "Highlight time of the search results, in seconds"
  :type 'float)

(defvar swiper-follow--highlight-timer (run-at-time nil nil (lambda ())))

(defun timer-get-function (timer)
  (elt timer 5))

(defun timer-actualize (timer)
  (let ((fun (timer-get-function timer)))
    (cancel-timer timer)
    (funcall fun)))

(defun swiper-follow (search-f)
  (let* ((swiper-last (car swiper-history)))
    (timer-actualize swiper-follow--highlight-timer)
    (funcall search-f swiper-last nil t)
    (swiper--add-overlays swiper-last)
    (setq swiper-follow--highlight-timer
	  (run-at-time (format "%f sec" swiper-follow-timeout) nil 'swiper--cleanup))))

;;;###autoload
(defun swiper-follow-forward () (interactive)
       (swiper-follow 'search-forward))

;;;###autoload
(defun swiper-follow-backward () (interactive)
       (swiper-follow 'search-backward))

(provide 'swiper-follow)

;;; swiper-follow.el ends here
