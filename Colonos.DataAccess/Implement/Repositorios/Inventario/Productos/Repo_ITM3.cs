using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_ITM3
    {
        public void Add(ITM3 item)
        {
            using (var db = new cnnDatos())
            {
                db.ITM3.Add(item);
                db.SaveChanges();

            }
        }

        public ITM3 Get(string id)
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM3 where e.TipoCode == id select e;
                return query.FirstOrDefault();

            }
        }

        public ITM3 Modify(ITM3 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM3.Find(item.TipoCode);
                if (t != null)
                {
                    db.Entry(t).CurrentValues.SetValues(item);
                    db.SaveChanges();
                }
                return item;

            }
        }

        public void Delete(ITM3 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM3.Find(item.TipoCode);
                if (t != null)
                {
                    db.ITM3.Remove(t);
                    db.SaveChanges();
                }

            }
        }

        public List<ITM3> List()
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM3 select e;
                return query.ToList();

            }
        }
    }
}
