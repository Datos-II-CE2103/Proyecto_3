#include "NetworkManager.h"

NetworkManager& NetworkManager::getInstance() {
    static NetworkManager instance;
    return instance;
}

pplx::task<web::json::value> NetworkManager::post(const std::string& url, const std::string& json_body) {
    web::http::client::http_client client(U(url));
    web::http::http_request request(web::http::methods::POST);
    request.headers().set_content_type(U("application/json"));
    request.set_body(json_body);

    return client.request(request).then([](web::http::http_response response) {
        if (response.status_code() == web::http::status_codes::Created) {
            return response.extract_json();
        } else {
            std::cerr << "Error en la solicitud REST." << std::endl;
            return pplx::task_from_result(web::json::value());
        }
    });


}
pplx::task<utility::string_t> NetworkManager::get(const std::string& url) {
    web::http::client::http_client client(U(url));
    web::http::http_request request(web::http::methods::GET);
    return client.request(request).then([](web::http::http_response response) {
        if (response.status_code() == web::http::status_codes::OK) {
            return response.extract_string();
        } else {
            std::cerr << "Error en la solicitud GET." << std::endl;
            return pplx::task_from_result(utility::string_t(U("")));
        }
    });
}