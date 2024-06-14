#include "guitStatus.h"
#include <iostream>
#include <fstream>
#include <filesystem>

#include "../Managers/DirectoryManager.h"
#include "../Managers/NetworkManager.h"

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