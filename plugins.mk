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

RS_CARGO_FLAGS ?= -q
RS_CARGO ?= cargo
RS_CRATES_DIR ?= $(CURDIR)/crates
RS_OUTPUT_DIR ?= $(CURDIR)/priv/rust


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
app-crates: $(RS_OUTPUT_SUBDIRS)
.PHONY: app-crates $(RS_OUTPUT_SUBDIRS)

$(RS_OUTPUT_SUBDIRS): $(RS_OUTPUT_DIR)/%: $(RS_CRATES_DIR)/%
	@rm -rf $@
	@mkdir -p $@
	@cd $</target/$(RS_TARGET_SUBDIR) && \
		cp $$($(RS_CARGO) read-manifest --manifest-path=$</Cargo.toml | \
		jq -Mr '.targets|.[]|select(.kind|any(. == "bin")).name') \
		$@
	
.PHONY: $(RS_CRATEDIRS)
$(RS_CRATEDIRS): 
	$(rs_build_verbose) cd $@ && $(RS_CARGO) build $(RS_CARGO_FLAGS)


clean:: rust-clean
.PHONY: rust-clean
rust-clean:
	$(gen_verbose) rm -rf $(RS_OUTPUT_DIR); \
	for crate in $(RS_CRATEDIRS); do cd $$crate && $(RS_CARGO) clean; done
