using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_ITM6
    {
        public void Add(ITM6 item)
        {
            using (var db = new cnnDatos())
            {
                db.ITM6.Add(item);
                db.SaveChanges();

            }
        }

        public ITM6 Get(int id)
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM6 where e.FormatoCode == id select e;
                return query.FirstOrDefault();

            }
        }

        public ITM6 Modify(ITM6 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM6.Find(item.FormatoCode);
                if (t != null)
                {
                    db.Entry(t).CurrentValues.SetValues(item);
                    db.SaveChanges();
                }
                return item;

            }
        }

        public void Delete(ITM6 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM6.Find(item.FormatoCode);
                if (t != null)
                {
                    db.ITM6.Remove(t);
                    db.SaveChanges();
                }

            }
        }

        public List<ITM6> List()
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM6 select e;
                return query.ToList();

            }
        }
    }
}
