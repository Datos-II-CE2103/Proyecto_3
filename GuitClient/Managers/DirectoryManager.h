#ifndef DIRECTORY_MANAGER_H
#define DIRECTORY_MANAGER_H

#include <filesystem>

extern std::filesystem::path currentDirectory;

void changeDirectory(const std::string& path);

#endif // DIRECTORY_MANAGER_H
