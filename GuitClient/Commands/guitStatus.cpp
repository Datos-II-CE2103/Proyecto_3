#include "guitStatus.h"
#include <iostream>
#include <fstream>
#include <filesystem>

// Implementa la función getRepositoryId
std::string getRepositoryId() {
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
    return repositoryId;
}

// Implementa la función guitStatus
void guitStatus(const std::string& filename) {
    std::string repositoryId = getRepositoryId();
    std::string url = "https://guit.alexmontv.nl/api/Commits/" + repositoryId + "/status";
    if (!filename.empty()) {
        url += "?filename=" + filename;
    }
    auto response = NetworkManager::getInstance().get(url).get();
    if (!response.empty()) {
        std::cout << "Estado del archivo:\n" << response << std::endl;
    } else {
        std::cout << "Error al obtener el estado del archivo." << std::endl;
    }
}