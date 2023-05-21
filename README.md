# DepFast-Docs

## Generate DepFast Code (Ubuntu 20.04, ≥4GB RAM)

### 1. Clone Repository
```
cd ~
git clone --recursive https://github.com/stonysystems/depfast-ae.git depfast
cd ~/depfast
git checkout atc_ae
```

### 2. Build DepFast Codes
#### - Install dependencies
```
sudo bash dep.sh
sudo pip3 install -r requirements.txt
sudo apt install g++
```

#### - Build using Waf
This will create `build` folder
```
python3 waf configure -J build
```


### 3. Generate rrr (Repeatable Research Runtime) Service Codes
#### - Write `.rrr` file called demo
```
// demo.rrr
namespace demo;

abstract service Demo {

	defer hello(string hi | string reply);
	defer sum(i32 a, i32 b, i32 c | i32 result);

};
```
#### - Generate `demo.h` header file from `demo.rrr`
```
bin/rpcgen demo.rrr
```
#### - Write `DemoServiceImpl` class that inherits from `DemoService` inside `demo.h`
##### - Write `demo_impl.h` header file
```
// demo_impl.h
#include "demo.h"

namespace demo {
    class DemoServiceImpl : public DemoService {
        public:
        void hello(const std::string& hi, std::string* reply, rrr::DeferredReply* defer);
        void sum(const rrr::i32& a, const rrr::i32& b, const rrr::i32& c, rrr::i32* result, rrr::DeferredReply* defer);
    };
}
```
##### - Write `demo_impl.cc` file
```
// demo_impl.cc
#include "demo_impl.h"

namespace demo {

    void DemoServiceImpl::hello(const std::string& hi, std::string* reply, rrr::DeferredReply* defer) {
        *reply += std::string("Re: ") + hi;
        defer->reply();
    }

    void DemoServiceImpl::sum(const rrr::i32& a, const rrr::i32& b, const rrr::i32& c, rrr::i32* result, rrr::DeferredReply* defer) {
        *result = a + b + c;
        defer->reply();
    }

}
```

### 4. Create Library
#### - Compile `demo_impl.cc` and create archive code
```
g++ -I ~/depfast/src/rrr demo_impl.cc -c
ar rcs libdemo.a demo_impl.o
```

### 5. Create Server Code
#### - Create `server.cc`
```
// server.cc
#include "demo_impl.h"

int main() {
    demo::DemoServiceImpl impl;
    rrr::PollMgr *pm = new rrr::PollMgr();
    base::ThreadPool *tp = new base::ThreadPool();
    rrr::Server *server = new rrr::Server(pm, tp);

    server->reg(&impl);
    server->start(std::string("127.0.0.1:8090").c_str());

    while (1) {
        sleep(1);
    }
}
```
#### - Compile server code
```
g++ -I ~/depfast/src/rrr server.cc -c
g++ server.o -o server -L./build -lrrr -lmemdb -lexternc -lpthread -L. -ldemo -lboost_coroutine -lboost_context -lboost_system
```

### 6. Create Client Code
#### - Create `client.cc`
```
// client.cc
#include "demo_impl.h"

int main() {
    rrr::PollMgr *pm = new rrr::PollMgr();
    std::shared_ptr<rrr::Client> client = std::make_shared<rrr::Client>(pm);
    while (client->connect(std::string("127.0.0.1:8090").c_str())!=0) {
        usleep(100 * 1000); // retry to connect
    }
    demo::DemoProxy *client_proxy = new demo::DemoProxy(client.get());
    
    std::string hi = "Hello Server";
    std::string reply;

    client_proxy->hello(hi, &reply);
    printf("%s\n", reply.c_str());

    rrr::i32 a = 1, b = 2, c = 3;
    rrr::i32 result;
    
    client_proxy->sum(a, b, c, &result);
    printf("%d + %d + %d = %d\n", a, b, c, result);
}
```
#### - Compile client code
```
# Compile client.cpp
g++ -I ~/depfast/src/rrr client.cc -c
g++ client.o -o client -L./build -lrrr -lmemdb -lexternc -lpthread -L. -ldemo -lboost_coroutine -lboost_context -lboost_system
```
