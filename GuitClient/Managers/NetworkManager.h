#ifndef GUITCLIENT_NETWORKMANAGER_H
#define GUITCLIENT_NETWORKMANAGER_H

#include <string>
#include "../Commands/Command.h"
#include <cpprest/http_client.h>

class NetworkManager {
public:
    NetworkManager(const std::string& serverAddress, int port);
    void sendRequest(const Command& command);
    web::http::http_response receiveResponse() const;

private:
    std::string serverAddress;
    int port;
    web::http::client::http_client client;
    web::http::http_response lastResponse;
};

#endif // NETWORKMANAGER_H

