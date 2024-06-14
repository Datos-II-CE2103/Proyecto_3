#ifndef NETWORK_MANAGER_H
#define NETWORK_MANAGER_H

#include <cpprest/http_client.h>
#include <cpprest/json.h>
#include <pplx/pplxtasks.h>
#include <iostream>

class NetworkManager {
public:
    static NetworkManager& getInstance();
    pplx::task<web::json::value> post(const std::string& url, const std::string& json_body);
    pplx::task<utility::string_t> get(const std::string& url);

private:
    NetworkManager() = default;
    NetworkManager(const NetworkManager&) = delete;
    NetworkManager& operator=(const NetworkManager&) = delete;
};

#endif // NETWORK_MANAGER_H