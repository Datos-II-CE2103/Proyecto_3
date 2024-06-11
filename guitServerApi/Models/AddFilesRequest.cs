namespace guitApiServer.Models;

public class AddFilesRequest
{
    public bool AddAll { get; set; }
    public List<string> FileNames { get; set; }
}