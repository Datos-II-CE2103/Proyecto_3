using Microsoft.AspNetCore.Mvc;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using System.Linq;
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

    /// <summary>
    /// Creates a new repository.
    /// </summary>
    /// <param name="request">The repository creation request.</param>
    /// <returns>A newly created repository.</returns>
    [HttpPost("init")]
    public IActionResult CreateRepository([FromBody] CreateRepositoryRequest request)
    {
        if (string.IsNullOrEmpty(request.Name))
        {
            return BadRequest("The repository name cannot be empty.");
        }

        var repository = new Repository
        {
            Name = request.Name,
            Description = request.Description,
            CreatedAt = DateTime.UtcNow
        };

        _context.Repositories.Add(repository);
        _context.SaveChanges();

        return CreatedAtAction(nameof(GetRepository), new { id = repository.Id }, repository);
    }

    /// <summary>
    /// Gets a repository by ID.
    /// </summary>
    /// <param name="id">The repository ID.</param>
    /// <returns>The repository with the specified ID.</returns>
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
}
