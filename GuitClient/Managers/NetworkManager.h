#ifndef NETWORK_MANAGER_H
#define NETWORK_MANAGER_H

#include <cpprest/http_client.h>
#include <cpprest/filestream.h>
#include <string>
#include <memory>

class NetworkManager {
public:
    static NetworkManager& getInstance();

    pplx::task<web::json::value> post(const std::string& url, const std::string& json_body);

private:
    NetworkManager() = default;
    NetworkManager(const NetworkManager&) = delete;
    NetworkManager& operator=(const NetworkManager&) = delete;
};

#endif // NETWORK_MANAGER_H
