﻿//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Colonos.EndPointDataAccess
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class cnnDatos : DbContext
    {
        public cnnDatos()
            : base("name=cnnDatos")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<JsonProductos> JsonProductos { get; set; }
        public virtual DbSet<JsonClientes> JsonClientes { get; set; }
        public virtual DbSet<JsonProveedores> JsonProveedores { get; set; }
        public virtual DbSet<JsonBodegas> JsonBodegas { get; set; }
        public virtual DbSet<OITM> OITM { get; set; }
        public virtual DbSet<OSCP> OSCP { get; set; }
        public virtual DbSet<SCP1> SCP1 { get; set; }
        public virtual DbSet<ITM1> ITM1 { get; set; }
        public virtual DbSet<ITM2> ITM2 { get; set; }
        public virtual DbSet<ITM3> ITM3 { get; set; }
        public virtual DbSet<ITM4> ITM4 { get; set; }
        public virtual DbSet<ITM5> ITM5 { get; set; }
        public virtual DbSet<ITM6> ITM6 { get; set; }
        public virtual DbSet<ITM7> ITM7 { get; set; }
        public virtual DbSet<ITM8> ITM8 { get; set; }
        public virtual DbSet<OBOD> OBOD { get; set; }
        public virtual DbSet<OITB> OITB { get; set; }
        public virtual DbSet<OPED> OPED { get; set; }
        public virtual DbSet<OVEN> OVEN { get; set; }
        public virtual DbSet<PED1> PED1 { get; set; }
        public virtual DbSet<SCP2> SCP2 { get; set; }
        public virtual DbSet<SCP3> SCP3 { get; set; }
        public virtual DbSet<SCP4> SCP4 { get; set; }
        public virtual DbSet<SCP5> SCP5 { get; set; }
        public virtual DbSet<SCP6> SCP6 { get; set; }
        public virtual DbSet<SCP7> SCP7 { get; set; }
    }
}