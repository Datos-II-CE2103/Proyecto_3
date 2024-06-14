#ifndef DIRECTORYMANAGER_H
#define DIRECTORYMANAGER_H

#include <string>
#include <unordered_set>
#include <filesystem>

extern std::filesystem::path currentDirectory;

void changeDirectory(const std::string& path);
std::unordered_set<std::string> readIndex(const std::filesystem::path& path);
std::string getRepositoryId();
size_t WriteCallback(void* ptr, size_t size, size_t nmemb, void* stream);

#endif // DIRECTORYMANAGER_H