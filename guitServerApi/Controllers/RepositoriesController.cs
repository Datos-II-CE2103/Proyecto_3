using Microsoft.AspNetCore.Mvc;
using System.Linq;

[Route("api/[controller]")]
[ApiController]
public class RepositoriesController : ControllerBase
{
    private readonly VersionControlContext _context;

    public RepositoriesController(VersionControlContext context)
    {
        _context = context;
    }

    [HttpGet]
    public IActionResult GetRepositories()
    {
        var repositories = _context.Repositories.ToList();
        return Ok(repositories);
    }

    [HttpGet("{id}")]
    public IActionResult GetRepository(int id)
    {
        var repository = _context.Repositories.Find(id);
        if (repository == null)
        {
            return NotFound();
        }
        return Ok(repository);
    }

    [HttpPost]
    public IActionResult CreateRepository([FromBody] Repository repository)
    {
        _context.Repositories.Add(repository);
        _context.SaveChanges();
        return CreatedAtAction(nameof(GetRepository), new { id = repository.Id }, repository);
    }
}