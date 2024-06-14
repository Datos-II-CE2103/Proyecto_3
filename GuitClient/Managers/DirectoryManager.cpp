#include "DirectoryManager.h"
#include <iostream>

std::filesystem::path currentDirectory = std::filesystem::current_path();

void changeDirectory(const std::string& path) {
    std::filesystem::path newDir = currentDirectory / path;
    if (std::filesystem::exists(newDir) && std::filesystem::is_directory(newDir)) {
        currentDirectory = std::filesystem::canonical(newDir);
        std::filesystem::current_path(currentDirectory); // Cambiamos el directorio actual del proceso
    } else {
        std::cout << "Directorio no encontrado: " << path << std::endl;
    }
}
