;;; -*- lexical-binding: t -*-
;;
;; Copyright (C) 2020 - Sergey Goldgaber
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.
;;
;; You should have received a copy of the GNU Affero General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(add-to-list 'load-path "tests")

(require 'text-blocks)
(require 'text-blocks--test-common)

(ert-deftest text-blocks--001--horizontal-gap-p--is-bound ()
  "Make sure that text-blocks--horizontal-gap-p is bound"
  :tags '(
          bindings
          )
  (should
   (fboundp 'text-blocks--horizontal-gap-p)))

(setq text-blocks--filename-004 "tests/data/text-blocks-test-004")

(setq text-blocks--test-name-prefix
      "text-blocks")
(setq text-blocks--test-buffer-name-prefix "text-blocks--original-data")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Some global settings that these tests assume

;; What character vertical gaps are made of.
(setq text-blocks--vertical-gap-delimiter " ")

;; What character horizontal gaps are made of.
(setq text-blocks--horizontal-gap-delimiter " ")

;; A horizontal gap must have at least this many lines
(setq text-blocks--min-lines-per-horiz-gap 1)

;; A vertical gap must have at least this many columns
(setq text-blocks--min-cols-per-vert-gap 2)

;; End of global settings
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Tests that need to be written manually
;;

(ert-deftest text-blocks--002--horizontal-gap-p ()
  "Point in an empty buffer is on a horizontal gap"
  :tags '(
          horizontal-gap
          )
  (should
   (with-temp-buffer
     (text-blocks--horizontal-gap-p))))

;;
;; End of tests that need to be written manually
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Automatic test generation functions
;;

(defun text-blocks--create-test-name
    (text-blocks--test-metadata-element)
  "Generate test names like foo-001, foo-002, etc.."
  (let* ((test-id (plist-get text-blocks--test-metadata-element 'test-id))
         (data-file-id (plist-get text-blocks--test-metadata-element 'data-file-id))
         (position (plist-get text-blocks--test-metadata-element 'position))
         (line (plist-get text-blocks--test-metadata-element 'line))
         (expect (plist-get text-blocks--test-metadata-element 'expect))
         (expect
          (pcase expect
           (`(,_ horizontal-gap) "horizontal-gap")
           (`(,_ not-horizontal-gap) "not-horizontal-gap")
           (`(,_ error) "error")
           (_ (error
               (format
                (concat
                 "text-blocks--create-test-name: "
                 "Error: "
                 "unexpected 'expect' value '%s'")
                expect)))))
         (position-or-line-string
          (cond
           (position "pos")
           (line "line")
           (t (error
               (format
                (concat
                 "text-blocks--create-test-name: "
                 "Error: "
                 "Could not find a position or line in test metadata")))))))
    (intern
     (format
      "%s--%03d-file-%s-%s-%03d-expect-%s"
      text-blocks--test-name-prefix
      test-id
      data-file-id
      position-or-line-string
      (if position
          position
        line)
      expect))))

;; Automated generation of test bodies
(defun text-blocks--get-test-body
    (text-blocks--test-metadata-element)
  (let* ((test-id (plist-get text-blocks--test-metadata-element 'test-id))
         (data-file-id (plist-get text-blocks--test-metadata-element 'data-file-id))
         (position (plist-get text-blocks--test-metadata-element 'position))
         (line (plist-get text-blocks--test-metadata-element 'line))
         (expect (plist-get text-blocks--test-metadata-element 'expect))
         (data-file-buffer-name
          (get-data-file-buffer-name data-file-id)))
    `(lambda ()
       (let ((horizontal-gap-test-result
              (with-temp-buffer
                (replace-buffer-contents
                 ,data-file-buffer-name)
                (if (equal ,expect 'error)
                    (should-error
                     (cond
                      (,position
                       (progn
                         (goto-char ,position)
                         (text-blocks--horizontal-gap-p)))
                      (,line (text-blocks--horizontal-gap-p ,line))
                      (t
                       (ert-fail
                        (print
                         (format
                          "Expected a line or a position, but found neither"))))))
                  (cond
                   (,position
                    (progn
                      (goto-char ,position)
                      (text-blocks--horizontal-gap-p)))
                   (,line (text-blocks--horizontal-gap-p ,line))
                   (t
                    (ert-fail
                     (print
                      (format
                       "Expected a line or a position, but found neither")))))))))
         (pcase horizontal-gap-test-result
          ('t
           (pcase ,expect
            ('horizontal-gap (ert-pass))
            ('not-horizontal-gap
             (ert-fail
              (print
               (format
                "At %s '%s' in file '%s' expected non-gap but got gap"
                (if ,position
                    "position"
                  "line")
                (if ,position
                    ,position
                  ,line)
                ,data-file-id))))))
          ('nil
           (pcase ,expect
            ('not-horizontal-gap (ert-pass))
            ('horizontal-gap
             (ert-fail
              (print
               (format
                "At %s '%s' in file '%s' expected gap but got not-gap"
                (if ,position
                    "position"
                  "line")
                (if ,position
                    ,position
                  ,line)
                ,data-file-id))))))
          ;; Expected errors should pass
          ;;
          ;; On error, ERT's should-error returns a cons pair
          ;; containing 'error as the first element,
          ;; so if we are expecting an error, we check for that
          ((and
            (guard (equal ,expect 'error))
            `(error ,_))
           (ert-pass))
          ;; Everything else fails
          ('otherwise
           (ert-fail
            (print
             (format
              "Unexpected test result '%s'.  This should always be t or nil."
              horizontal-gap-test-result)))))))))

;;
;; End of automatic test generation functions
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Automatically generated tests - 01
;;

(setq text-blocks--test-metadata
      '((test-id 03 data-file-id 004 position 001 expect 'horizontal-gap)
        (test-id 04 data-file-id 004 position 004 expect 'horizontal-gap)
        (test-id 05 data-file-id 004 position 007 expect 'not-horizontal-gap)
        (test-id 06 data-file-id 004 position 250 expect 'not-horizontal-gap)
        (test-id 07 data-file-id 004 position 252 expect 'horizontal-gap)
        (test-id 08 data-file-id 004 position 253 expect 'not-horizontal-gap)
        (test-id 09 data-file-id 004 position 412 expect 'horizontal-gap)
        (test-id 10 data-file-id 004 line 01 expect 'horizontal-gap)
        (test-id 11 data-file-id 004 line 02 expect 'horizontal-gap)
        (test-id 12 data-file-id 004 line 03 expect 'not-horizontal-gap)
        (test-id 13 data-file-id 004 line 05 expect 'not-horizontal-gap)
        (test-id 14 data-file-id 004 line 06 expect 'horizontal-gap)
        (test-id 15 data-file-id 004 line 07 expect 'not-horizontal-gap)
        (test-id 16 data-file-id 004 line 10 expect 'horizontal-gap)
        (test-id 17 data-file-id 004 line 11 expect 'horizontal-gap)
        (test-id 18 data-file-id 004 line 12 expect 'error)
        (test-id 19 data-file-id 004 line 00 expect 'error)
        (test-id 20 data-file-id 004 line -1 expect 'error)))

;; Read in test file 004, if it exists.
(if (file-exists-p text-blocks--filename-004)
    (setq text-blocks--original-data-004
          (find-file-read-only text-blocks--filename-004))
  (error "File '%s' does not exist" text-blocks--filename-004))

;; Automatic test generation
(cl-loop
 for text-blocks--test-metadata-element in text-blocks--test-metadata
 do (let* ((name (text-blocks--create-test-name
                  text-blocks--test-metadata-element))
           (expect (plist-get text-blocks--test-metadata-element 'expect)))
      (ert-set-test
       name
       (make-ert-test
        :expected-result-type (if (equal expect 'error)
                                  :error
                                :passed)
        :name name
        :body (text-blocks--get-test-body
               text-blocks--test-metadata-element)))))

;;
;; End of automatically generated tests - 01
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'text-blocks--horizontal-gap-p)
