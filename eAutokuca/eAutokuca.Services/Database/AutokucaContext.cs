﻿using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace eAutokuca.Services.Database;

public partial class AutokucaContext : DbContext
{
    public AutokucaContext()
    {
    }

    public AutokucaContext(DbContextOptions<AutokucaContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Autodio> Autodios { get; set; }

    public virtual DbSet<Automobil> Automobils { get; set; }

    public virtual DbSet<AutomobilFavoriti> AutomobilFavoritis { get; set; }

    public virtual DbSet<Komentari> Komentaris { get; set; }

    public virtual DbSet<Korisnik> Korisniks { get; set; }

    public virtual DbSet<KorisnikUloga> KorisnikUlogas { get; set; }

    public virtual DbSet<Narudzba> Narudzbas { get; set; }

    public virtual DbSet<Oprema> Opremas { get; set; }

    public virtual DbSet<Recenzije> Recenzijes { get; set; }

    public virtual DbSet<Report> Reports { get; set; }

    public virtual DbSet<Rezervacija> Rezervacijas { get; set; }

    public virtual DbSet<StavkeNarudzbe> StavkeNarudzbes { get; set; }

    public virtual DbSet<Uloga> Ulogas { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=localhost;Database=Autokuca;Integrated Security=True; TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Autodio>(entity =>
        {
            entity.HasKey(e => e.AutodioId).HasName("PK__Autodio__5813BB70C93ED3A2");

            entity.ToTable("Autodio");

            entity.Property(e => e.AutodioId).HasColumnName("AutodioID");
            entity.Property(e => e.Cijena).HasColumnType("decimal(8, 2)");
            entity.Property(e => e.Naziv).HasMaxLength(255);
            entity.Property(e => e.Opis).HasMaxLength(255);
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Automobil>(entity =>
        {
            entity.HasKey(e => e.AutomobilId).HasName("PK__Automobi__BCB35E43C615916D");

            entity.ToTable("Automobil");

            entity.Property(e => e.AutomobilId).HasColumnName("AutomobilID");
            entity.Property(e => e.Boja).HasMaxLength(30);
            entity.Property(e => e.BrojSasije)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.Cijena).HasColumnType("decimal(8, 2)");
            entity.Property(e => e.Marka).HasMaxLength(30);
            entity.Property(e => e.Mjenjac)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.Model).HasMaxLength(30);
            entity.Property(e => e.Motor)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.PredjeniKilometri).HasColumnType("decimal(8, 2)");
            entity.Property(e => e.SnagaMotora)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<AutomobilFavoriti>(entity =>
        {
            entity.HasKey(e => e.FavoritId).HasName("PK__Automobi__C32DB3CCE66E62F2");

            entity.ToTable("AutomobilFavoriti");

            entity.HasIndex(e => e.AutomobilId, "IX_AutomobilFavoriti_AutomobilId");

            entity.HasIndex(e => e.KorisnikId, "IX_AutomobilFavoriti_KorisnikId");

            entity.HasOne(d => d.Automobil).WithMany(p => p.AutomobilFavoritis)
                .HasForeignKey(d => d.AutomobilId)
                .HasConstraintName("FK__Automobil__Autom__02FC7413");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.AutomobilFavoritis)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Automobil__Koris__03F0984C");
        });

        modelBuilder.Entity<Komentari>(entity =>
        {
            entity.HasKey(e => e.KomentarId).HasName("PK__Komentar__C0C304BC02E648F7");

            entity.ToTable("Komentari");

            entity.HasIndex(e => e.AutomobilId, "IX_Komentari_AutomobilID");

            entity.HasIndex(e => e.KorisnikId, "IX_Komentari_KorisnikID");

            entity.Property(e => e.KomentarId).HasColumnName("KomentarID");
            entity.Property(e => e.AutomobilId).HasColumnName("AutomobilID");
            entity.Property(e => e.DatumDodavanja).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Sadrzaj).HasMaxLength(255);

            entity.HasOne(d => d.Automobil).WithMany(p => p.Komentaris)
                .HasForeignKey(d => d.AutomobilId)
                .HasConstraintName("FK__Komentari__Autom__7D439ABD");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Komentaris)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Komentari__Koris__7C4F7684");
        });

        modelBuilder.Entity<Korisnik>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnik__80B06D61C49C1C70");

