#ifndef GUITCLIENT_COMMAND_H
#define GUITCLIENT_COMMAND_H

#include <string>

class Command {
public:
    Command(const std::string& name, const std::string& description);
    virtual ~Command() = default;

    virtual void execute() = 0;
    virtual std::string toJson() const = 0;

protected:
    std::string name;
    std::string description;
};

#endif // COMMAND_H

