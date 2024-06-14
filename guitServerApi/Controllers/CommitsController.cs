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
using System.Security.Cryptography;
using System.Text;


[Route("api/[controller]")]
[ApiController]
public class CommitsController : ControllerBase
{
    private readonly VersionControlContext _context;

    public CommitsController(VersionControlContext context)
    {
        _context = context;
    }

    
    // Nuevo endpoint para el reset
    [HttpGet("api/Commits/{repositoryId}/reset")]
    public IActionResult ResetFile(string repositoryId, string filename)
    {
        try
        {
            // Obtener el archivo especificado por el repositorio y nombre de archivo
            var repository = _context.Repositories.FirstOrDefault(r => r.Id.ToString() == repositoryId);
            if (repository == null)
            {
                return NotFound("Repository not found.");
            }

            var file = _context.Files.FirstOrDefault(f => f.RepositoryId == repository.Id && f.FilePath.EndsWith(filename));
            if (file == null)
            {
                return NotFound("File not found.");
            }

            // Obtener el último commit aplicado al archivo 
            var latestCommit = _context.FileDeltas
                .Where(fd => fd.FileId == file.Id)
                .OrderByDescending(fd => fd.CreatedAt)
                .FirstOrDefault();

            if (latestCommit == null)
            {
                return NotFound("No se encontraron commits para este archivo");
            }

            // Reconstruir el contenido del archivo a partir del último commit
            string fileContent = ReconstructFileContent(new List<FileDelta> { latestCommit });

            // Retornar el archivo resultante
            return File(Encoding.UTF8.GetBytes(fileContent), "application/octet-stream", filename);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Error interno del servidor: {ex.Message}");
        }
    }
    
    
    public static string GenerateMD5Hash(string input)
    {
        using (var md5 = MD5.Create())
        {
            var inputBytes = Encoding.UTF8.GetBytes(input);
            var hashBytes = md5.ComputeHash(inputBytes);
            var sb = new StringBuilder();
            for (int i = 0; i < hashBytes.Length; i++)
            {
                sb.Append(hashBytes[i].ToString("x2"));
            }
            return sb.ToString();
        }
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
            string commitInput = message + DateTime.UtcNow.ToString();
            string commitHash = GenerateMD5Hash(commitInput);

            var commit = new Commit
            {
                RepositoryId = repository.Id,
                CommitHash = commitHash,
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
    
                    // Generar un parche inicial con el contenido completo del archivo
                    var dmp = new diff_match_patch();
                    var diffs = dmp.diff_main(string.Empty, newContent);
                    dmp.diff_cleanupSemantic(diffs);
                    var patches = dmp.patch_make(string.Empty, diffs);
                    var patchText = dmp.patch_toText(patches);
    
                    var fileDelta = new FileDelta 
                    { 
                        FileId = newFile.Id, 
                        CommitId = commit.Id, 
                        Delta = Encoding.UTF8.GetBytes(patchText),
                        CreatedAt = DateTime.UtcNow 
                    }; 
                    _context.FileDeltas.Add(fileDelta); 
                    isModified = true; 
                    System.IO.File.WriteAllText(filePath, newContent); 
                } 
                else 
                { 
                    string previousContent = System.IO.File.Exists(filePath) ? System.IO.File.ReadAllText(filePath) : string.Empty; 
                    if (previousContent != newContent) 
                    { 
                        var dmp = new diff_match_patch(); 
                        var diffs = dmp.diff_main(previousContent, newContent); 
                        dmp.diff_cleanupSemantic(diffs); 
        
                        // Generar parches a partir de las diferencias
                        var patches = dmp.patch_make(previousContent, diffs); 
                        var patchText = dmp.patch_toText(patches); 
        
                        var fileDelta = new FileDelta 
                        { 
                            FileId = existingFile.Id, 
                            CommitId = commit.Id, 
                            Delta = Encoding.UTF8.GetBytes(patchText), 
                            CreatedAt = DateTime.UtcNow 
                        }; 
                        _context.FileDeltas.Add(fileDelta); 
                        isModified = true; 
        
                        // Aplicar parches al contenido anterior para obtener el nuevo contenido
                        var result = dmp.patch_apply(patches, previousContent); 
                        System.IO.File.WriteAllText(filePath, result[0].ToString()); 
                    } 
                }
                if (isModified)
                {
                    await _context.SaveChangesAsync();
                }
            }

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

