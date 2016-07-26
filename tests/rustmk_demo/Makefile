PROJECT = rustmk_demo

DEPS = find_crate

# Normal apps would include rust.mk like this:
#BUILD_DEPS = rust_mk
#DEP_PLUGINS = rust_mk



include erlang.mk

# But because we're a subdir of the rust.mk repo we have to do this:
include ../../plugins.mk
