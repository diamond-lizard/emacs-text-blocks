;;; -*- lexical-binding: t -*-

(require 'column-elements)

(ert-deftest column-elements--gap-line-p--001 ()
  "Make sure that column-elements--gap-line-p is bound"
  :tags '(
          bindings
          )
  (should
   (fboundp 'column-elements--gap-line-p)))

(setq column-elements--filename-004 "tests/data/column-elements-test-004")

;; Read in test file 004, if it exists.
(if (file-exists-p column-elements--filename-004)
    (setq column-elements--original-data-004
          (find-file-read-only column-elements--filename-004))
  (error "File '%s' does not exist" column-elements--filename-004))


(ert-deftest column-elements--gap-line-p--002 ()
  "position 1 in data/004 is on a gap line"
  :tags '(
          gap-line
          )
  (should
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (goto-char 1)
     (column-elements--gap-line-p))))

(ert-deftest column-elements--gap-line-p--003 ()
  "position 4 in data/004 is on a gap line"
  :tags '(
          gap-line
          )
  (should
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (goto-char 4)
     (column-elements--gap-line-p))))

(ert-deftest column-elements--gap-line-p--004 ()
  "position 7 in data/004 is not on a gap line"
  :tags '(
          not-gap-line
          )
  (should-not
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (goto-char 7)
     (column-elements--gap-line-p))))

(ert-deftest column-elements--gap-line-p--005 ()
  "position 250 in data/004 is not on a gap line"
  :tags '(
          not-gap-line
          )
  (should-not
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (goto-char 250)
     (column-elements--gap-line-p))))

(ert-deftest column-elements--gap-line-p--006 ()
  "position 252 in data/004 is on a gap line"
  :tags '(
          gap-line
          )
  (should
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (goto-char 252)
     (column-elements--gap-line-p))))

(ert-deftest column-elements--gap-line-p--007 ()
  "position 253 in data/004 is not on a gap line"
  :tags '(
          not-gap-line
          )
  (should-not
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (goto-char 253)
     (column-elements--gap-line-p))))

(ert-deftest column-elements--gap-line-p--008 ()
  "position 412 in data/004 is on a gap line"
  :tags '(
          gap-line
          )
  (should
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (goto-char 412)
     (column-elements--gap-line-p))))

(ert-deftest column-elements--gap-line-p--009 ()
  "line 1 in data/004 is a gap line"
  :tags '(
          gap-line
          )
  (should
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (column-elements--gap-line-p 1))))

(ert-deftest column-elements--gap-line-p--010 ()
  "line 2 in data/004 is a gap line"
  :tags '(
          gap-line
          )
  (should
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (column-elements--gap-line-p 2))))

(ert-deftest column-elements--gap-line-p--011 ()
  "line 3 in data/004 is not a gap line"
  :tags '(
          not-gap-line
          )
  (should-not
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (column-elements--gap-line-p 3))))

(ert-deftest column-elements--gap-line-p--012 ()
  "line 5 in data/004 is not a gap line"
  :tags '(
          not-gap-line
          )
  (should-not
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (column-elements--gap-line-p 5))))

(ert-deftest column-elements--gap-line-p--013 ()
  "line 6 in data/004 is a gap line"
  :tags '(
          gap-line
          )
  (should
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (column-elements--gap-line-p 6))))

(ert-deftest column-elements--gap-line-p--014 ()
  "line 7 in data/004 is not a gap line"
  :tags '(
          not-gap-line
          )
  (should-not
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (column-elements--gap-line-p 7))))

(ert-deftest column-elements--gap-line-p--015 ()
  "line 10 in data/004 is a gap line"
  :tags '(
          gap-line
          )
  (should
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (column-elements--gap-line-p 10))))

(ert-deftest column-elements--gap-line-p--016 ()
  "line 11 in data/004 is a gap line"
  :tags '(
          gap-line
          )
  (should
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (column-elements--gap-line-p 11))))

(ert-deftest column-elements--gap-line-p--017 ()
  "Trying to check whether line 12 is a gap line should error"
  :tags '(
          gap-line
          )
  (should-error
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (column-elements--gap-line-p 12))))

(ert-deftest column-elements--gap-line-p--018 ()
  "Trying to check whether line 0 is a gap line should error"
  :tags '(
          gap-line
          )
  (should-error
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (column-elements--gap-line-p 0))))

(ert-deftest column-elements--gap-line-p--017 ()
  "Trying to check whether line -1 is a gap line should error"
  :tags '(
          gap-line
          )
  (should-error
   (with-temp-buffer
     (replace-buffer-contents column-elements--original-data-004)
     (column-elements--gap-line-p -1))))

(ert-deftest column-elements--gap-line-p--018 ()
  "Point in an empty buffer is on a gap line"
  :tags '(
          gap-line
          )
  (should
   (with-temp-buffer
     (column-elements--gap-line-p))))

(provide 'column-elements--gap-line-p)