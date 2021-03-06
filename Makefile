# Copyright (C) 2020 - Sergey Goldgaber
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


EMACS := emacs
ELISP_FILES := $(shell ls *.el | grep -v -- '-pkg\.el$$')
TEST_DIR := tests

TESTS :=
TESTS += text-blocks--search-for-consecutive-non-nils
TESTS += text-blocks--get-buffer-width
TESTS += text-blocks--get-number-of-last-line-in-buffer
TESTS += text-blocks--horizontal-gap-p
TESTS += text-blocks--horizontal-gap-p-02
TESTS += text-blocks--horizontal-gap-p-03
TESTS += text-blocks--line-number-of-longest-line
TESTS += text-blocks--vertical-gap-p
TESTS += text-blocks--vertical-gap-p-02
TESTS += text-blocks--vertical-gap-p-03
TESTS += text-blocks--vertical-gap-p-04
TESTS += text-blocks--vertical-gap-p-05
TESTS += text-blocks--vertical-gap-p-06
TESTS += text-blocks--vertical-gap-column-p
TESTS += text-blocks--vertical-gap-column-p-02
TESTS += text-blocks--vertical-gap-column-p-03
TESTS += text-blocks--row-of-blocks-boundaries-at-point-01
TESTS += text-blocks--block-boundaries-at-point
TESTS += text-blocks--block-boundaries-at-point-02

EMACS_ERT_ARGS_1 := -batch -l ert -L . -l
EMACS_ERT_ARGS_2 := -f ert-run-tests-batch-and-exit

.PHONY: clean
.PHONY: test

all: clean test

compile: $(patsubst %.el,%.elc,$(ELISP_FILES))

%.elc: %.el
	$(EMACS) -batch -L . -f batch-byte-compile $<

test: $(TESTS)

text-blocks--block-boundaries-at-point: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--block-boundaries-at-point-02: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--get-buffer-width: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--get-number-of-last-line-in-buffer: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--horizontal-gap-p: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--horizontal-gap-p-02: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--horizontal-gap-p-03: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--line-number-of-longest-line: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--row-of-blocks-boundaries-at-point-01: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--search-for-consecutive-non-nils: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--vertical-gap-p: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--vertical-gap-p-02: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--vertical-gap-p-03: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--vertical-gap-p-04: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--vertical-gap-p-05: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--vertical-gap-p-06: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--vertical-gap-column-p: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--vertical-gap-column-p-02: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

text-blocks--vertical-gap-column-p-03: compile
	$(EMACS) $(EMACS_ERT_ARGS_1) $(TEST_DIR)/$@.el $(EMACS_ERT_ARGS_2)

clean:
	rm -f *.elc $(TEST_DIR)/*.elc
