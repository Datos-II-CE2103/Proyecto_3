using Microsoft.AspNetCore.Mvc;
using System.Linq;

[Route("api/[controller]")]
[ApiController]
public class FilesController : ControllerBase
{
    private readonly VersionControlContext _context;

    public FilesController(VersionControlContext context)
    {
        _context = context;
    }

    [HttpGet("{repositoryId}")]
    public IActionResult GetFiles(int repositoryId)
    {
        var files = _context.Files.Where(f => f.RepositoryId == repositoryId).ToList();
        return Ok(files);
    }

    [HttpPost]
    public IActionResult CreateFile([FromBody] File file)
    {
        _context.Files.Add(file);
        _context.SaveChanges();
        return CreatedAtAction(nameof(GetFiles), new { repositoryId = file.RepositoryId }, file);
    }
}