using Microsoft.AspNetCore.Mvc;
using System.Linq;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DiffMatchPatch;
using Operation = Microsoft.AspNetCore.JsonPatch.Operations.Operation;

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
    /// <param name="repositoryName">The repository name.</param>
    /// <param name="message">The commit message.</param>
    /// <param name="files">The files to commit.</param>
    /// <returns>The created commit.</returns>
    [HttpPost("{repositoryName}/commit")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> CommitChanges(string repositoryName, [FromForm] string message, [FromForm] List<IFormFile> files)
    {
        var repository = _context.Repositories.FirstOrDefault(r => r.Name == repositoryName);
        if (repository == null)
        {
            return NotFound("Repository not found.");
        }

        var commit = new Commit
        {
            RepositoryId = repository.Id,
            CommitHash = Guid.NewGuid().ToString(), // Generar un hash de commit único
            Message = message,
            CreatedAt = DateTime.UtcNow
        };

        _context.Commits.Add(commit);
        _context.SaveChanges();

        var storagePath = Path.Combine("/path/to/your/storage", repositoryName); // Actualiza el path según sea necesario

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

            var existingFile = _context.Files.FirstOrDefault(f => f.RepositoryId == repository.Id && f.FilePath == filePath);

            if (existingFile == null)
            {
                var newFile = new File
                {
                    RepositoryId = repository.Id,
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
                var previousContent = Encoding.UTF8.GetString(GetPreviousFileContent(existingFile.Id));
                var newContent = System.IO.File.ReadAllText(filePath);
                var delta = CalculateDelta(previousContent, newContent);

                var fileDelta = new FileDelta
                {
                    FileId = existingFile.Id,
                    CommitId = commit.Id,
                    Delta = Encoding.UTF8.GetBytes(delta), // Almacenar solo los cambios
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

    /// <summary>
    /// Rollback a file to a specific commit version.
    /// </summary>
    /// <param name="repositoryName">The repository name.</param>
    /// <param name="filename">The filename to rollback.</param>
    /// <param name="commitHash">The commit hash to rollback to.</param>
    /// <returns>The file content at the specified commit.</returns>
    [HttpGet("{repositoryName}/rollback")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public IActionResult RollbackFile(string repositoryName, [FromQuery] string filename, [FromQuery] string commitHash)
    {
        var repository = _context.Repositories.FirstOrDefault(r => r.Name == repositoryName);
        if (repository == null)
        {
            return NotFound("Repository not found.");
        }

        var commit = _context.Commits.FirstOrDefault(c => c.RepositoryId == repository.Id && c.CommitHash == commitHash);
        if (commit == null)
        {
            return NotFound("Commit not found.");
        }

        var file = _context.Files.FirstOrDefault(f => f.RepositoryId == repository.Id && f.FilePath.EndsWith(filename));
        if (file == null)
        {
            return NotFound("File not found.");
        }

        var fileDeltas = _context.FileDeltas
            .Where(fd => fd.FileId == file.Id && fd.CommitId <= commit.Id)
            .OrderBy(fd => fd.CreatedAt)
            .ToList();

        var fileContent = ReconstructFileContent(fileDeltas);

        return File(fileContent, "application/octet-stream", filename);
    }

    /// <summary>
    /// Gets the status of a file, showing its change history.
    /// </summary>
    /// <param name="repositoryName">The repository name.</param>
    /// <param name="filename">The filename to get the status for.</param>
    /// <returns>The change history of the file.</returns>
    [HttpGet("{repositoryName}/status")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public IActionResult GetFileStatus(string repositoryName, [FromQuery] string filename)
    {
        var repository = _context.Repositories.FirstOrDefault(r => r.Name == repositoryName);
        if (repository == null)
        {
            return NotFound("Repository not found.");
        }

        var file = _context.Files.FirstOrDefault(f => f.RepositoryId == repository.Id && f.FilePath.EndsWith(filename));
        if (file == null)
        {
            return NotFound("File not found.");
        }

        var fileDeltas = _context.FileDeltas
            .Where(fd => fd.FileId == file.Id)
            .OrderBy(fd => fd.CreatedAt)
            .ToList();

        var status = new StringBuilder();
        var dmp = new diff_match_patch();
        string previousContent = "";

        foreach (var delta in fileDeltas)
        {
            var commit = _context.Commits.FirstOrDefault(c => c.Id == delta.CommitId);
            if (commit != null)
            {
                var newContent = Encoding.UTF8.GetString(delta.Delta);
                var diffs = dmp.diff_main(previousContent, newContent);
                dmp.diff_cleanupSemantic(diffs);

                status.AppendLine($"Commit Hash: {commit.CommitHash}");
                status.AppendLine($"Commit Date: {commit.CreatedAt}");
                status.AppendLine("Changes:");

                foreach (var diff in diffs)
                {
                    switch (diff.operation)
                    {
                        case Operation.INSERT:
                            status.AppendLine($"Added: {diff.text}");
                            break;
                        case Operation.DELETE:
                            status.AppendLine($"Deleted: {diff.text}");
                            break;
                        case Operation.EQUAL:
                            status.AppendLine($"Modified: {diff.text}");
                            break;
                    }
                }
                status.AppendLine(new string('-', 40));
                previousContent = newContent;
            }
        }

        return Ok(status.ToString());
    }

    private byte[] ReconstructFileContent(List<FileDelta> fileDeltas)
    {
        var dmp = new diff_match_patch();
        string fileContent = "";
        foreach (var delta in fileDeltas)
        {
            var diffs = dmp.diff_fromDelta(fileContent, Encoding.UTF8.GetString(delta.Delta));
            fileContent = dmp.diff_text2(diffs);
        }

        return Encoding.UTF8.GetBytes(fileContent);
    }

    private byte[] GetPreviousFileContent(int fileId)
    {
        var fileDeltas = _context.FileDeltas
            .Where(fd => fd.FileId == fileId)
            .OrderBy(fd => fd.CreatedAt)
            .ToList();

        return ReconstructFileContent(fileDeltas);
    }

    private string CalculateDelta(string oldContent, string newContent)
    {
        var dmp = new diff_match_patch();
        var diffs = dmp.diff_main(oldContent, newContent);
        dmp.diff_cleanupSemantic(diffs);
        return dmp.diff_toDelta(diffs);
    }
}