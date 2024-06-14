#ifndef DIRECTORY_MANAGER_H
#define DIRECTORY_MANAGER_H

#include <filesystem>
#include <unordered_set>
#include <string>

// Declaración de la variable global para el directorio actual
extern std::filesystem::path currentDirectory;

// Función para cambiar el directorio
void changeDirectory(const std::string& path);

// Función para leer archivos del índice .guit/index
std::unordered_set<std::string> readIndex(const std::filesystem::path& path);

#endif // DIRECTORY_MANAGER_H