            entity.ToTable("Korisnik");

            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.DatumRegistracije).HasColumnType("datetime");
            entity.Property(e => e.Email)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("EMAIL");
            entity.Property(e => e.Ime).HasMaxLength(255);
            entity.Property(e => e.LozinkaHash)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.LozinkaSalt)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Prezime).HasMaxLength(255);
            entity.Property(e => e.Telefon)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.Username)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<KorisnikUloga>(entity =>
        {
            entity.HasKey(e => e.KorisnikUlogaId).HasName("PK__Korisnik__1608720ED913A86C");

            entity.ToTable("KorisnikUloga");

            entity.HasIndex(e => e.KorisnikId, "IX_KorisnikUloga_KorisnikID");

            entity.HasIndex(e => e.UlogaId, "IX_KorisnikUloga_UlogaID");

            entity.Property(e => e.KorisnikUlogaId).HasColumnName("KorisnikUlogaID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.KorisnikUlogas)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__KorisnikU__Koris__3B75D760");

            entity.HasOne(d => d.Uloga).WithMany(p => p.KorisnikUlogas)
                .HasForeignKey(d => d.UlogaId)
                .HasConstraintName("FK__KorisnikU__Uloga__3C69FB99");
        });

        modelBuilder.Entity<Narudzba>(entity =>
        {
            entity.HasKey(e => e.NarudzbaId).HasName("PK__Narudzba__FBEC1357356F6270");

            entity.ToTable("Narudzba");

            entity.HasIndex(e => e.KorisnikId, "IX_Narudzba_KorisnikID");

            entity.Property(e => e.NarudzbaId).HasColumnName("NarudzbaID");
            entity.Property(e => e.BrojTransakcije).IsUnicode(false);
            entity.Property(e => e.DatumNarudzbe).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.UkupniIznos).HasColumnType("decimal(8, 2)");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Narudzbas)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Narudzba__Korisn__571DF1D5");
        });

        modelBuilder.Entity<Oprema>(entity =>
        {
            entity.HasKey(e => e.OpremaId).HasName("PK__Oprema__5C2EDCF13AEF101C");

            entity.ToTable("Oprema");

            entity.HasIndex(e => e.AutomobilId, "IX_Oprema_AutomobilID");

            entity.Property(e => e.OpremaId).HasColumnName("OpremaID");
            entity.Property(e => e.AutomobilId).HasColumnName("AutomobilID");

            entity.HasOne(d => d.Automobil).WithMany(p => p.Opremas)
                .HasForeignKey(d => d.AutomobilId)
                .HasConstraintName("FK__Oprema__Automobi__4BAC3F29");
        });

        modelBuilder.Entity<Recenzije>(entity =>
        {
            entity.HasKey(e => e.RecenzijeId).HasName("PK__Recenzij__C077A356F761E834");

            entity.ToTable("Recenzije");

            entity.HasIndex(e => e.KorisnikId, "IX_Recenzije_KorisnikID");

            entity.Property(e => e.RecenzijeId).HasColumnName("RecenzijeID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Sadrzaj).HasMaxLength(255);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Recenzijes)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Recenzije__Koris__5441852A");
        });

        modelBuilder.Entity<Report>(entity =>
        {
            entity.HasKey(e => e.ReportId).HasName("PK__Report__D5BD48E5372F2D7B");

            entity.ToTable("Report");

            entity.HasIndex(e => e.AutomobilId, "IX_Report_AutomobilID");

            entity.Property(e => e.ReportId).HasColumnName("ReportID");
            entity.Property(e => e.AutomobilId).HasColumnName("AutomobilID");
            entity.Property(e => e.DatumProdaje).HasColumnType("datetime");
            entity.Property(e => e.Prihodi).HasColumnType("decimal(18, 2)");

            entity.HasOne(d => d.Automobil).WithMany(p => p.Reports)
                .HasForeignKey(d => d.AutomobilId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Report__Automobi__72C60C4A");
        });

        modelBuilder.Entity<Rezervacija>(entity =>
        {
            entity.HasKey(e => e.RezervacijaId).HasName("PK__Rezervac__CABA44FD9A468A08");

            entity.ToTable("Rezervacija");

            entity.HasIndex(e => e.AutomobilId, "IX_Rezervacija_AutomobilID");

            entity.HasIndex(e => e.KorisnikId, "IX_Rezervacija_KorisnikID");

            entity.Property(e => e.RezervacijaId).HasColumnName("RezervacijaID");
            entity.Property(e => e.AutomobilId).HasColumnName("AutomobilID");
            entity.Property(e => e.DatumVrijemeRezervacije).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Status)
                .HasMaxLength(50)
                .IsUnicode(false);

            entity.HasOne(d => d.Automobil).WithMany(p => p.Rezervacijas)
                .HasForeignKey(d => d.AutomobilId)
                .HasConstraintName("FK__Rezervaci__Autom__4E88ABD4");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Rezervacijas)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Rezervaci__Koris__4F7CD00D");
        });

        modelBuilder.Entity<StavkeNarudzbe>(entity =>
        {
            entity.HasKey(e => e.StavkeNarudzbeId).HasName("PK__StavkeNa__FA672E98AE68B56C");

            entity.ToTable("StavkeNarudzbe");

            entity.HasIndex(e => e.AutodioId, "IX_StavkeNarudzbe_AutodioID");

            entity.HasIndex(e => e.NaruzdbaId, "IX_StavkeNarudzbe_NaruzdbaID");

            entity.Property(e => e.StavkeNarudzbeId).HasColumnName("StavkeNarudzbeID");
            entity.Property(e => e.AutodioId).HasColumnName("AutodioID");
            entity.Property(e => e.NaruzdbaId).HasColumnName("NaruzdbaID");

            entity.HasOne(d => d.Autodio).WithMany(p => p.StavkeNarudzbes)
                .HasForeignKey(d => d.AutodioId)
                .HasConstraintName("FK__StavkeNar__Autod__5AEE82B9");

            entity.HasOne(d => d.Naruzdba).WithMany(p => p.StavkeNarudzbes)
                .HasForeignKey(d => d.NaruzdbaId)
                .HasConstraintName("FK__StavkeNar__Naruz__59FA5E80");
        });

        modelBuilder.Entity<Uloga>(entity =>
        {
            entity.HasKey(e => e.UlogaId).HasName("PK__Uloga__DCAB23EB5E60624C");

            entity.ToTable("Uloga");

            entity.Property(e => e.UlogaId).HasColumnName("UlogaID");
            entity.Property(e => e.Naziv)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.Opis)
                .HasMaxLength(255)
                .IsUnicode(false);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
