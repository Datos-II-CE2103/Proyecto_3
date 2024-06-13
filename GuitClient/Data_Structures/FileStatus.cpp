#include "FileStatus.h"

FileStatus::FileStatus(const std::string& fileName, bool isUnderVersionControl, const std::string& lastCommitId)
        : fileName(fileName), isUnderVersionControl(isUnderVersionControl), lastCommitId(lastCommitId) {}

std::string FileStatus::getFileName() const {
    return fileName;
}

bool FileStatus::getVersionControlStatus() const {
    return isUnderVersionControl;
}

std::string FileStatus::getLastCommitId() const {
    return lastCommitId;
}

void FileStatus::setVersionControlStatus(bool status) {
    isUnderVersionControl = status;
}

void FileStatus::setLastCommitId(const std::string& commitId) {
    lastCommitId = commitId;
}
