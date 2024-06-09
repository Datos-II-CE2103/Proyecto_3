using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;

[Route("api/[controller]")]
[ApiController]
public class FileDeltasController : ControllerBase
{
    private readonly VersionControlContext _context;

    public FileDeltasController(VersionControlContext context)
    {
        _context = context;
    }

    [HttpGet("{fileId}")]
    public IActionResult GetFileDeltas(int fileId)
    {
        var fileDeltas = _context.FileDeltas.Where(fd => fd.FileId == fileId).ToList();
        return Ok(fileDeltas);
    }

    [HttpPost]
    public IActionResult CreateFileDelta([FromBody] FileDelta fileDelta)
    {
        _context.FileDeltas.Add(fileDelta);
        _context.SaveChanges();
        return CreatedAtAction(nameof(GetFileDeltas), new { fileId = fileDelta.FileId }, fileDelta);
    }
}