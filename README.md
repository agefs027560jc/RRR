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
/* demo.rrr */
namespace demo;

service Demo {

	sum(i32 a, i32 b, i32 c | i32 result);

};

struct point3 {
	double x;
	double y;
	double z;
};

service Math {
	euclidean_distance(point3 a, point3 b | double result);
};
```
#### - Generate `demo.h` header file from `demo.rrr`
```
bin/rpcgen demo.rrr
```
#### - Write `demo.cc` file
```
/* demo.cc */
#include "demo.h"

namespace demo {

/* ... */

void DemoService::sum(const rrr::i32& a, const rrr::i32& b, const rrr::i32& c, rrr::i32* result) {
    *result = a + b + c;
}

/* ... */

}
```

### Create Library
#### - Compile `demo.cc` and create archive code
```
g++ -I ~/depfast/src/rrr demo.cc -c
ar rcs libdemo.a demo.o
```

### Create Server Code
#### - Create `server.cc`
```
/* server.cc */
#include "demo.h"

int main() {
    rrr::Server server;
    demo::DemoService demo_svc;
    server.reg(&demo_svc);
    server.start("127.0.0.1:8848");
    for (;;) {
        sleep(1);
    }
    return 0;
}
```
#### - Compile server code
```
g++ -I ~/depfast/src/rrr server.cc -c
g++ server.o -o server -L./build -lrrr -lmemdb -lexternc -lpthread -L. -ldemo -lboost_coroutine -lboost_context -lboost_system
```

### Create Client Code
#### - Create `client.cc`
```
/* client.cc */
#include "demo.h"

int main() {
    rrr::ClientPool clnt_pool;
    demo::DemoProxy demo(clnt_pool.get_client("127.0.0.1:8848"));

    rrr::i32 a = 1, b = 2, c = 3;
    rrr::i32 result;
    demo.sum(a, b, c, &result);
    printf("%d + %d + %d = %d\n", a, b, c, result);
    return 0;
}
```
#### - Compile client code
```
g++ -I ~/depfast/src/rrr client.cc -c
g++ client.o -o client -L./build -lrrr -lmemdb -lexternc -lpthread -L. -ldemo -lboost_coroutine -lboost_context -lboost_system
```
