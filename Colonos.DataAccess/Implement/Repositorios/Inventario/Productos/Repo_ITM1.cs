using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_ITM1
    {
        public void Add(ITM1 item)
        {
            using (var db = new cnnDatos())
            {
                db.ITM1.Add(item);
                db.SaveChanges();

            }
        }

        public ITM1 Get(string id)
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM1 where e.MedidaCode == id select e;
                return query.FirstOrDefault();

            }
        }

        public ITM1 Modify(ITM1 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM1.Find(item.MedidaCode);
                if (t != null)
                {
                    db.Entry(t).CurrentValues.SetValues(item);
                    db.SaveChanges();
                }
                return item;

            }
        }

        public void Delete(ITM1 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM4.Find(item.MedidaCode);
                if (t != null)
                {
                    db.ITM1.Remove(t);
                    db.SaveChanges();
                }

            }
        }

        public List<ITM1> List()
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM1 select e;
                return query.ToList();

            }
        }
    }
}
