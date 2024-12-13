using Colonos.Manager;
using NLog;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using System.Timers;

namespace Colonos.ActualizaStock
{
    public partial class ServicioActualizaStock : ServiceBase
    {
        Logger logger = NLog.LogManager.GetLogger("loggerfile");
        System.Timers.Timer timerVtex = new System.Timers.Timer();
        public ServicioActualizaStock()
        {
            InitializeComponent();
            int interval = Convert.ToInt32(ConfigurationManager.AppSettings.Get("Interval"));
            timerVtex.Interval = 60000 * interval;
            timerVtex.Elapsed += new ElapsedEventHandler(OnTimedEvent);
            timerVtex.Enabled = true;
            timerVtex.Start();
        }

        private void OnTimedEvent(Object source, System.Timers.ElapsedEventArgs e)
        {
            timerVtex.Enabled = false; timerVtex.Stop();
            logger.Info("Iniciado proceso actualiza stock");
            try
            {
                string urlbase = ConfigurationManager.AppSettings.Get("urlbase");
                ManagerInventario mng = new ManagerInventario(urlbase, logger);
                var result = mng.ActualizaStock("productos/stock/all");
            }
            catch(Exception ex)
            {
                logger.Error("Proceso Actualiza Stock{0}", ex.Message);
                logger.Error("Proceso Actualiza Stock", ex.StackTrace);
            }
            finally
            {
                timerVtex.Enabled = true; timerVtex.Start();
                logger.Info("Finalizado proceso actualiza stock");
            }

        }

        protected override void OnStart(string[] args)
        {
        }

        protected override void OnStop()
        {
        }
    }
}
