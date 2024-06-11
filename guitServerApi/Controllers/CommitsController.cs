using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DiffMatchPatch;

[Route("api/[controller]")]
[ApiController]
public class CommitsController : ControllerBase
{
    private readonly VersionControlContext _context;

    public CommitsController(VersionControlContext context)
    {
        _context = context;
    }

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

        var storagePath = Path.Combine("/.STORAGE/", repositoryName); // Actualiza el path según sea necesario

        // Verificar y crear el directorio si no existe
        if (!Directory.Exists(storagePath))
        {
            Directory.CreateDirectory(storagePath);
        }

        var dmp = new diff_match_patch();

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
                    Delta = Encoding.UTF8.GetBytes(System.IO.File.ReadAllText(filePath)), // Almacenar el contenido completo como delta inicial
                    CreatedAt = DateTime.UtcNow
                };

                _context.FileDeltas.Add(fileDelta);
            }
            else
            {
                var previousContent = Encoding.UTF8.GetString(GetPreviousFileContent(existingFile.Id));
                var newContent = System.IO.File.ReadAllText(filePath);
                var diffs = dmp.diff_main(previousContent, newContent);
                dmp.diff_cleanupSemantic(diffs);
                var delta = diffsToString(diffs);

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

        foreach (var delta in fileDeltas)
        {
            var commit = _context.Commits.FirstOrDefault(c => c.Id == delta.CommitId);
            if (commit != null)
            {
                status.AppendLine($"Commit Hash: {commit.CommitHash}");
                status.AppendLine($"Commit Date: {commit.CreatedAt}");
                status.AppendLine("Changes:");

                var deltaText = Encoding.UTF8.GetString(delta.Delta);
                status.AppendLine(deltaText);

                status.AppendLine(new string('-', 40));
            }
        }

        return Ok(status.ToString());
    }

    private string ReconstructFileContent(List<FileDelta> fileDeltas)
    {
        var dmp = new diff_match_patch();
        string fileContent = "";
        foreach (var delta in fileDeltas)
        {
            var deltaText = Encoding.UTF8.GetString(delta.Delta);
            var diffs = stringToDiffs(deltaText);
            fileContent = dmp.diff_text2(diffs);
        }

        return fileContent;
    }

    private byte[] GetPreviousFileContent(int fileId)
    {
        var fileDeltas = _context.FileDeltas
            .Where(fd => fd.FileId == fileId)
            .OrderBy(fd => fd.CreatedAt)
            .ToList();

        return Encoding.UTF8.GetBytes(ReconstructFileContent(fileDeltas));
    }

    private string CalculateDelta(string oldContent, string newContent)
    {
        var dmp = new diff_match_patch();
        var diffs = dmp.diff_main(oldContent, newContent);
        dmp.diff_cleanupSemantic(diffs);
        return diffsToString(diffs);
    }

    private string diffsToString(List<Diff> diffs)
    {
        var result = new StringBuilder();
        foreach (var diff in diffs)
        {
            result.Append(diff.operation.ToString()).Append(": ").Append(diff.text).AppendLine();
        }
        return result.ToString();
    }

    private List<Diff> stringToDiffs(string deltaText)
    {
        var dmp = new diff_match_patch();
        var diffs = new List<Diff>();
        var lines = deltaText.Split(new[] { Environment.NewLine }, StringSplitOptions.None);
        foreach (var line in lines)
        {
            if (string.IsNullOrWhiteSpace(line))
                continue;

            var parts = line.Split(new[] { ": " }, 2, StringSplitOptions.None);
            if (parts.Length != 2)
                continue;

            var operation = (Operation)Enum.Parse(typeof(Operation), parts[0]);
            var text = parts[1];

            diffs.Add(new Diff(operation, text));
        }
        return diffs;
    }
}