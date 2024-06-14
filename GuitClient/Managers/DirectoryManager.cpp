#include "DirectoryManager.h"
#include <iostream>
#include <fstream>

// Definición de la variable global para el directorio actual
std::filesystem::path currentDirectory = std::filesystem::current_path();

void changeDirectory(const std::string& path)
{
    std::filesystem::path newDir = currentDirectory / path;
    if (std::filesystem::exists(newDir) && std::filesystem::is_directory(newDir))
    {
        currentDirectory = std::filesystem::canonical(newDir);
        std::filesystem::current_path(currentDirectory); // Cambiamos el directorio actual del proceso
    }
    else
    {
        std::cout << "Directorio no encontrado: " << path << std::endl;
    }
}

// Función para leer archivos del índice .guit/index
std::unordered_set<std::string> readIndex(const std::filesystem::path& path)
{
    std::unordered_set<std::string> indexedFiles;
    std::ifstream inFile(path);
    std::string line;
    while (std::getline(inFile, line))
    {
        indexedFiles.insert(line);
    }
    return indexedFiles;
}

// Implementación de la función getRepositoryId
std::string getRepositoryId()
{
    // Leer el ID del repositorio del archivo de configuración
    std::ifstream configFile(".guit/config");
    std::string repositoryId;
    std::string line;
    while (std::getline(configFile, line))
    {
        if (line.substr(0, 3) == "id=")
        {
            repositoryId = line.substr(3);
            break;
        }
    }
    configFile.close();
    return repositoryId;
}
size_t WriteCallback(void* ptr, size_t size, size_t nmemb, void* stream)
{
    std::ofstream* out = static_cast<std::ofstream*>(stream);
    out->write(static_cast<const char*>(ptr), size * nmemb);
    return size * nmemb;
}