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

;; For cl-case:
(require 'cl-macs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Some global settings that these tests assume

;; What to use as a delimiter to determine block boundaries.
(setq text-blocks--block-delimiter " ")

;; What to use as a delimiter to determine block row boundaries.
(setq text-blocks--block-row-delimiter " ")

;; A horizontal gap must have at least this many lines
(setq text-blocks--min-lines-per-horiz-gap 1)

;; A vertical gap must have at least this many columns
(setq text-blocks--min-cols-per-vert-gap 2)

;; End of global settings
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Binding test
;;
(ert-deftest text-blocks--block-boundaries-at-point--000 ()
  "Make sure that text-blocks--block-boundaries-at-point is bound"
  :tags '(
          bindings
          )
  (should
   (fboundp 'text-blocks--block-boundaries-at-point)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; START - Test data
;;

(setq text-blocks--test-metadata
      '((test-id 01 data-file-id 001 position 000 side 'left expect 0)
        (test-id 02 data-file-id 001 position 007 side 'left expect nil)
        (test-id 03 data-file-id 001 position 008 side 'left expect nil)
        (test-id 04 data-file-id 001 position 009 side 'left expect 8)
        (test-id 05 data-file-id 001 position 013 side 'left expect 8)
        (test-id 06 data-file-id 002 position 000 side 'left expect 0)
        (test-id 07 data-file-id 002 position 006 side 'left expect 0)
        (test-id 08 data-file-id 002 position 012 side 'left expect 0)
        (test-id 09 data-file-id 002 position 018 side 'left expect nil)
        (test-id 10 data-file-id 002 position 019 side 'left expect nil)
        (test-id 11 data-file-id 002 position 020 side 'left expect nil)
        (test-id 12 data-file-id 002 position 021 side 'left expect 20)
        (test-id 13 data-file-id 002 position 039 side 'left expect 20)
        (test-id 14 data-file-id 002 position 040 side 'left expect nil)
        (test-id 15 data-file-id 002 position 042 side 'left expect 41)
        (test-id 16 data-file-id 002 position 062 side 'left expect 41)
        (test-id 17 data-file-id 002 position 065 side 'left expect nil)
        (test-id 18 data-file-id 002 position 066 side 'left expect 65)
        (test-id 19 data-file-id 002 position 162 side 'left expect 65)
        (test-id 20 data-file-id 002 position 372 side 'left expect 41)
        (test-id 21 data-file-id 002 position 403 side 'left expect 20)
        (test-id 22 data-file-id 002 position 000 side 'right expect 16)
        (test-id 23 data-file-id 002 position 019 side 'right expect nil)
        (test-id 24 data-file-id 002 position 265 side 'right expect nil)
        (test-id 25 data-file-id 002 position 180 side 'right expect 16)
        (test-id 26 data-file-id 002 position 394 side 'right expect 38)
        (test-id 27 data-file-id 002 position 403 side 'right expect 38)
        (test-id 28 data-file-id 004 position 000 side 'top expect nil)
        (test-id 29 data-file-id 004 position 005 side 'top expect nil)
        (test-id 30 data-file-id 004 position 252 side 'top expect nil)
        (test-id 31 data-file-id 004 position 007 side 'top expect 3)
        (test-id 32 data-file-id 004 position 025 side 'top expect 3)
        (test-id 33 data-file-id 004 position 250 side 'top expect 3)
        (test-id 34 data-file-id 004 position 253 side 'top expect 7)
        (test-id 35 data-file-id 004 position 410 side 'top expect 7)
        (test-id 36 data-file-id 004 position 412 side 'top expect nil)
        (test-id 37 data-file-id 004 position 413 side 'top expect nil)
        (test-id 38 data-file-id 004 position 000 side 'bottom expect nil)
        (test-id 39 data-file-id 004 position 005 side 'bottom expect nil)
        (test-id 40 data-file-id 004 position 252 side 'bottom expect nil)
        (test-id 41 data-file-id 004 position 007 side 'bottom expect 5)
        (test-id 42 data-file-id 004 position 025 side 'bottom expect 5)
        (test-id 43 data-file-id 004 position 250 side 'bottom expect 5)
        (test-id 44 data-file-id 004 position 253 side 'bottom expect 9)
        (test-id 45 data-file-id 004 position 376 side 'bottom expect 9)
        (test-id 46 data-file-id 004 position 412 side 'bottom expect nil)
        (test-id 47 data-file-id 004 position 413 side 'bottom expect nil)
        (test-id 48 data-file-id 'empty position nil side 'left expect nil)
        (test-id 49 data-file-id 'empty position nil side 'right expect nil)
        (test-id 50 data-file-id 'empty position nil side 'top expect nil)
        (test-id 51 data-file-id 'empty position nil side 'bottom expect nil)
        ))

;; * TODO Test with empty buffers
;; * TODO Test with one-character buffers

(setq text-blocks--test-name-prefix
      "text-blocks")
(setq text-blocks--test-buffer-name-prefix "text-blocks--original-data-00")

(setq text-blocks--filename-001 "tests/data/text-blocks-test-001")
(setq text-blocks--filename-002 "tests/data/text-blocks-test-002")
(setq text-blocks--filename-004 "tests/data/text-blocks-test-004")

;; Read in test file 001, if it exists.
(if (file-exists-p text-blocks--filename-001)
    (setq text-blocks--original-data-001
          (find-file-read-only text-blocks--filename-001))
  (error "File '%s' does not exist" text-blocks--filename-001))

(setq default-directory (expand-file-name "../.."))

;; Read in test file 002, if it exists.
(if (file-exists-p text-blocks--filename-002)
    (setq text-blocks--original-data-002
          (find-file-read-only text-blocks--filename-002))
  (error "File '%s' does not exist" text-blocks--filename-002))

(setq default-directory (expand-file-name "../.."))

;; Read in test file 004, if it exists.
(if (file-exists-p text-blocks--filename-004)
    (setq text-blocks--original-data-004
          (find-file-read-only text-blocks--filename-004))
  (error "File '%s' does not exist" text-blocks--filename-004))

;; END - Test data
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; START - Automated test generation
;;

(defun text-blocks--create-test-name (test-metadata-element)
  "Generate test names like foo-001, foo-002, etc.."
  (let* ((test-id (plist-get test-metadata-element 'test-id))
         (data-file-id (plist-get test-metadata-element 'data-file-id))
         (position (plist-get test-metadata-element 'position))
         (side (plist-get test-metadata-element 'side))
         (expect (plist-get test-metadata-element 'expect)))
    (cond
     ((equal
       (type-of data-file-id)
       'integer)
      (intern
       (format
        "%s--%03d-file-%s-pos-%03d-side-%s-expect-%s"
        text-blocks--test-name-prefix
        test-id
        data-file-id
        position
        side
        expect)))
     ((equal
       (type-of data-file-id)
       'cons)
      (if (equal (cadr data-file-id) 'empty)
          (intern
           (format
            "%s--%03d-file-empty-side-%s-expect-%s"
            text-blocks--test-name-prefix
            test-id
            side
            expect))
         (error
          "Error: Unexpected data-file-id %s"
          data-file-id)))
     (t (error
          "Error: Unexpected type %s for data-file-id %s"
          (type-of data-file-id)
          data-file-id)))))

(defun text-blocks--get-test-body (test-metadata-element)
  (let* ((test-id (plist-get test-metadata-element 'test-id))
         (data-file-id (plist-get test-metadata-element 'data-file-id))
         (side (plist-get test-metadata-element 'side))
         (position (plist-get test-metadata-element 'position))
         (expect (plist-get test-metadata-element 'expect))
         (data-file-buffer-name (get-data-file-buffer-name data-file-id)))
    (if (and
         (equal (type-of data-file-id) 'cons)
         (equal (cadr data-file-id) 'empty))
        `(lambda ()
           (let ((result
                  (with-temp-buffer
                    (text-blocks--block-boundaries-at-point ,side))))
             (if (equal result ,expect)
                 (ert-pass)
               (ert-fail
                (print
                 (format
                  (concat
                   "In an empty buffer, with side '%s', "
                   "expected '%s' but got '%s'")
                  ,side
                  ,expect
                  result))))))
      `(lambda ()
         (let ((result
                (with-temp-buffer
                  (replace-buffer-contents
                   ,data-file-buffer-name)
                  (goto-char ,position)
                  (text-blocks--block-boundaries-at-point ,side))))
           (if (equal result ,expect)
               (ert-pass)
             (ert-fail
              (print
               (format
                (concat
                 "At position '%s' in file '%s', with side '%s', "
                 "expected '%s' but got '%s'")
                ,position
                ,data-file-id
                ,side
                ,expect
                result)))))))))

;; These tests should all pass
(cl-loop
 for test-metadata-element in text-blocks--test-metadata
 do (let* ((name (text-blocks--create-test-name
                  test-metadata-element)))
      (ert-set-test
       name
       (make-ert-test
        :expected-result-type :passed
        :name name
        :body (text-blocks--get-test-body
               test-metadata-element)))))

;; END - Automated test generation
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; ;; 'left with data 001
;; ;;
;; (ert-deftest text-blocks--block-boundaries-at-point--002 ()
;;   "Finds the left boundary of column block in data 001 with point at 0"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-001)
;;       (goto-char 0)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     0)))

;; (ert-deftest text-blocks--block-boundaries-at-point--003 ()
;;   "No column block boundaries in data 001 with point at 7"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-001)
;;      (goto-char 7)
;;      (text-blocks--block-boundaries-at-point 'left))))

;; (ert-deftest text-blocks--block-boundaries-at-point--004 ()
;;   "No column block boundaries in data 001 with point at 8"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-001)
;;      (goto-char 8)
;;      (text-blocks--block-boundaries-at-point 'left))))

;; (ert-deftest text-blocks--block-boundaries-at-point--005 ()
;;   "Finds the left boundaries of column block in data 001 with point at 9"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-001)
;;       (goto-char 9)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     8)))

;; (ert-deftest text-blocks--block-boundaries-at-point--006 ()
;;   "Finds the left boundaries of column block in data 001 with point at 13"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-001)
;;       (goto-char 13)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     8)))
;; ;;
;; ;; END - 'left with data 001
;; ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; ;; 'left with data 002
;; ;;
;; (ert-deftest text-blocks--block-boundaries-at-point--007 ()
;;   "Finds the left boundaries of column block in data 002 with point at 0"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 0)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     0)))

;; (ert-deftest text-blocks--block-boundaries-at-point--008 ()
;;   "Finds the left boundaries of column block in data 002 with point at 6"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 6)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     0)))

;; (ert-deftest text-blocks--block-boundaries-at-point--008 ()
;;   "Finds the left boundaries of column block in data 002 with point at 12"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 12)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     0)))

;; (ert-deftest text-blocks--block-boundaries-at-point--009 ()
;;   "No column block boundaries in data 002 with point at 18"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-002)
;;      (goto-char 18)
;;      (text-blocks--block-boundaries-at-point 'left))))

;; (ert-deftest text-blocks--block-boundaries-at-point--010 ()
;;   "No column block boundaries in data 002 with point at 19"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-002)
;;      (goto-char 19)
;;      (text-blocks--block-boundaries-at-point 'left))))

;; (ert-deftest text-blocks--block-boundaries-at-point--011 ()
;;   "No column block boundaries in data 002 with point at 20"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-002)
;;      (goto-char 20)
;;      (text-blocks--block-boundaries-at-point 'left))))

;; (ert-deftest text-blocks--block-boundaries-at-point--012 ()
;;   "Finds the left boundaries of column block in data 002 with point at 21"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 21)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     20)))

;; (ert-deftest text-blocks--block-boundaries-at-point--013 ()
;;   "Finds the left boundaries of column block in data 002 with point at 39"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 39)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     20)))

;; (ert-deftest text-blocks--block-boundaries-at-point--014 ()
;;   "No column block boundaries in data 002 with point at 40"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-002)
;;      (goto-char 40)
;;      (text-blocks--block-boundaries-at-point 'left))))

;; (ert-deftest text-blocks--block-boundaries-at-point--015 ()
;;   "Finds the left boundaries of column block in data 002 with point at 42"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 42)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     41)))

;; (ert-deftest text-blocks--block-boundaries-at-point--016 ()
;;   "Finds the left boundaries of column block in data 002 with point at 62"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 62)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     41)))

;; (ert-deftest text-blocks--block-boundaries-at-point--017 ()
;;   "No column block boundaries in data 002 with point at 65"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-002)
;;      (goto-char 65)
;;      (text-blocks--block-boundaries-at-point 'left))))

;; (ert-deftest text-blocks--block-boundaries-at-point--018 ()
;;   "Finds the left boundaries of column block in data 002 with point at 66"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 66)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     65)))

;; (ert-deftest text-blocks--block-boundaries-at-point--019 ()
;;   "Finds the left boundaries of column block in data 002 with point at 162"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 162)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     65)))

;; (ert-deftest text-blocks--block-boundaries-at-point--020 ()
;;   "Finds the left boundaries of column block in data 002 with point at 372"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 372)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     41)))

;; (ert-deftest text-blocks--block-boundaries-at-point--021 ()
;;   "Finds the left boundaries of column block in data 002 with point at 403"
;;   :tags '(
;;           left-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 403)
;;       (text-blocks--block-boundaries-at-point 'left))
;;     20)))

;; ;; END - 'left with data 002
;; ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; ;; 'right with data 002
;; ;;
;; (ert-deftest text-blocks--block-boundaries-at-point--021 ()
;;   "Finds the right boundary of column block in data 002 with point at 0"
;;   :tags '(
;;           right-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 0)
;;       (text-blocks--block-boundaries-at-point 'right))
;;     16)))

;; (ert-deftest text-blocks--block-boundaries-at-point--022 ()
;;   "No column block boundaries in data 002 with point at 19"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-002)
;;      (goto-char 19)
;;      (text-blocks--block-boundaries-at-point 'right))))

;; (ert-deftest text-blocks--block-boundaries-at-point--023 ()
;;   "No column block boundaries in data 002 with point at 265"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-002)
;;      (goto-char 265)
;;      (text-blocks--block-boundaries-at-point 'right))))

;; (ert-deftest text-blocks--block-boundaries-at-point--024 ()
;;   "Finds the right boundaries of column block in data 002 with point at 180"
;;   :tags '(
;;           right-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 180)
;;       (text-blocks--block-boundaries-at-point 'right))
;;     16)))

;; (ert-deftest text-blocks--block-boundaries-at-point--025 ()
;;   "Finds the right boundaries of column block in data 002 with point at 394"
;;   :tags '(
;;           right-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 394)
;;       (text-blocks--block-boundaries-at-point 'right))
;;     38)))

;; (ert-deftest text-blocks--block-boundaries-at-point--026 ()
;;   "Finds the right boundaries of column block in data 002 with point at 403"
;;   :tags '(
;;           right-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-002)
;;       (goto-char 403)
;;       (text-blocks--block-boundaries-at-point 'right))
;;     38)))

;; ;;
;; ;; END - 'right with data 002
;; ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; ;; Tests to make sure this function errors out with 'left and 'right
;; ;; when called on an empty buffer
;; ;;

;; (ert-deftest text-blocks--block-boundaries-at-point--027 ()
;;   "'left errors out on an empty buffer"
;;   :tags '(
;;           error
;;           out-of-bounds
;;           invalid-argument
;;           )
;;   (should-error
;;    (with-temp-buffer
;;      (text-blocks--block-boundaries-at-point 'left))))

;; (ert-deftest text-blocks--block-boundaries-at-point--028 ()
;;   "'right errors out on an empty buffer"
;;   :tags '(
;;           error
;;           out-of-bounds
;;           invalid-argument
;;           )
;;   (should-error
;;    (with-temp-buffer
;;      (text-blocks--block-boundaries-at-point 'right))))

;; ;;
;; ;; END - Tests to make sure this function errors out with 'left and 'right
;; ;;       when called on an empty buffer
;; ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; ;; 'top with data 004
;; ;;
;; (ert-deftest text-blocks--block-boundaries-at-point--029 ()
;;   "No column block boundaries in data 004 with point at 0"
;;   :tags '(
;;           top-boundary
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-004)
;;      (goto-char 0)
;;      (text-blocks--block-boundaries-at-point 'top))))

;; (ert-deftest text-blocks--block-boundaries-at-point--030 ()
;;   "No column block boundaries in data 004 with point at 5"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-004)
;;      (goto-char 5)
;;      (text-blocks--block-boundaries-at-point 'top))))

;; (ert-deftest text-blocks--block-boundaries-at-point--031 ()
;;   "No column block boundaries in data 004 with point at 252"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-004)
;;      (goto-char 252)
;;      (text-blocks--block-boundaries-at-point 'top))))

;; (ert-deftest text-blocks--block-boundaries-at-point--032 ()
;;   "Finds the top boundaries of column block in data 004 with point at 7"
;;   :tags '(
;;           top-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-004)
;;       (goto-char 7)
;;       (text-blocks--block-boundaries-at-point 'top))
;;     3)))

;; (ert-deftest text-blocks--block-boundaries-at-point--033 ()
;;   "Finds the top boundaries of column block in data 004 with point at 25"
;;   :tags '(
;;           top-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-004)
;;       (goto-char 25)
;;       (text-blocks--block-boundaries-at-point 'top))
;;     3)))

;; (ert-deftest text-blocks--block-boundaries-at-point--034 ()
;;   "Finds the top boundaries of column block in data 004 with point at 250"
;;   :tags '(
;;           top-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-004)
;;       (goto-char 250)
;;       (text-blocks--block-boundaries-at-point 'top))
;;     3)))

;; (ert-deftest text-blocks--block-boundaries-at-point--035 ()
;;   "Finds the top boundaries of column block in data 004 with point at 253"
;;   :tags '(
;;           top-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-004)
;;       (goto-char 253)
;;       (text-blocks--block-boundaries-at-point 'top))
;;     7)))

;; (ert-deftest text-blocks--block-boundaries-at-point--036 ()
;;   "Finds the top boundaries of column block in data 004 with point at 376"
;;   :tags '(
;;           top-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-004)
;;       (goto-char 376)
;;       (text-blocks--block-boundaries-at-point 'top))
;;     7)))

;; (ert-deftest text-blocks--block-boundaries-at-point--037 ()
;;   "No column block boundaries in data 004 with point at 412"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-004)
;;      (goto-char 412)
;;      (text-blocks--block-boundaries-at-point 'top))))

;; (ert-deftest text-blocks--block-boundaries-at-point--038 ()
;;   "No column block boundaries in data 004 with point at 413"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-004)
;;      (goto-char 413)
;;      (text-blocks--block-boundaries-at-point 'top))))

;; (ert-deftest text-blocks--block-boundaries-at-point--039 ()
;;   "No column block boundaries in data 004 with empty buffer"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (text-blocks--block-boundaries-at-point 'top))))

;; (ert-deftest text-blocks--block-boundaries-at-point--040 ()
;;   "Finds the top boundaries of column block buffer with one character"
;;   :tags '(
;;           top-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (insert "a")
;;       (text-blocks--block-boundaries-at-point 'top))
;;     1)))

;; ;;
;; ;; END - 'top with data 004
;; ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;
;; ;; 'bottom with data 004
;; ;;
;; (ert-deftest text-blocks--block-boundaries-at-point--041 ()
;;   "No column block boundaries in data 004 with point at 0"
;;   :tags '(
;;           bottom-boundary
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-004)
;;      (goto-char 0)
;;      (text-blocks--block-boundaries-at-point 'bottom))))

;; (ert-deftest text-blocks--block-boundaries-at-point--042 ()
;;   "No column block boundaries in data 004 with point at 5"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-004)
;;      (goto-char 5)
;;      (text-blocks--block-boundaries-at-point 'bottom))))

;; (ert-deftest text-blocks--block-boundaries-at-point--043 ()
;;   "No column block boundaries in data 004 with point at 252"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-004)
;;      (goto-char 252)
;;      (text-blocks--block-boundaries-at-point 'bottom))))

;; (ert-deftest text-blocks--block-boundaries-at-point--043 ()
;;   "Finds the bottom boundaries of column block in data 004 with point at 7"
;;   :tags '(
;;           bottom-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-004)
;;       (goto-char 7)
;;       (text-blocks--block-boundaries-at-point 'bottom))
;;     5)))

;; (ert-deftest text-blocks--block-boundaries-at-point--044 ()
;;   "Finds the bottom boundaries of column block in data 004 with point at 25"
;;   :tags '(
;;           bottom-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-004)
;;       (goto-char 25)
;;       (text-blocks--block-boundaries-at-point 'bottom))
;;     5)))

;; (ert-deftest text-blocks--block-boundaries-at-point--045 ()
;;   "Finds the bottom boundaries of column block in data 004 with point at 250"
;;   :tags '(
;;           bottom-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-004)
;;       (goto-char 250)
;;       (text-blocks--block-boundaries-at-point 'bottom))
;;     5)))

;; (ert-deftest text-blocks--block-boundaries-at-point--046 ()
;;   "Finds the bottom boundaries of column block in data 004 with point at 253"
;;   :tags '(
;;           bottom-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-004)
;;       (goto-char 253)
;;       (text-blocks--block-boundaries-at-point 'bottom))
;;     9)))

;; (ert-deftest text-blocks--block-boundaries-at-point--047 ()
;;   "Finds the bottom boundaries of column block in data 004 with point at 376"
;;   :tags '(
;;           bottom-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (replace-buffer-contents text-blocks--original-data-004)
;;       (goto-char 376)
;;       (text-blocks--block-boundaries-at-point 'bottom))
;;     9)))

;; (ert-deftest text-blocks--block-boundaries-at-point--048 ()
;;   "No column block boundaries in data 004 with point at 412"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-004)
;;      (goto-char 412)
;;      (text-blocks--block-boundaries-at-point 'bottom))))

;; (ert-deftest text-blocks--block-boundaries-at-point--049 ()
;;   "No column block boundaries in data 004 with point at 413"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (replace-buffer-contents text-blocks--original-data-004)
;;      (goto-char 413)
;;      (text-blocks--block-boundaries-at-point 'bottom))))

;; (ert-deftest text-blocks--block-boundaries-at-point--050 ()
;;   "No column block boundaries in data 004 with empty buffer"
;;   :tags '(
;;           not-delimiter-column
;;           )
;;   (should-not
;;    (with-temp-buffer
;;      (text-blocks--block-boundaries-at-point 'bottom))))

;; (ert-deftest text-blocks--block-boundaries-at-point--051 ()
;;   "Finds the bottom boundaries of column block buffer with one character"
;;   :tags '(
;;           bottom-boundary
;;           )
;;   (should
;;    (equal
;;     (with-temp-buffer
;;       (insert "a")
;;       (text-blocks--block-boundaries-at-point 'bottom))
;;     1)))

;;
;; END - 'bottom with data 004
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'text-blocks--block-boundaries-at-point)
