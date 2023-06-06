#include "demo_impl.h"

int main() {
    rrr::PollMgr *pm = new rrr::PollMgr();
    std::shared_ptr<rrr::Client> client = std::make_shared<rrr::Client>(pm);
    while (client->connect(std::string("127.0.0.1:8090").c_str())!=0) {
        usleep(100 * 1000); // retry to connect
    }
    demo::DemoProxy *client_proxy = new demo::DemoProxy(client.get());

    rrr::i32 a = 10, b = 2, c = 3;
    rrr::i32 result;

    rrr::FutureAttr fuattr;

    fuattr.callback = [a, b, c, &result] (rrr::Future* fu) {
        rrr::i32 ret = fu->get_error_code();
        if(ret == 0) {
            fu->get_reply() >> result;
            printf("%d + %d + %d = %d\n", a, b, c, result);
        }
        else {
            Log_error("Error code %d: %s", ret, strerror(ret));
        }
        fu->release();
    };
    
    client_proxy->async_sum(a, b, c, fuattr);

    sleep(10);

    std::cout << "Finish\n" << std::endl;
    
    return 0;
}