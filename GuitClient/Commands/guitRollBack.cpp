#include "guitRollback.h"
#include "../Managers/NetworkManager.h"
#include "../Managers/DirectoryManager.h"
#include <iostream>
#include <fstream>
#include <filesystem>


// Implementa la función guitRollback
void guitRollback(const std::string& filename, const std::string& commitHash)
{
    std::string repositoryId = getRepositoryId();
    std::string url = "https://guit.alexmontv.nl/api/Commits/" + repositoryId + "/rollback";
    url += "?filename=" + filename + "&commitHash=" + commitHash;

    auto response = NetworkManager::getInstance().rollback(url).get();

    if (!response.empty())
    {
        // Actualizar el archivo localmente con el contenido obtenido
        std::ofstream outFile(filename, std::ios::binary);
        outFile << utility::conversions::to_utf8string(response);
        outFile.close();

        std::cout << "Archivo revertido exitosamente a la versión especificada.\n";
    }
    else
    {
        std::cout << "Error al revertir el archivo a la versión especificada." << std::endl;
    }
}
