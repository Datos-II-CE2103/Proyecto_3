#include "ListaEnlazada.h"

// Implementación de los métodos

LinkedList::LinkedList() : head(nullptr) {}

LinkedList::~LinkedList() {
    Node* current = head;
    while (current != nullptr) {
        Node* next = current->next;
        delete current;
        current = next;
    }
}

void LinkedList::add(const FileStatus& file) {
    Node* newNode = new Node(file);
    newNode->next = head;
    head = newNode;
}

bool LinkedList::contains(const std::string& fileName) const {
    Node* current = head;
    while (current != nullptr) {
        if (current->data.getFileName() == fileName) {
            return true;
        }
        current = current->next;
    }
    return false;
}

