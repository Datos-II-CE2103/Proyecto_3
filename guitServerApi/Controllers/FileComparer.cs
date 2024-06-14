using System.Diagnostics;
using System.IO;

public class FileComparer
{
    public static string CompareFiles(string file1, string file2)
    {
        // Configurar la información de inicio del proceso para ejecutar fc.exe
        ProcessStartInfo processStartInfo = new ProcessStartInfo("fc.exe")
        {
            RedirectStandardOutput = true,   // Redirigir la salida estándar
            Arguments = $"\"{file1}\" \"{file2}\"",   // Argumentos para comparar los archivos
            UseShellExecute = false,    // No usar el shell para ejecutar el proceso
            CreateNoWindow = true       // No crear una ventana de consola para el proceso
        };

        // Iniciar el proceso para ejecutar fc.exe
        using (Process process = Process.Start(processStartInfo))
        {
            using (StreamReader reader = process.StandardOutput)
            {
                // Leer toda la salida generada por fc.exe
                string result = reader.ReadToEnd();
                process.WaitForExit();  // Esperar a que el proceso termine
                return result;  // Devolver el resultado de la comparación
            }
        }
    }
}