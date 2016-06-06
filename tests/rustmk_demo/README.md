A simple demo of [ruster_unsafe](https://github.com/goertzenator/ruster_unsafe)

## Sample session

```text
$ git clone https://github.com/goertzenator/ruster_unsafe_demo
Cloning into 'ruster_unsafe_demo'...

$ cd ruster_unsafe_demo/

$ cargo build
   Compiling ruster_unsafe v0.1.0
   Compiling libc v0.1.6
   Compiling ruster_unsafe_demo v0.0.1 (file:///home/goertzen/ruster_unsafe_demo)

$ erlc ruster_unsafe_demo.erl

$ erl
Erlang/OTP 17 [erts-6.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:10] [hipe] [kernel-poll:false]

Eshell V6.3  (abort with ^G)
1> ruster_unsafe_demo:static_atom().
'static atom from Rust'

2> ruster_unsafe_demo:native_add(45,11).
56

3> ruster_unsafe_demo:tuple_add({45,-11}).
34
```
