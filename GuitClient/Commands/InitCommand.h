#ifndef GUITCLIENT_INITCOMMAND_H
#define GUITCLIENT_INITCOMMAND_H

#include "Command.h"

class InitCommand : public Command {
public:
    InitCommand(const std::string& name, const std::string& description);

    void execute() override;
    std::string toJson() const override;
};

#endif // INITCOMMAND_H

