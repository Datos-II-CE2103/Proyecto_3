#ifndef GUITSTATUS_H
#define GUITSTATUS_H

#include <string>
#include "../Managers/NetworkManager.h"

// Declara la función guitStatus
void guitStatus(const std::string& filename);

// Función para obtener el ID del repositorio actual
std::string getRepositoryId();

#endif // GUITSTATUS_H
