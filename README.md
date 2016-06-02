# rust.mk

This plugin for [`erlang.mk`](https://github.com/ninenines/erlang.mk) enables the automatic building of Rust crates in an Erlang application.
The plugin will build all crates in the `crates` directory and copy all binary outputs to `priv/rust/<cratename>/<binary>`.
Rust and this plugin are suitable for port programs, NIF modules, and drivers.


