using System.Diagnostics;
using System.IO;

public class FileComparer
{
    public static string CompareFiles(string file1, string file2)
    {
        ProcessStartInfo processStartInfo = new ProcessStartInfo("fc.exe")
        {
            RedirectStandardOutput = true,
            Arguments = $"\"{file1}\" \"{file2}\"",
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using (Process process = Process.Start(processStartInfo))
        {
            using (StreamReader reader = process.StandardOutput)
            {
                // Leer toda la salida de fc.exe
                string result = reader.ReadToEnd();
                process.WaitForExit();
                return result;
            }
        }
    }
}