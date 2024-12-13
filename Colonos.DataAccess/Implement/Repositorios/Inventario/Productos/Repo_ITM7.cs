using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_ITM7
    {
        public void Add(ITM7 item)
        {
            using (var db = new cnnDatos())
            {
                db.ITM7.Add(item);
                db.SaveChanges();

            }
        }

        public ITM7 Get(int id)
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM7 where e.RefrigeraCode == id select e;
                return query.FirstOrDefault();

            }
        }

        public ITM7 Modify(ITM7 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM7.Find(item.RefrigeraCode);
                if (t != null)
                {
                    db.Entry(t).CurrentValues.SetValues(item);
                    db.SaveChanges();
                }
                return item;

            }
        }

        public void Delete(ITM7 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM7.Find(item.RefrigeraCode);
                if (t != null)
                {
                    db.ITM7.Remove(t);
                    db.SaveChanges();
                }

            }
        }

        public List<ITM7> List()
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM7 select e;
                return query.ToList();

            }
        }
    }
}
