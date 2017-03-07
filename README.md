# rust.mk   [![Build Status](https://travis-ci.org/goertzenator/rust.mk.svg?branch=master)](https://travis-ci.org/goertzenator/rust.mk)

This plugin for [`erlang.mk`](https://github.com/ninenines/erlang.mk) enables the automatic building of Rust crates in an Erlang application.
The plugin will build all crates in the `crates` directory and copy all binary outputs to `priv/crates/<cratename>/<binary>`.
See the test application in this repository for an example of a port program and NIF module implemented in Rust.

# Using the plugin
Use the plugin by adding `BUILD_DEPS` and `DEP_PLUGINS` as in this Makefile:

``` Makefile
PROJECT = myapp
BUILD_DEPS = rust_mk
DEP_PLUGINS = rust_mk

include erlang.mk
```
This will automatically download and use `rust.mk`.


# Application structure with Rust crates
To add crates to an Erlang application, place them in a `crates/` folder.  All crates found within will be built and resulting artifacts will be placed in the `priv/crates/` folder.

The library application [`find_crate`](https://github.com/goertzenator/find_crate) may be used to reliably find artifacts in `priv/crates` in a cross-platform manner.


Project structure:
```
myapp/
    Makefile
    erlang.mk
    ebin/
        ...
    src/
         ...
    crates/
        foo_nif/
            Cargo.toml
            ...
        bar_port/
            Cargo.toml
             ...
    priv/
        crates/
            foo_nif/
                libfoo_nif.so
            bar_port/
                bar_port

```


