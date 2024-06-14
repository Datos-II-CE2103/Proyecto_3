#include "guitCommit.h"
#include "../Managers/NetworkManager.h"
#include "../Managers/DirectoryManager.h"  // Incluir DirectoryManager para reutilizar readIndex
#include <cpprest/http_client.h>
#include <cpprest/filestream.h>
#include <cpprest/json.h>
#include <cpprest/uri.h>
#include <cpprest/asyncrt_utils.h>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <unordered_set>
#include <vector>

void guitCommit(const std::string& mensaje) {
    // Leer los archivos en el índice
    std::unordered_set<std::string> indexedFiles = readIndex(".guit/index");

    if (indexedFiles.empty()) {
        std::cout << "No hay archivos para commitear." << std::endl;
        return;
    }

    // Obtener el nombre del repositorio del directorio actual
    std::filesystem::path currentDirectory = std::filesystem::current_path();
    std::string repositoryName = currentDirectory.filename().string();

    // Preparar la URL del servidor
    std::string url = "https://guit.alexmontv.nl/api/Commits/" + repositoryName + "/commit";

    // Crear el cliente HTTP
    web::http::client::http_client client(U(url));
    web::http::http_request request(web::http::methods::POST);

    // Generar un boundary único para multipart/form-data
    std::string boundary = "------------------------" + std::to_string(std::chrono::system_clock::now().time_since_epoch().count());

    // Construir el cuerpo multipart/form-data
    std::ostringstream bodyStream;
    bodyStream << "--" << boundary << "\r\n";
    bodyStream << "Content-Disposition: form-data; name=\"message\"\r\n\r\n";
    bodyStream << mensaje << "\r\n";

    for (const auto& fileName : indexedFiles) {
        std::ifstream file(fileName, std::ios::binary);
        if (file.is_open()) {
            std::ostringstream oss;
            oss << file.rdbuf();
            std::string fileContent = oss.str();

            // Obtener la ruta relativa del archivo
            std::string relativeFileName = std::filesystem::relative(fileName, currentDirectory).string();

            bodyStream << "--" << boundary << "\r\n";
            bodyStream << "Content-Disposition: form-data; name=\"files\"; filename=\"" << relativeFileName << "\"\r\n";
            bodyStream << "Content-Type: application/octet-stream\r\n\r\n";
            bodyStream << fileContent << "\r\n";
        } else {
            std::cerr << "Error: No se pudo abrir el archivo " << fileName << std::endl;
        }
    }
    bodyStream << "--" << boundary << "--\r\n";

    // Convertir el cuerpo a std::string
    std::string body = bodyStream.str();

    // Configurar el encabezado Content-Type con el boundary generado
    request.headers().add(U("Content-Type"), U("multipart/form-data; boundary=") + utility::conversions::to_string_t(boundary));

    // Asignar el cuerpo multipart/form-data al request
    request.set_body(body);

    // Enviar la solicitud
    client.request(request).then([](web::http::http_response response) {
        if (response.status_code() == web::http::status_codes::OK) {
            std::cout << "Commit realizado con éxito." << std::endl;
        } else {
            std::cerr << "Error al realizar el commit: " << response.status_code() << std::endl;
            std::cerr << response.extract_string(true).get() << std::endl; // Depurar la respuesta del servidor
        }
    }).wait();

    // Después de hacer el commit, limpiar el índice.
    std::ofstream indexFile(".guit/index", std::ios::trunc);
    indexFile.close();
}