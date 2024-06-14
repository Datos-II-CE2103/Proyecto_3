#include "guitCommit.h"
#include "../Managers/NetworkManager.h"
#include "../Managers/DirectoryManager.h"  // Incluir DirectoryManager para reutilizar readIndex
#include "../Data_Structures/listaEnlazada.h"
#include <curl/curl.h>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <unordered_set>



void readGuitIgnore(const std::string& ignoreFilePath, LinkedList& ignoreList) {
    std::ifstream ignoreFile(ignoreFilePath);
    if (!ignoreFile.is_open()) {
        std::cerr << "No se pudo abrir el archivo .guitignore" << std::endl;
        return;
    }

    std::string line;
    while (std::getline(ignoreFile, line)) {
        if (!line.empty()) {
            ignoreList.add(FileStatus(line, false, "")); // Agregar cada línea como un FileStatus a la lista de ignorados
        }
    }

    ignoreFile.close();
}


void guitCommit(const std::string& mensaje) {
    // Leer los archivos indexados
    LinkedList ignoreList;
    readGuitIgnore(".guitignore", ignoreList);

    std::unordered_set<std::string> indexedFiles = readIndex(".guit/index");
    if (indexedFiles.empty()) {
        std::cout << "No hay archivos para commitear." << std::endl;
        return;
    }

    // Leer el ID del repositorio del archivo de configuración
    std::ifstream configFile(".guit/config");
    std::string repositoryId;
    std::string line;
    while (std::getline(configFile, line)) {
        if (line.substr(0, 3) == "id=") {
            repositoryId = line.substr(3);
            break;
        }
    }
    configFile.close();

    // Preparar la URL del servidor
    std::string url = "https://guit.alexmontv.nl/api/Commits/" + repositoryId + "/commit";

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

        // Agregar los archivos al formulario con sus rutas completas, evitando los ignorados
        for (const auto& fileName : indexedFiles) {
            // Si el archivo está en la lista de ignorados, saltarlo
            if (ignoreList.contains(fileName)) {
                std::cout << "Ignorando archivo: " << fileName << std::endl;
                continue;
            }

            std::cout << "Adding file: " << fileName << std::endl;  // Depuración: Ver qué archivos se están agregando
            field = curl_mime_addpart(form);
            curl_mime_name(field, "files");  // Aquí se usa "files" como nombre del campo
            curl_mime_filedata(field, fileName.c_str());

            // Agregar la ruta relativa como un campo adicional
            field = curl_mime_addpart(form);
            curl_mime_name(field, "filePaths");
            curl_mime_data(field, fileName.c_str(), CURL_ZERO_TERMINATED);
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

        // No vaciar el archivo index después de hacer el commit
        // No es necesario hacer nada especial aquí, ya que el archivo no se vacía explícitamente
    } else {
        std::cerr << "Error al inicializar libcurl." << std::endl;
    }
}
