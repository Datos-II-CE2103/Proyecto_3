#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <cpprest/http_client.h>
#include <cpprest/filestream.h>
#include <pplx/pplxtasks.h>

class NetworkManager
{
public:
    static NetworkManager& getInstance();
    pplx::task<web::json::value> post(const std::string& url, const std::string& json_body);
    pplx::task<utility::string_t> get(const std::string& url);
    pplx::task<utility::string_t> rollback(const std::string& url);

private:
    NetworkManager() {}
    NetworkManager(const NetworkManager&) = delete;
    NetworkManager& operator=(const NetworkManager&) = delete;
};

#endif // NETWORKMANAGER_H
