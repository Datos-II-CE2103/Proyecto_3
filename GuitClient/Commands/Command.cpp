#include "command.h"
#include "lsCommand.h"
#include "AddCommand.h"
#include "InitCommand.h"
#include "../Managers/DirectoryManager.h"
#include "guitCommit.h"
#include <iostream>

void processCommand(const std::string& command) {
    if (command.rfind("guit init ", 0) == 0) {
        std::string nombre = command.substr(10);
        guitInit(nombre);
    } else if (command.rfind("guit add ", 0) == 0) {
        std::string args = command.substr(9);  // Extraer el argumento después de "guit add "
        guitAdd(args);  // Pasar el argumento solo, sin concatenar con el directorio actual
    } else if (command.rfind("cd ", 0) == 0) {
        std::string path = command.substr(3);
        changeDirectory(path);
    }else if (command.rfind("guit commit ", 0) == 0) {
    std::string mensaje = command.substr(12);  // Extraer el mensaje después de "guit commit "
    if (!mensaje.empty()) {
    guitCommit(mensaje);
    } else {
    std::cout << "Mensaje de commit no especificado." << std::endl;
    }
    }
    else if (command == "ls") {
        guitLs();
    } else {
        std::cout << "Comando no reconocido." << std::endl;
    }
}