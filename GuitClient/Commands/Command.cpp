#include "command.h"
#include "lsCommand.h"
#include "AddCommand.h"
#include "InitCommand.h"
#include "../Managers/DirectoryManager.h"
#include "guitCommit.h"
#include "guitStatus.h"
#include "guitRollBack.h"
#include "guitReset.h"
#include "guitHelp.h"
#include <iostream>

void processCommand(const std::string& command)
{
    if (command.rfind("guit init ", 0) == 0)
    {
        std::string nombre = command.substr(10);
        guitInit(nombre);
    }

    else if (command == "guit help")
    {
        guitHelp();
    }

    else if (command.rfind("guit add ", 0) == 0)
    {
        std::string args = command.substr(9); // Extraer el argumento después de "guit add "
        guitAdd(args); // Pasar el argumento solo, sin concatenar con el directorio actual
    }
    else if (command.rfind("cd ", 0) == 0)
    {
        std::string path = command.substr(3);
        changeDirectory(path);
    }
    else if (command.rfind("guit commit ", 0) == 0)
    {
        std::string mensaje = command.substr(12); // Extraer el mensaje después de "guit commit "
        if (!mensaje.empty())
        {
            guitCommit(mensaje);
        }
        else
        {
            std::cout << "Mensaje de commit no especificado." << std::endl;
        }
    }
    else if (command.rfind("guit status ", 0) == 0)
    {
        std::string filename = command.substr(12);
        guitStatus(filename);
    }
    else if (command == "guit status")
    {
        guitStatus("");
    }
    else if (command == "ls")
    {
        guitLs();
    }
    else if (command.rfind("guit rollback ", 0) == 0)
    {
        size_t firstSpace = command.find(' ', 14); // Encuentra el primer espacio después de "guit rollback "
        if (firstSpace != std::string::npos)
        {
            std::string filename = command.substr(14, firstSpace - 14);
            std::string commitHash = command.substr(firstSpace + 1);
            if (!filename.empty() && !commitHash.empty())
            {
                guitRollback(filename, commitHash);
            }
            else
            {
                std::cout << "Faltan argumentos para el comando rollback." << std::endl;
            }
        }
        else
        {
            std::cout << "Formato incorrecto para el comando rollback." << std::endl;
        }
    }
    else if (command.rfind("guit reset ", 0) == 0)
    {
        std::string filename = command.substr(11); // Extraer el nombre del archivo después de "guit reset "
        if (!filename.empty())
        {
            guitReset(filename);
        }
        else
        {
            std::cout << "Nombre del archivo no especificado para el comando reset." << std::endl;
        }
    }
    else
    {
        std::cout << "Comando no reconocido." << std::endl;
    }
}