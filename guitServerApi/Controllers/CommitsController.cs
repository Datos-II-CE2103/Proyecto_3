using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.IO;
using IOFile = System.IO.File;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DiffMatchPatch;
using Microsoft.EntityFrameworkCore;

[Route("api/[controller]")]
[ApiController]
public class CommitsController : ControllerBase
{
    private readonly VersionControlContext _context;

    public CommitsController(VersionControlContext context)
    {
        _context = context;
    }

    [HttpPost("{repositoryId}/commit")]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> CommitChanges(int repositoryId, [FromForm] string message, [FromForm] List<IFormFile> files, [FromForm] List<string> filePaths)
    {
        var repository = await _context.Repositories.FirstOrDefaultAsync(r => r.Id == repositoryId);

        if (repository == null)
        {
            return NotFound("Repository not found.");
        }

        using (var transaction = await _context.Database.BeginTransactionAsync())
        {
            try
            {
                var commit = new Commit
                {
                    RepositoryId = repository.Id,
                    CommitHash = Guid.NewGuid().ToString(),
                    Message = message,
                    CreatedAt = DateTime.UtcNow
                };

                _context.Commits.Add(commit);
                await _context.SaveChangesAsync();

                var storageBasePath = Path.Combine("../.STORAGE/", $"{repository.Id}.{repository.Name}");

                if (!Directory.Exists(storageBasePath))
                {
                    Directory.CreateDirectory(storageBasePath);
                }

                for (int i = 0; i < files.Count; i++)
                {
                    var file = files[i];
                    var relativePath = filePaths[i];

                    var filePath = Path.Combine(storageBasePath, relativePath);

                    var directoryPath = Path.GetDirectoryName(filePath);
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }

                    var existingFile = _context.Files.FirstOrDefault(f => f.RepositoryId == repositoryId && f.FilePath == filePath);

                    string newContent;
                    using (var reader = new StreamReader(file.OpenReadStream()))
                    {
                        newContent = await reader.ReadToEndAsync();
                    }

                    bool isModified = false;

                    if (existingFile == null)
                    {
                        var newFile = new File
                        {
                            RepositoryId = repositoryId,
                            FilePath = filePath,
                            CreatedAt = DateTime.UtcNow
                        };

                        _context.Files.Add(newFile);
                        await _context.SaveChangesAsync();

                        var fileDelta = new FileDelta
                        {
                            FileId = newFile.Id,
                            CommitId = commit.Id,
                            Delta = Encoding.UTF8.GetBytes(newContent),
                            CreatedAt = DateTime.UtcNow
                        };

                        _context.FileDeltas.Add(fileDelta);
                        isModified = true;
                    }
                    else
                    {
                        string previousContent = System.IO.File.Exists(filePath) ? System.IO.File.ReadAllText(filePath) : string.Empty;

                        if (previousContent != newContent)
                        {
                            var dmp = new diff_match_patch();
                            var diffs = dmp.diff_main(previousContent, newContent);
                            dmp.diff_cleanupSemantic(diffs);

                            var delta = dmp.diff_toDelta(diffs);

                            var fileDelta = new FileDelta
                            {
                                FileId = existingFile.Id,
                                CommitId = commit.Id,
                                Delta = Encoding.UTF8.GetBytes(delta),
                                CreatedAt = DateTime.UtcNow
                            };

                            _context.FileDeltas.Add(fileDelta);
                            isModified = true;
                        }
                    }

                    if (isModified)
                    {
                        System.IO.File.WriteAllText(filePath, newContent);
                    }
                }

                await _context.SaveChangesAsync();

                await transaction.CommitAsync();
                return CreatedAtAction(nameof(GetCommit), new { id = commit.Id }, commit);
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                Console.WriteLine($"Error: {ex.Message}");
                throw;
            }
        }
    }

    private string GetPreviousFilePath(int fileId)
    {
        var previousFile = _context.Files.FirstOrDefault(f => f.Id == fileId);
        return previousFile?.FilePath;
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
            if (diff.operation == null) continue;

            result.Append(diff.operation.ToString()).Append(": ").Append(diff.text).AppendLine();
        }
        return result.ToString();
    }

    private List<Diff> stringToDiffs(string deltaText)
    {
        var diffs = new List<Diff>();
        var lines = deltaText.Split(new[] { Environment.NewLine }, StringSplitOptions.None);

        foreach (var line in lines)
        {
            if (string.IsNullOrWhiteSpace(line)) continue;

            var parts = line.Split(new[] { ": " }, 2, StringSplitOptions.None);

            if (parts.Length != 2)
            {
                throw new FormatException("Formato de diffs incorrecto. Se esperaba 'Operation: Text'");
            }

            if (!Enum.TryParse<Operation>(parts[0], true, out var operation))
            {
                throw new ArgumentException($"Valor de operación no válido: {parts[0]}.");
            }

            var text = parts[1];
            diffs.Add(new Diff(operation, text));
        }

        return diffs;
    }
}