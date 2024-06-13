#include "NetworkManager.h"
#include <cpprest/http_client.h>

using namespace web;
using namespace web::http;
using namespace web::http::client;

NetworkManager::NetworkManager(const std::string& serverAddress, int port)
        : serverAddress(serverAddress), port(port), client(U(serverAddress + ":" + std::to_string(port))) {
    // Constructor
}

void NetworkManager::sendRequest(const Command& command) {
    http_request request(methods::POST);
    request.headers().set_content_type(U("application/json"));

    // Convert Command to JSON and set as request body
    std::string json_body = command.toJson();
    request.set_body(json_body);

    client.request(request).then([this](http_response response) {
        if (response.status_code() == status_codes::OK || response.status_code() == status_codes::Created) {
            lastResponse = response;
        } else {
            std::cerr << "Error in REST request: " << response.status_code() << std::endl;
        }
    }).wait();
}

http_response NetworkManager::receiveResponse() const {
    return lastResponse;
}
