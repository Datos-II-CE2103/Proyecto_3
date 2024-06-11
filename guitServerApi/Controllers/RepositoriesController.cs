using Microsoft.AspNetCore.Mvc;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using guitApiServer.Models;

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

    /// <summary>
    /// Adds files to a repository.
    /// </summary>
    /// <param name="repositoryId">The repository ID.</param>
    /// <param name="request">The file addition request.</param>
    /// <returns>A list of added files.</returns>
    [HttpPost("{repositoryId}/add")]
    public IActionResult AddFiles(int repositoryId, [FromBody] AddFilesRequest request)
    {
        var repository = _context.Repositories.Find(repositoryId);
        if (repository == null)
        {
            return NotFound("Repository not found.");
        }

        var directoryPath = "./STORAGE/"; 
        var filesToAdd = new List<string>();

        if (request.AddAll)
        {
            filesToAdd = Directory.GetFiles(directoryPath).ToList();
        }
        else
        {
            filesToAdd = request.FileNames.Select(name => Path.Combine(directoryPath, name)).ToList();
        }

        var addedFiles = new List<File>();

        foreach (var filePath in filesToAdd)
        {
            if (!System.IO.File.Exists(filePath)) continue;

            var fileName = Path.GetFileName(filePath);

            // Check if the file is already added and if it has changes
            var existingFile = _context.Files.FirstOrDefault(f => f.RepositoryId == repositoryId && f.FilePath == filePath);

            if (existingFile == null)
            {
                var newFile = new File
                {
                    RepositoryId = repositoryId,
                    FilePath = filePath,
                    CreatedAt = DateTime.UtcNow
                };

                _context.Files.Add(newFile);
                addedFiles.Add(newFile);
            }
            else
            {
                // Logic to check for changes in the file can be added here
                // For simplicity, we assume any existing file is already up to date
            }
        }

        _context.SaveChanges();

        return Ok(addedFiles);
    }

    /// <summary>
    /// Gets a file by ID.
    /// </summary>
    /// <param name="id">The file ID.</param>
    /// <returns>The file with the specified ID.</returns>
    [HttpGet("files/{id}")]
    public IActionResult GetFile(int id)
    {
        var file = _context.Files.Find(id);
        if (file == null)
        {
            return NotFound();
        }

        return Ok(file);
    }
}

