
#include <iostream>
#include "../Managers/DirectoryManager.h"
#include <fstream>
#include <string>
#include <curl/curl.h>

void guitReset(const std::string& filename)
{
    std::string repositoryId = getRepositoryId();
    std::string url = "https://guit.alexmontv.nl/api/Commits/" + repositoryId + "/reset";
    url += "?filename=" + filename;

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
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L); // Ajuste según los requisitos SSL
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 0L); // Ajuste según los requisitos SSL
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &outFile);

        res = curl_easy_perform(curl);
        if(res != CURLE_OK) {
            std::cerr << "curl_easy_perform() falló: " << curl_easy_strerror(res) << std::endl;
        } else {
            std::cout << "Archivo restablecido exitosamente al último commit.\n";
        }
        outFile.close();
        curl_easy_cleanup(curl);
    } else {
        std::cerr << "Error al iniciar libcurl." << std::endl;
    }
}