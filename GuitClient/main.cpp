#include <iostream>
#include <string>
#include <filesystem>
#include "Commands/command.h"

int main() {
    std::string input;
    std::cout << "Bienvenido a Guit \n";
    while (true) {
        std::cout << std::filesystem::current_path().string() << ">>" ;
        std::getline(std::cin, input);

        if (input == "salir") {
            break;
        }

        processCommand(input);
    }

    return 0;
}
