#include "InitCommand.h"
#include "../Managers/NetworkManager.h"
#include "../Managers/DirectoryManager.h"
#include <filesystem>
#include <fstream>
#include <iostream>

void guitInit(const std::string& nombre) {
    std::filesystem::path newRepoPath = currentDirectory / nombre;
    if (!std::filesystem::exists(newRepoPath)) {
        std::filesystem::create_directory(newRepoPath);
    }
    std::filesystem::create_directory(newRepoPath / ".guit");

    std::string archivoIgnore = (newRepoPath / ".guitignore").string();
    std::ofstream fout(archivoIgnore);
    fout << "# Archivos o directorios a ignorar en .guit\n";
    fout.close();

    std::string url = "https://guit.alexmontv.nl/api/Repositories/init";
    std::string json_body = "{ \"name\": \"" + nombre + "\", \"description\": \"string\" }";

    NetworkManager::getInstance().post(url, json_body).then([newRepoPath](web::json::value jsonResponse) {
        try {
            if (!jsonResponse.is_null()) {
                int id = jsonResponse.at(U("id")).as_integer();
                std::ofstream configFile(newRepoPath / ".guit/config");
                configFile << "id=" << id << "\n";
                configFile.close();

                // Confirmación de creación del repositorio
                std::cout << "Repositorio creado con éxito. ID: " << id << std::endl;
            }
        } catch (const std::exception &e) {
            std::cerr << "Error al manejar la respuesta JSON: " << e.what() << std::endl;
        }
    }).wait();

    // Cambiar al nuevo directorio
    changeDirectory(nombre);
}
