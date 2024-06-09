using Microsoft.AspNetCore.Mvc;
using System.Linq;

[Route("api/[controller]")]
[ApiController]
public class CommitsController : ControllerBase
{
    private readonly VersionControlContext _context;

    public CommitsController(VersionControlContext context)
    {
        _context = context;
    }

    [HttpGet("{repositoryId}")]
    public IActionResult GetCommits(int repositoryId)
    {
        var commits = _context.Commits
            .Where(c => c.RepositoryId == repositoryId)
            .Select(c => new { c.CommitHash, c.Message, c.CreatedAt })
            .ToList();
        return Ok(commits);
    }

    [HttpPost]
    public IActionResult CreateCommit([FromBody] Commit commit)
    {
        _context.Commits.Add(commit);
        _context.SaveChanges();
        return CreatedAtAction(nameof(GetCommits), new { repositoryId = commit.RepositoryId }, commit);
    }
}