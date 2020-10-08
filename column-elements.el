;;; -*- lexical-binding: t -*-
;;------------------------------------------------------------------------
;;
;; * column-elements - Manipulate elements in columns
;;
;; This package will let you move, insert, delete, yank, and kill elements
;; in columns, and have the other elements automatically move aside or fill
;; in gaps as needed.
;;
;; See column-elements.org for details.

;; What to use as a delimiter to determine column block boundaries.
(defvar column-elements--delimiter " ")

(require 'cl-macs)

(defun column-elements--column-block-boundaries-at-point (&optional side)
  "Return the 'left, 'right, or 'both boundaries of
the column block at point."
  (when (equal side nil)
    (error
     (format
      (concat
       "column-elements--column-block-boundaries-at-point: "
       "No arguments given.  "
       "This function must be called with either: 'left or 'right")
      side)))
  (if (equal (column-elements--gap-column-p) nil)
      (cond
       ((equal side 'left)
        (cl-loop
         with start-column = (current-column)
         with left-most-column = 0
         with left-boundary-of-this-column-block = start-column
         for this-column from start-column downto left-most-column
         if (equal
             (column-elements--gap-column-p-aux this-column)
             nil)
         do (setq left-boundary-of-this-column-block this-column)
         else return left-boundary-of-this-column-block
         finally return left-boundary-of-this-column-block))
       ((equal side 'right)
        (cl-loop
         with start-column = (current-column)
         with right-most-column = (column-elements--get-buffer-width)
         with right-boundary-of-this-column-block = start-column
         for this-column from start-column upto right-most-column
         if (equal
             (column-elements--gap-column-p-aux this-column)
             nil)
         do (setq right-boundary-of-this-column-block this-column)
         else return right-boundary-of-this-column-block
         finally return right-boundary-of-this-column-block))
       (t
        (error
         (format
          (concat
          "column-elements--column-block-boundaries-at-point: "
          "Invalid argument '%s'.  "
          "Valid arguments are: 'left, 'right")
          side))))
    nil))

(defun column-elements--gap-column-p-aux (column)
  "Returns t if `COLUMN' contains only delimiters,
otherwise returns nil."
  (when (< column 0)
    (error
     "column-elements--gap-column-p-aux: Error: COLUMN must not be < 0"))
                                        ; Detect empty buffers
  (if (equal
       (point-min)
       (point-max))
      ;; Empty buffer
      (error "column-elements--gap-column-p-aux: Error: Empty buffer detected.")
    ;; Not empty buffer
    (save-excursion
      (save-restriction
        (goto-char (point-min))
        (not
         (condition-case nil
             (re-search-forward
              (rx-to-string
               `(seq
                 line-start
                 (= ,column anychar)
                 (not
                  (any ,column-elements--delimiter)))))
           (search-failed nil)))))))

(defun column-elements--gap-column-p (&optional column)
  "Returns t if the column at point contains only delimiters,
otherwise returns nil."
  (interactive)
  (let* ((column
          (if (equal column nil)
              (current-column)
            column))
         (current-column-is-a-gap-column
          (column-elements--gap-column-p-aux column)))
    (when (called-interactively-p 'interactive)
      (message
       (format "%s" current-column-is-a-gap-column)))
    current-column-is-a-gap-column))

(defun column-elements--gap-line-p (&optional desired-line)
  "Returns t if the line at point or `desired-line' is empty
or contains only delimiters, otherwise returns nil."
  (interactive)
  (let ((desired-line
         (if (equal desired-line nil)
             (line-number-at-pos)
           desired-line)))
    (save-excursion
      (save-restriction
        (goto-char (point-min))
        (forward-line (- desired-line 1))
        (let ((current-line
               (line-number-at-pos)))
          (if (not (equal
                    current-line
                    desired-line))
              (error "column-elements--gap-line-p: Error: line outside of buffer.")
            (cond
             ;; An empty line:
             ((equal (line-beginning-position) (line-end-position))
              t)
             ;; A line containing just delimiter chars:
             ((looking-at-p
               (rx-to-string
                `(seq
                  line-start
                  (one-or-more ,column-elements--delimiter)
                  line-end)))
              t)
             ;; Not an empty line, nor a line containing just delimiter chars:
             (t
              nil))))))))

(defun column-elements--get-buffer-width ()
  "Returns the buffer width in columns."
  (save-excursion
    (save-restriction
      (goto-char (point-min))
      (if (eobp)
          ;; Empty buffer contains 0 columns
          0
        ;; Not an empty buffer
        (cl-loop
         with buffer-width = (- (line-end-position) (line-beginning-position) 1)
         do (progn
              (forward-line)
              (if (eobp)
                  buffer-width
                (let ((current-line-width
                       (- (line-end-position) (line-beginning-position) 1)))
                  (when (> current-line-width buffer-width)
                    (setq buffer-width current-line-width)))))
         until (eobp)
         maximize buffer-width
         finally return buffer-width)))))

;;
;;------------------------------------------------------------------------

(provide 'column-elements)
