#include "guitCommit.h"
#include "../Managers/NetworkManager.h"
#include "../Managers/DirectoryManager.h"  // Incluir DirectoryManager para reutilizar readIndex
#include <curl/curl.h>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <unordered_set>

void guitCommit(const std::string& mensaje) {
    // Leer los archivos en el índice
    std::unordered_set<std::string> indexedFiles = readIndex(".guit/index");

    if (indexedFiles.empty()) {
        std::cout << "No hay archivos para commitear." << std::endl;
        return;
    }

    // Obtener el nombre del repositorio del directorio actual
    std::string repositoryName = std::filesystem::current_path().filename().string();

    // Preparar la URL del servidor
    std::string url = "https://guit.alexmontv.nl/api/Commits/" + repositoryName + "/commit";

    // Inicializar libcurl
    CURL *curl = curl_easy_init();
    if (curl) {
        CURLcode res;
        curl_mime *form = nullptr;
        curl_mimepart *field = nullptr;

        // Crear el formulario multipart
        form = curl_mime_init(curl);

        // Agregar el mensaje de commit
        field = curl_mime_addpart(form);
        curl_mime_name(field, "message");
        curl_mime_data(field, mensaje.c_str(), CURL_ZERO_TERMINATED);

        // Agregar los archivos al formulario
        for (const auto& fileName : indexedFiles) {
            field = curl_mime_addpart(form);
            curl_mime_name(field, "files");
            curl_mime_filedata(field, fileName.c_str());
        }

        // Configurar la solicitud HTTP
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_MIMEPOST, form);

        // Recibir la respuesta del servidor
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, [](char *ptr, size_t size, size_t nmemb, void *userdata) -> size_t {
            size_t totalSize = size * nmemb;
            std::cout << std::string(ptr, totalSize);
            return totalSize;
        });

        // Realizar la solicitud HTTP
        res = curl_easy_perform(curl);

        if (res != CURLE_OK) {
            std::cerr << "Error al realizar el commit: " << curl_easy_strerror(res) << std::endl;
        } else {
            std::cout << "Commit realizado con éxito." << std::endl;
        }

        // Limpiar el formulario MIME y libcurl
        curl_mime_free(form);
        curl_easy_cleanup(curl);

        // Después de hacer el commit, limpiar el índice.
        std::ofstream indexFile(".guit/index", std::ios::trunc);
        indexFile.close();
    } else {
        std::cerr << "Error al inicializar libcurl." << std::endl;
    }
}