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



# flags, tools, dirs

# OSX need extra flags for NIF building
RS_CARGO_FLAGS_DARWIN  ?= -q --release -- --codegen link-args='-flat_namespace -undefined suppress'
RS_CARGO_FLAGS_MSYS2   ?= -q --release
RS_CARGO_FLAGS_FREEBSD ?= -q --release
RS_CARGO_FLAGS_LINUX   ?= -q --release

ifeq ($(PLATFORM),msys2)
	RS_CARGO_FLAGS ?= $(RS_CARGO_FLAGS_MSYS2)
else ifeq ($(PLATFORM),darwin)
	RS_CARGO_FLAGS ?= $(RS_CARGO_FLAGS_DARWIN)
else ifeq ($(PLATFORM),freebsd)
	RS_CARGO_FLAGS ?= $(RS_CARGO_FLAGS_FREEBSD)
else ifeq ($(PLATFORM),linux)
	RS_CARGO_FLAGS ?= $(RS_CARGO_FLAGS_LINUX)
endif

RS_CARGO ?= cargo
RS_CRATES_DIR ?= $(CURDIR)/crates
RS_OUTPUT_DIR ?= $(CURDIR)/priv/crates


# target subdir

ifeq (,$(findstring --release,$(RS_RUSTC_FLAGS)))
RS_TARGET_SUBDIR ?= debug
else
RS_TARGET_SUBDIR ?= release
endif



# sources and targets

RS_TOMLS ?= $(wildcard $(RS_CRATES_DIR)/*/Cargo.toml )
RS_CRATEDIRS ?= $(patsubst %/,%,$(dir $(RS_TOMLS)))
RS_CRATENAMES ?= $(notdir $(RS_CRATEDIRS))
RS_OUTPUT_SUBDIRS ?= $(patsubst %,$(RS_OUTPUT_DIR)/%, $(RS_CRATENAMES))


#verbosity

rs_build_verbose_0 = @echo " CARGO " $(shell basename $@);
rs_build_verbose = $(rs_build_verbose_$(V))


# build rules

app:: app-crates
apps-eunit:: app-crates
app-crates: $(RS_OUTPUT_SUBDIRS)
.PHONY: app-crates $(RS_OUTPUT_SUBDIRS)

$(RS_OUTPUT_SUBDIRS): $(RS_OUTPUT_DIR)/%: $(RS_CRATES_DIR)/%
	@rm -rf $@
	@mkdir -p $@

	@cd $< && cp $$(find . -maxdepth 3 -path "./target/*/*" -type f) $@

# 	rename OSX .dylib to .so
	[ -f $@/*.dylib ] && (for file in $@/*.dylib; do mv "$file" "${file%.dylib}.so"; done) || true
	#[ -f $@/*.so ] && (for file in $@/*.so; do mv "$$file" "$${file%.so}.uprple"; done) || true

#	cd $</target/$(RS_TARGET_SUBDIR) && \
#		cp $$($(RS_CARGO) read-manifest --manifest-path=$</Cargo.toml | \
#		jq -Mr '.targets|.[]|select(.kind|any(. == "bin" or . == "dylib")).name')) \
#		$@
	
.PHONY: $(RS_CRATEDIRS)
$(RS_CRATEDIRS): 
	$(rs_build_verbose) cd $@ && $(RS_CARGO) rustc $(RS_CARGO_FLAGS)


clean:: rust-clean
.PHONY: rust-clean
rust-clean:
	$(gen_verbose) rm -rf $(RS_OUTPUT_DIR); \
	for crate in $(RS_CRATEDIRS); do cd $$crate && $(RS_CARGO) clean; done