    [HttpGet("{repositoryId}/rollback")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public IActionResult RollbackFile(string repositoryId, [FromQuery] string filename, [FromQuery] string commitHash)
    {
        var repository = _context.Repositories.FirstOrDefault(r => r.Id.ToString() == repositoryId);
        if (repository == null)
        {
            return NotFound("Repository not found.");
        }

        var targetCommit = _context.Commits.FirstOrDefault(c => c.RepositoryId == repository.Id && c.CommitHash == commitHash);
        if (targetCommit == null)
        {
            return NotFound("Commit not found.");
        }

        var file = _context.Files.FirstOrDefault(f => f.RepositoryId == repository.Id && f.FilePath.EndsWith(filename));
        if (file == null)
        {
            return NotFound("File not found.");
        }

        var fileDeltas = _context.FileDeltas
            .Where(fd => fd.FileId == file.Id && fd.CommitId <= targetCommit.Id)
            .OrderBy(fd => fd.CreatedAt)
            .ToList();

        var fileContent = ReconstructFileContent(fileDeltas);

        // Construir el path completo utilizando el formato id.name y filename
        string fullPath = $"{filename}";

        return File(Encoding.UTF8.GetBytes(fileContent), "application/octet-stream", fullPath);
    }

    private string ReconstructFileContent(List<FileDelta> deltas)
    {
        var dmp = new diff_match_patch();
        string reconstructedContent = string.Empty;

        foreach (var delta in deltas)
        {
            string deltaString = Encoding.UTF8.GetString(delta.Delta);
            if (dmp.patch_fromText(deltaString).Count > 0) // Verifica si es un parche válido
            {
                var patches = dmp.patch_fromText(deltaString);
                var result = dmp.patch_apply(patches, reconstructedContent);
                reconstructedContent = result[0].ToString();
            }
            else
            {
                Console.WriteLine($"Invalid patch string: {deltaString}");
            }
        }

        return reconstructedContent;
    }

  [HttpGet("{repositoryId}/status")]
[ProducesResponseType(StatusCodes.Status200OK)]
[ProducesResponseType(StatusCodes.Status404NotFound)]
public IActionResult GetFileStatus(string repositoryId, [FromQuery] string filename = null)
{
    // Buscar el repositorio usando repositoryId
    var repository = _context.Repositories.FirstOrDefault(r => r.Id.ToString() == repositoryId);
    if (repository == null)
    {
        return NotFound("Repository not found.");
    }

    if (string.IsNullOrEmpty(filename))
    {
        // Obtener los archivos modificados en el último commit
        var lastCommit = _context.Commits
            .Where(c => c.RepositoryId == repository.Id)
            .OrderByDescending(c => c.CreatedAt)
            .FirstOrDefault();

        if (lastCommit == null)
        {
            return NotFound("No commits found in the repository.");
        }

        var modifiedFiles = _context.FileDeltas
            .Where(fd => fd.CommitId == lastCommit.Id)
            .Select(fd => fd.File.FilePath)
            .ToList();

        var response = new
        {
            LastCommitHash = lastCommit.CommitHash,
            LastCommitDate = lastCommit.CreatedAt,
            ModifiedFiles = modifiedFiles
        };

        return Ok(response);
    }
    else
    {
        // Buscar el archivo específico en el repositorio
        var file = _context.Files
            .FirstOrDefault(f => f.RepositoryId == repository.Id && f.FilePath.EndsWith(filename));

        if (file == null)
        {
            return NotFound("File not found.");
        }

        // Obtener los deltas del archivo específico
        var fileDeltas = _context.FileDeltas
            .Where(fd => fd.FileId == file.Id)
            .OrderBy(fd => fd.CreatedAt)
            .ToList();

        if (fileDeltas.Count == 0)
        {
            return NotFound("No deltas found for the specified file.");
        }

        var deltas = fileDeltas.Select(delta => new
        {
            CommitHash = _context.Commits.FirstOrDefault(c => c.Id == delta.CommitId)?.CommitHash,
            CommitDate = _context.Commits.FirstOrDefault(c => c.Id == delta.CommitId)?.CreatedAt,
            Changes = Encoding.UTF8.GetString(delta.Delta)
        }).ToList();

        return Ok(deltas);
    }
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