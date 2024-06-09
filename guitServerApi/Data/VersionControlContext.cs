using Microsoft.EntityFrameworkCore;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Collections.Generic;

public class VersionControlContext : DbContext
{
    public VersionControlContext(DbContextOptions<VersionControlContext> options) : base(options) { }

    public DbSet<Repository> Repositories { get; set; }
    public DbSet<Commit> Commits { get; set; }
    public DbSet<File> Files { get; set; }
    public DbSet<FileDelta> FileDeltas { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Commit>(entity =>
        {
            entity.ToTable("Commits");
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.RepositoryId).HasColumnName("repository_id");
            entity.Property(e => e.CommitHash).HasColumnName("commit_hash");
            entity.Property(e => e.Message).HasColumnName("message");
            entity.Property(e => e.CreatedAt).HasColumnName("created_at");
        });

        modelBuilder.Entity<Repository>(entity =>
        {
            entity.ToTable("Repositories");
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Name).HasColumnName("name");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.CreatedAt).HasColumnName("created_at");
        });

        modelBuilder.Entity<File>(entity =>
        {
            entity.ToTable("Files");
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.RepositoryId).HasColumnName("repository_id");
            entity.Property(e => e.FilePath).HasColumnName("file_path");
            entity.Property(e => e.CreatedAt).HasColumnName("created_at");
        });

        modelBuilder.Entity<FileDelta>(entity =>
        {
            entity.ToTable("FileDeltas");
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.FileId).HasColumnName("file_id");
            entity.Property(e => e.CommitId).HasColumnName("commit_id");
            entity.Property(e => e.Delta).HasColumnName("delta");
            entity.Property(e => e.CreatedAt).HasColumnName("created_at");
        });

        base.OnModelCreating(modelBuilder);
    }
}
public class Repository
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("name")]
    [Required]
    [StringLength(255)]
    public string Name { get; set; }

    [Column("description")]
    public string Description { get; set; }

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }

    public ICollection<Commit> Commits { get; set; }
}

public class Commit
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("repository_id")]
    public int RepositoryId { get; set; }

    [Column("commit_hash")]
    [Required]
    [StringLength(64)]
    public string CommitHash { get; set; }

    [Column("message")]
    public string Message { get; set; }

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }

    public Repository Repository { get; set; }
}


public class File
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("repository_id")]
    public int RepositoryId { get; set; }

    [Column("file_path")]
    [Required]
    [StringLength(255)]
    public string FilePath { get; set; }

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }

    public Repository Repository { get; set; }
}
public class FileDelta
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("file_id")]
    public int FileId { get; set; }

    [Column("commit_id")]
    public int CommitId { get; set; }

    [Column("delta")]
    [Required]
    public byte[] Delta { get; set; }

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }

    public File File { get; set; }
    public Commit Commit { get; set; }
}
