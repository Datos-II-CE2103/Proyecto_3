#include "lsCommand.h"
#include <filesystem>
#include <iostream>

void guitLs() {
    for (const auto& entry : std::filesystem::directory_iterator(std::filesystem::current_path())) {
        std::cout << entry.path().filename().string() << std::endl;
    }
}
