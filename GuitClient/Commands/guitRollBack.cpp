#include "guitRollback.h"
#include "../Managers/DirectoryManager.h"
#include <iostream>
#include <fstream>
#include <string>
#include <curl/curl.h>

// Callback function to write data to a file stream.
size_t WriteCallback(void* ptr, size_t size, size_t nmemb, void* stream)
{
    std::ofstream* out = static_cast<std::ofstream*>(stream);
    out->write(static_cast<const char*>(ptr), size * nmemb);
    return size * nmemb;
}

void guitRollback(const std::string& filename, const std::string& commitHash)
{
    std::string repositoryId = getRepositoryId();
    std::string url = "https://guit.alexmontv.nl/api/Commits/" + repositoryId + "/rollback";
    url += "?filename=" + filename + "&commitHash=" + commitHash;

    CURL* curl;
    CURLcode res;
    curl = curl_easy_init();
    if(curl) {
        std::ofstream outFile(filename, std::ios::binary);
        if (!outFile.is_open()) {
            std::cerr << "Error al abrir el archivo para escritura: " << filename << std::endl;
            return;
        }

        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L); // To be adjusted based on SSL requirements
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 0L); // To be adjusted based on SSL requirements
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &outFile);

        res = curl_easy_perform(curl);
        if(res != CURLE_OK) {
            std::cerr << "curl_easy_perform() failed: " << curl_easy_strerror(res) << std::endl;
        } else {
            std::cout << "Archivo revertido exitosamente a la versión especificada.\n";
        }
        outFile.close();
        curl_easy_cleanup(curl);
    } else {
        std::cerr << "Error al iniciar libcurl." << std::endl;
    }
}
