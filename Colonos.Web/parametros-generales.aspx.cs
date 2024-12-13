using ClosedXML.Excel;
using Colonos.Entidades;
using Colonos.Manager;
using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Colonos.Web
{
    public partial class parametros_generales : System.Web.UI.Page
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                CargaBodegas();
                LoadParamtros();
            }
        }

        private void LoadParamtros()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerParametros mng = new ManagerParametros(urlbase, logger);
            ParametrosGenerales param = mng.Get("parametros");

            if(param!=null)
            {
                txtFactor.Text = param.FactorPrecio.ToString();
                txtVolumen.Text = param.Volumen.ToString();
                txtDescuentoVolumen.Text = param.DescVolumen.ToString();
                txtTolerancia.Text = param.Tolerancia.ToString();
                txtMargen.Text = param.Margen.ToString();
                cboBodega.SelectedValue = param.BodegaProduccion;
            }
        }
        private void CargaBodegas()
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            var bodegas = mng.ListBodegas("productos/bodegas");

            bodegas.Add(new OBOD { BodegaCode = "", BodegaNombre = "" });
            cboBodega.DataSource = bodegas;
            cboBodega.DataValueField = "BodegaCode";
            cboBodega.DataTextField = "BodegaNombre";
            cboBodega.DataBind();
        }

        protected void CargarArchivo_Event(object sender, EventArgs e)
        {
            popupCargaArchivo.Show();
        }

        protected void ClosepopupCarga(object sender, EventArgs e)
        {
            popupCargaArchivo.Hide();
        }

        protected void Guardar_Event(object sender, EventArgs e)
        {
            txtFactor.Text = txtFactor.Text.Replace(".", ",").Trim();
            txtVolumen.Text = txtVolumen.Text.Replace(".", ",").Trim();
            txtDescuentoVolumen.Text = txtDescuentoVolumen.Text.Replace(".", ",").Trim();
            txtTolerancia.Text = txtTolerancia.Text.Replace(".", ",").Trim();
            txtMargen.Text = txtMargen.Text.Replace(".", ",").Trim();

            if(cboBodega.SelectedValue=="")
            {
                cboBodega.Focus();
                return;
            }
            try
            {
                decimal d;
                d = Convert.ToDecimal(txtFactor.Text);
                d = Convert.ToDecimal(txtVolumen.Text);
                d = Convert.ToDecimal(txtDescuentoVolumen.Text);
                d = Convert.ToDecimal(txtTolerancia.Text);
                d = Convert.ToDecimal(txtMargen.Text);
            }
            catch
            {
                txtFactor.Focus();
                return;
            }
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerParametros mng = new ManagerParametros(urlbase, logger);
            ParametrosGenerales param = new ParametrosGenerales();
            param.ParamCode = 1;
            param.FactorPrecio = Convert.ToDecimal(txtFactor.Text);
            param.Volumen = Convert.ToDecimal(txtVolumen.Text);
            param.DescVolumen = Convert.ToDecimal(txtDescuentoVolumen.Text);
            param.Tolerancia = Convert.ToDecimal(txtTolerancia.Text);
            param.Margen = Convert.ToDecimal(txtMargen.Text);
            param.BodegaProduccion = cboBodega.SelectedValue;
            var json = JsonConvert.SerializeObject(param);
            param = mng.Modify("parametros",json);

            txtFactor.Text = param.FactorPrecio.ToString();
            txtVolumen.Text = param.Volumen.ToString();
            txtDescuentoVolumen.Text = param.DescVolumen.ToString();
            txtTolerancia.Text = param.Tolerancia.ToString();
            txtMargen.Text = param.Margen.ToString();
            cboBodega.SelectedValue = param.BodegaProduccion;
        }

        protected void ActualizarStock_Event(object sender, EventArgs e)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            var result = mng.ActualizaStock("productos/stock/all");
            lblLogStosk.Text = result;
        }

        protected void ActualizarCosto_Event(object sender, EventArgs e)
        {
            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
            ManagerInventario mng = new ManagerInventario(urlbase, logger);
            var result = mng.ActualizaCostos("productos/costos/all");
            lblLogCosto.Text = result;
        }
        
        protected void ProcesarArchivo(object sender, EventArgs e)
        {
            Byte[] buffer = null;
            string nombreArchivo = string.Empty;
            string extensionArchivo = string.Empty;

            if (upArchivo.HasFile == true)
            {
                using (BinaryReader reader = new BinaryReader(upArchivo.PostedFile.InputStream))
                {
                    string idCarga = DateTime.Now.ToString("ddMMyyyy-HHmmss");
                    //logger.Info("{0}: {1}", "----- INICIO CARGA DESDE ARCHIVO", idCarga);

                    buffer = reader.ReadBytes(upArchivo.PostedFile.ContentLength);
                    MemoryStream ms = new MemoryStream(buffer);

                    try
                    {
                        List<SCP11> listarchivos = new List<SCP11>();
                        

                        using (XLWorkbook workBook = new XLWorkbook(upArchivo.PostedFile.InputStream))
                        {
                            IXLWorksheet workSheet = workBook.Worksheet(1);



                            //Create a new DataTable.
                            DataTable dt = new DataTable();
                            bool firstRow = true;
                            int columna = 0;
                            foreach (IXLRow row in workSheet.Rows())
                            {
                                //Use the first row to add columns to DataTable.
                                if (firstRow)
                                {
                                    columna = 0;
                                    foreach (IXLCell cell in row.Cells())
                                    {
                                        columna += 1;
                                        if (columna <= 11)
                                        {
                                            dt.Columns.Add(cell.Value.ToString());
                                        }
                                        else
                                        {
                                            break;
                                        }

                                    }
                                    firstRow = false;
                                }
                                else
                                {
                                    //Add rows to DataTable.
                                    dt.Rows.Add();
                                    int i = 0;
                                    columna = 0;
                                    foreach (IXLCell cell in row.Cells())
                                    {
                                        columna += 1;
                                        if (columna <= 11)
                                        {
                                            dt.Rows[dt.Rows.Count - 1][i] = cell.Value.ToString();

                                            i++;

                                        }
                                        else
                                        {
                                            columna = 0;
                                            break;

                                        }

                                    }


                                }



                            }

                            if (true)
                            {
                                string sociocode = "";
                                string socionombre = "";
                                string documento = "";
                                string serie = "";
                                string vencimiento = "";
                                int numero = 0;
                                int v91 = 0;
                                int v90 = 0;
                                int v60 = 0;
                                int v30 = 0;
                                int saldo = 0;

                                int i = 1;
                                foreach (DataRow row in dt.Rows)
                                {
                                    sociocode = row[0].ToString();
                                    socionombre = row[1].ToString();
                                    documento = row[2].ToString();
                                    serie = row[3].ToString();
                                    
                                    vencimiento = row[5].ToString();

                                    if (sociocode != "" && socionombre != "")
                                    {
                                        try
                                        {
                                            numero = Convert.ToInt32(row[4].ToString().Replace(".", ","));
                                            v91 = Convert.ToInt32(row[6].ToString().Replace(".", ","));
                                            v90 = Convert.ToInt32(row[7].ToString().Replace(".", ","));
                                            v60 = Convert.ToInt32(row[8].ToString().Replace(".", ","));
                                            v30 = Convert.ToInt32(row[9].ToString().Replace(".", ","));
                                            saldo = Convert.ToInt32(row[10].ToString().Replace(".", ","));

                                        }
                                        catch
                                        {
                                            return;
                                        }

                                        SCP11 dim = new SCP11
                                        {
                                            SocioCode=sociocode,
                                            SocioNombre=socionombre,
                                            Documento=documento,
                                            Serie=serie,
                                            Numero=numero,
                                            Vencimiento=vencimiento,
                                            V91=v91,
                                            V90 = v90,
                                            V60 = v60,
                                            V30 = v30,
                                        };

                                        listarchivos.Add(dim);

                                    }
                                }
                            }
                        }

                        if (listarchivos.Count > 0)
                        {

                            string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                            ManagerSocios mng = new ManagerSocios(urlbase, logger);
                            var url = String.Format("socios/archivos/carga");
                            var item = mng.GuardarArchivoCXC(url, listarchivos);
                            
                        }
                        lbLogCxc.Text = "Procesado";
                    }
                    catch (Exception ex)
                    {
                        //logger.Error("{0}: {1}", "----- ERROR EN CARGA DESDE ARCHIVO", ex.Message);
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("alert('");
                        sb.Append(ex.Message);
                        sb.Append("');");
                        ScriptManager.RegisterStartupScript(this, GetType(), "showalert", sb.ToString(), true);
                    }


                    //logger.Info("{0}: {1}", "----- FIN CARGA DESDE ARCHIVO", idCarga);


                }
            }
        }
    }
}