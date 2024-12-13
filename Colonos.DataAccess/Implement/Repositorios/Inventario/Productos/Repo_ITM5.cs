using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_ITM5
    {
        public void Add(ITM5 item)
        {
            using (var db = new cnnDatos())
            {
                db.ITM5.Add(item);
                db.SaveChanges();

            }
        }

        public ITM5 Get(int id)
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM5 where e.AnimalCode == id select e;
                return query.FirstOrDefault();

            }
        }

        public ITM5 Modify(ITM5 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM5.Find(item.AnimalCode);
                if (t != null)
                {
                    db.Entry(t).CurrentValues.SetValues(item);
                    db.SaveChanges();
                }
                return item;

            }
        }

        public void Delete(ITM5 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM5.Find(item.AnimalCode);
                if (t != null)
                {
                    db.ITM5.Remove(t);
                    db.SaveChanges();
                }

            }
        }

        public List<ITM5> List()
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM5 select e;
                return query.ToList();

            }
        }
    }
}
