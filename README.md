# A Repeatable Research Runtime (RRR)

This is a collection of utility code.

## Dependencies

Needed dependencies are: ``python2``, ``c++ compiler``, ``boost libraries``.

On Ubuntu, run
```bash
$ sudo apt install -y python2 build-essential libboost-all-dev
```
and then clone the repo,
```bash
$ git clone https://github.com/agefs027560jc/RRR.git
```
## Writing example srpc

1. Create ``.rrr`` file and add some methods. See ``demo.rrr``
2. Generate ``.h`` file by running ``python2 src/pylib/simplerpcgen/rpcgen.py demo.rrr``
3. Create service implementation that inherit from generated header's service. See ``demo_impl.h`` and ``demo.h``
4. Create server and client code. See ``server.cc`` and ``client.cc``

## Compiling and running

1. Compile server code
  - ``g++ -c -I. -I ./src demo_impl.cc server.cc``
  - ``g++ demo_impl.o server.o -o rpc_svc -L ./lib -lrrr -lpthread -L. -L ./src -lboost_coroutine -lboost_context -lboost_system``
2. Compile client code
  - ``g++ -c -I. -I ./src client.cc``
  - ``g++ client.o -o rpc_clnt -L ./lib -lrrr -lpthread -L. -L /src -lboost_coroutine -lboost_context -lboost_system``
3. Running
  - run the server with ``./rpc_svc``
  - on separate instance, launce ``./rpc_clnt``
