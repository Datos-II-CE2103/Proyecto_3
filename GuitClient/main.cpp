#include <cpprest/http_client.h> // Incluimos la cabecera para el cliente REST
#include <fstream>
#include <filesystem>
#include <cstdlib>

int main() {

    system("gnome-terminal");

    std::string nombre; // Nombre proporcionado por el usuario
    std::cout << "Ingrese el nombre: ";
    std::cin >> nombre;

    // Crear la carpeta principal si no existe
    if (!std::filesystem::exists(nombre)) {
        std::filesystem::create_directory(nombre);
    }

    // Crear la subcarpeta .guit
    std::string subcarpeta = nombre + "/.guit";
    std::filesystem::create_directory(subcarpeta);

    // Crear el archivo .guitignore
    std::string archivoIgnore = nombre + "/.guitignore";
    std::ofstream fout(archivoIgnore);
    fout << "# Archivos o directorios a ignorar en .guit\n";
    fout.close();

    // Crear cliente HTTP
    web::http::client::http_client client(U("https://guit.alexmontv.nl/api/Repositories/init"));

    // Crear una solicitud HTTP POST
    web::http::http_request request(web::http::methods::POST);
    request.headers().set_content_type(U("application/json"));

    // Crear el cuerpo de la solicitud en formato JSON
    std::string json_body = "{ \"name\": \"" + nombre + "\" , \"description\": \"string\" }";

    // Establecer el cuerpo de la solicitud
    request.set_body(json_body);

    client.request(request).then([nombre](web::http::http_response response) {
        if (response.status_code() == web::http::status_codes::Created) {
            std::cout << "Solicitud REST exitosa." << std::endl;

            // Leer el cuerpo de la respuesta
            return response.extract_json();
        } else {
            std::cout << "Error en la solicitud REST." << std::endl;
            return pplx::task_from_result(web::json::value());
        }
    }).then([nombre](pplx::task<web::json::value> previousTask) {
        try {
            const auto& jsonResponse = previousTask.get();
            if (!jsonResponse.is_null()) {
                // Extraer el id de la respuesta
                int id = jsonResponse.at(U("id")).as_integer();

                // Crear y escribir en el archivo config
                std::ofstream configFile(nombre + "/.guit/config");
                configFile << "id=" << id << "\n";
                configFile.close();
            }
        } catch (const std::exception &e) {
            std::cerr << "Error al manejar la respuesta JSON: " << e.what() << std::endl;
        }
    }).wait();

    return 0;
}