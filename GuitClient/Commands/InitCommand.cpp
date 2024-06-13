#include "InitCommand.h"
// #include <json/json.h>

InitCommand::InitCommand(const std::string& name, const std::string& description)
        : Command(name, description) {
    // Constructor
}

void InitCommand::execute() {
    // Implementación del método execute para InitCommand
}

std::string InitCommand::toJson() const {
    // Convertir el comando a JSON
    /*Json::Value root;
    root["name"] = name;
    root["description"] = description;
    Json::StreamWriterBuilder writer;
    return Json::writeString(writer, root);*/
    return "Hello World";
}
