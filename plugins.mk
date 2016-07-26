# Copyright (c) 2016, Daniel Goertzen <daniel.goertzen@gmail.com>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


# This plugin is a thin wrapper around https://github.com/goertzenator/cargo-erlangapp
# which is automatically downloaded and used.

CARGO_BUILD_FLAGS ?= --release
CARGO_TESTBUILD_FLAGS ?=
CARGO_TEST_FLAGS ?=
CARGO_CLEAN_FLAGS ?=

CARGO_ERLANGAPP_ROOT = .cargo-erlangapp
CARGO_ERLANGAPP = $(CARGO_ERLANGAPP_ROOT)/bin/cargo-erlangapp

$(CARGO_ERLANGAPP):
	cargo install --root=$(CARGO_ERLANGAPP_ROOT) --vers=0.1 cargo-erlangapp

.PHONY: rust-build rust-testbuild rust-test rust-clean rust-distclean

app:: rust-build
test-build:: rust-testbuild
tests:: rust-test
clean:: rust-clean
distclean:: rust-clean rust-distclean

rust-build: $(CARGO_ERLANGAPP)
	$(CARGO_ERLANGAPP) build $(CARGO_BUILD_FLAGS)

rust-testbuild: $(CARGO_ERLANGAPP)
	$(CARGO_ERLANGAPP) build $(CARGO_TESTBUILD_FLAGS)

rust-test: $(CARGO_ERLANGAPP)
	$(CARGO_ERLANGAPP) test $(CARGO_TEST_FLAGS)

rust-clean: $(CARGO_ERLANGAPP)
	$(CARGO_ERLANGAPP) clean $(CARGO_CLEAN_FLAGS)

rust-distclean:
	rm -rf $(CARGO_ERLANGAPP_ROOT)
