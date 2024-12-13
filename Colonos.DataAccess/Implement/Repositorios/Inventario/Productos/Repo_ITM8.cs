using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_ITM8
    {
        public void Add(ITM8 item)
        {
            using (var db = new cnnDatos())
            {
                db.ITM8.Add(item);
                db.SaveChanges();

            }
        }

        public ITM8 Get(int id)
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM8 where e.FrmtoVentaCode == id select e;
                return query.FirstOrDefault();

            }
        }

        public ITM8 Modify(ITM8 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM8.Find(item.FrmtoVentaCode);
                if (t != null)
                {
                    db.Entry(t).CurrentValues.SetValues(item);
                    db.SaveChanges();
                }
                return item;

            }
        }

        public void Delete(ITM8 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM8.Find(item.FrmtoVentaCode);
                if (t != null)
                {
                    db.ITM8.Remove(t);
                    db.SaveChanges();
                }

            }
        }

        public List<ITM8> List()
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM8 select e;
                return query.ToList();

            }
        }
    }
}
