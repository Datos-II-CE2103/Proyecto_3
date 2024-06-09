using Microsoft.AspNetCore.Mvc;
using System.Linq;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;


[Route("api/[controller]")]
[ApiController]
public class CommitsController : ControllerBase
{
    private readonly VersionControlContext _context;

    public CommitsController(VersionControlContext context)
    {
        _context = context;
    }

    /// <summary>
    /// Commits changes to a repository.
    /// </summary>
    /// <param name="repositoryId">The repository ID.</param>
    /// <param name="message">The commit message.</param>
    /// <param name="files">The files to commit.</param>
    /// <returns>The created commit.</returns>
    [HttpPost("{repositoryId}/commit")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> CommitChanges(int repositoryId, [FromForm] string message, [FromForm] List<IFormFile> files)
    {
        var repository = _context.Repositories.Find(repositoryId);
        if (repository == null)
        {
            return NotFound("Repository not found.");
        }

        var commit = new Commit
        {
            RepositoryId = repositoryId,
            CommitHash = Guid.NewGuid().ToString(), // Generar un hash de commit único
            Message = message,
            CreatedAt = DateTime.UtcNow
        };

        _context.Commits.Add(commit);
        _context.SaveChanges();

        var storagePath = Path.Combine("../STORAGE/", repositoryId.ToString()); // Actualiza el path según sea necesario

        // Verificar y crear el directorio si no existe
        if (!Directory.Exists(storagePath))
        {
            Directory.CreateDirectory(storagePath);
        }

        foreach (var file in files)
        {
            var filePath = Path.Combine(storagePath, file.FileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

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
                _context.SaveChanges();

                var fileDelta = new FileDelta
                {
                    FileId = newFile.Id,
                    CommitId = commit.Id,
                    Delta = System.IO.File.ReadAllBytes(filePath), // Almacenar el contenido completo como delta inicial
                    CreatedAt = DateTime.UtcNow
                };

                _context.FileDeltas.Add(fileDelta);
            }
            else
            {
                var previousContent = GetPreviousFileContent(existingFile.Id);
                var delta = CalculateDelta(previousContent, System.IO.File.ReadAllBytes(filePath));

                var fileDelta = new FileDelta
                {
                    FileId = existingFile.Id,
                    CommitId = commit.Id,
                    Delta = delta, // Almacenar solo los cambios
                    CreatedAt = DateTime.UtcNow
                };

                _context.FileDeltas.Add(fileDelta);
            }
        }

        _context.SaveChanges();

        return CreatedAtAction(nameof(GetCommit), new { id = commit.Id }, commit);
    }

    /// <summary>
    /// Gets a commit by ID.
    /// </summary>
    /// <param name="id">The commit ID.</param>
    /// <returns>The commit with the specified ID.</returns>
    [HttpGet("{id}")]
    public IActionResult GetCommit(int id)
    {
        var commit = _context.Commits.Find(id);
        if (commit == null)
        {
            return NotFound();
        }

        return Ok(commit);
    }

    private byte[] GetPreviousFileContent(int fileId)
    {
        // Implementa la lógica para recuperar el contenido anterior del archivo
        return new byte[0];
    }

    private byte[] CalculateDelta(byte[] oldContent, byte[] newContent)
    {
        // Implementa la lógica para calcular el delta entre el contenido antiguo y el nuevo
        return newContent;
    }
}
