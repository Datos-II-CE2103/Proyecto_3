#include <iostream>

void guitHelp()
{
    std::cout << "Comandos disponibles:\n\n";

    std::cout << "guit init <name>\n";
    std::cout << "Instancia un nuevo repositorio en el servidor y lo identifica con el nombre indicado por <name>.\n\n";

    std::cout << "guit help\n";
    std::cout << "Muestra esta ayuda de guit.\n\n";

    std::cout << "guit add [-A] [name]\n";
    std::cout << "Permite agregar todos los archivos que no estén registrados o que tengan nuevos cambios\n";
    std::cout << "al repositorio. Ignora los archivos que estén configurados en .guitignore. Puede\n";
    std::cout << "indicar cada archivo por agregar, o puede usar el flag -A para agregar todos los archivos\n";
    std::cout << "relevantes.\n\n";

    std::cout << "guit commit <mensaje>\n";
    std::cout << "Envía los archivos agregados y pendientes de commit al server. Se debe especificar un\n";
    std::cout << "mensaje a la hora de hacer el commit. El server recibe los cambios, y cuando ha\n";
    std::cout << "terminado de procesar los cambios, retorna un id de commit al cliente generado con MD5.\n\n";

    std::cout << "guit status <file>\n";
    std::cout << "Este comando nos va a mostrar cuales archivos han sido cambiados, agregados o\n";
    std::cout << "eliminados de acuerdo al commit anterior. Si especifica <file>, muestra el\n";
    std::cout << "historial de cambios, recuperando el historial de cambios desde el server.\n\n";

    std::cout << "guit rollback <file> <commit>\n";
    std::cout << "Permite regresar un archivo en el tiempo a un commit específico.\n\n";

    std::cout << "guit reset <file>\n";
    std::cout << "Deshace cambios locales para un archivo y lo regresa al último commit.\n\n";

    std::cout << "guit sync <file>\n";
    std::cout << "Recupera los cambios para un archivo en el server y lo sincroniza con el archivo en el\n";
    std::cout << "cliente.\n";
}