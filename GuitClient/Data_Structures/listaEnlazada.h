#ifndef LINKED_LIST_H
#define LINKED_LIST_H

#include "FileStatus.h"
#include <string>

class LinkedList {
public:
    LinkedList();
    ~LinkedList();

    void add(const FileStatus& file);
    bool contains(const std::string& fileName) const;

    template<typename Func>
    void forEach(Func func) const;

private:
    struct Node {
        FileStatus data;
        Node* next;
        Node(const FileStatus& data) : data(data), next(nullptr) {}
    };

    Node* head;
};
template<typename Func>
void LinkedList::forEach(Func func) const {
    Node* current = head;
    while (current != nullptr) {
        func(current->data);
        current = current->next;
    }
}

#endif