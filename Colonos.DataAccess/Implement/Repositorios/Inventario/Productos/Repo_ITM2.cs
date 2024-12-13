using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_ITM2
    {
        public void Add(ITM2 item)
        {
            using (var db = new cnnDatos())
            {
                db.ITM2.Add(item);
                db.SaveChanges();

            }
        }

        public ITM2 Get(string id)
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM2 where e.CategoriaCode == id select e;
                return query.FirstOrDefault();

            }
        }

        public ITM2 Modify(ITM2 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM2.Find(item.CategoriaCode);
                if (t != null)
                {
                    db.Entry(t).CurrentValues.SetValues(item);
                    db.SaveChanges();
                }
                return item;

            }
        }

        public void Delete(ITM2 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM2.Find(item.CategoriaCode);
                if (t != null)
                {
                    db.ITM2.Remove(t);
                    db.SaveChanges();
                }

            }
        }

        public List<ITM2> List()
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM2 select e;
                return query.ToList();

            }
        }
    }
}
