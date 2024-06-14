#ifndef GUITCLIENT_FILESTATUS_H
#define GUITCLIENT_FILESTATUS_H

#include <string>

class FileStatus {
public:
    FileStatus(const std::string& fileName, bool isUnderVersionControl, const std::string& lastCommitId);

    std::string getFileName() const;
    bool getVersionControlStatus() const;
    std::string getLastCommitId() const;

    void setVersionControlStatus(bool status);
    void setLastCommitId(const std::string& commitId);

private:
    std::string fileName;
    bool isUnderVersionControl;
    std::string lastCommitId;
};

#endif // FILESTATUS_H

