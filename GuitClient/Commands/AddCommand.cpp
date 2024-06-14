#include "AddCommand.h"
#include "../Data_Structures/FileStatus.h"
#include "../Data_Structures/listaEnlazada.h"
#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <unordered_set>

// Función para leer archivos ignorados de .guitignore
std::unordered_set<std::string> readGuitignore(const std::filesystem::path& path) {
    std::unordered_set<std::string> ignoreFiles;
    std::ifstream inFile(path);
    std::string line;
    while (std::getline(inFile, line)) {
        if (!line.empty() && line[0] != '#') {
            ignoreFiles.insert(line);
        }
    }
    return ignoreFiles;
}

// Función para leer archivos ya añadidos de .guit/index
std::unordered_set<std::string> readIndex(const std::filesystem::path& path) {
    std::unordered_set<std::string> indexedFiles;
    std::ifstream inFile(path);
    std::string line;
    while (std::getline(inFile, line)) {
        indexedFiles.insert(line);
    }
    return indexedFiles;
}

// Función para añadir archivos al índice
void addFilesToIndex(const LinkedList& files) {
    std::ofstream indexFile(".guit/index", std::ios::app);
    files.forEach([&indexFile](const FileStatus& file) {
        indexFile << file.getFileName() << "\n";  // Guardar solo el nombre del archivo
    });
    indexFile.close();
}

// Función de impresión para la lista enlazada
void printFile(const FileStatus& file) {
    std::cout << file.getFileName() << " ";  // Imprimir solo el nombre del archivo
}

void guitAdd(const std::string& args) {
    std::istringstream iss(args);
    std::string token;
    LinkedList files;
    std::unordered_set<std::string> ignoreFiles = readGuitignore(".guitignore");
    std::unordered_set<std::string> indexedFiles = readIndex(".guit/index");
    bool addAll = false;
    std::filesystem::path currentPath = std::filesystem::current_path();

    // Procesar argumentos para buscar la bandera -A y nombres de archivos
    while (iss >> token) {
        if (token == "-A") {
            addAll = true;
            break; // No procesar más tokens si encontramos -A
        } else {
            std::filesystem::path filePath = currentPath / token;
            std::string relativePath = std::filesystem::relative(filePath, currentPath).string();
            if (ignoreFiles.find(relativePath) == ignoreFiles.end() && indexedFiles.find(relativePath) == indexedFiles.end() && std::filesystem::exists(filePath)) {
                files.add(FileStatus(relativePath, false, ""));
            } else if (!std::filesystem::exists(filePath)) {
                std::cerr << "Error: " << token << " no existe." << std::endl;
            }
        }
    }

    // Si se especifica la bandera -A, agregar todos los archivos no ignorados y no añadidos ya
    if (addAll) {
        for (const auto& entry : std::filesystem::recursive_directory_iterator(currentPath)) {
            if (entry.is_regular_file()) {
                std::string relativePath = std::filesystem::relative(entry.path(), currentPath).string();
                if (ignoreFiles.find(relativePath) == ignoreFiles.end() && indexedFiles.find(relativePath) == indexedFiles.end()) {
                    files.add(FileStatus(relativePath, false, ""));
                }
            }
        }
    }

    // Añadir los archivos al índice
    addFilesToIndex(files);

    std::cout << "Archivos agregados al índice: ";
    files.forEach(printFile);
    std::cout << std::endl;
}