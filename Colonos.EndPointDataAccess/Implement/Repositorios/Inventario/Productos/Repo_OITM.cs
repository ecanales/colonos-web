using Newtonsoft.Json;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_OITM
    {
        Logger logger;
        public Repo_OITM(Logger _logger)
        {
            logger = _logger;
        }
        public void Add(OITM item)
        {
            using (var db = new cnnDatos())
            {
                var t = from e in db.OITM where e.ProdCode == item.ProdCode select e;
                if (t.FirstOrDefault() == null)
                {
                    db.OITM.Add(item);
                    db.SaveChanges();
                }
            }
        }

        public string Get(string id)
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM1 where e.MedidaCode == id select e;
                var result = query.FirstOrDefault();

                string JSONresult = JsonConvert.SerializeObject(result);
                JSONresult = JSONresult.Substring(1, JSONresult.Length - 2);
                return JSONresult;
            }
        }

        public string Modify(OITM item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.OITM.Find(item.ProdCode);
                if (t != null)
                {
                    db.Entry(t).CurrentValues.SetValues(item);
                    db.SaveChanges();
                }
                var result = item;
                string JSONresult = JsonConvert.SerializeObject(result);
                JSONresult = JSONresult.Substring(1, JSONresult.Length - 2);
                return JSONresult;
            }
        }

        public void Delete(OITM item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.OITM.Find(item.ProdCode);
                if (t != null)
                {
                    db.OITM.Remove(t);
                    db.SaveChanges();
                }

            }
        }

        public string List()
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.OITM select e;

                var result = query.ToList();
                string JSONresult = JsonConvert.SerializeObject(result);
                return JSONresult;
            }
        }
    }
}
