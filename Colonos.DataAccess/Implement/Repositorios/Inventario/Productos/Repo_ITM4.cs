using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_ITM4
    {

        public void Add(ITM4 item)
        {
            using (var db = new cnnDatos())
            {
                db.ITM4.Add(item);
                db.SaveChanges();

            }
        }

        public ITM4 Get(int id)
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM4 where e.FamiliaCode==id select e;
                return query.FirstOrDefault();

            }
        }

        public ITM4 Modify(ITM4 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM4.Find(item.FamiliaCode);
                if (t!=null)
                {
                    db.Entry(t).CurrentValues.SetValues(item);
                    db.SaveChanges();
                }
                return item;

            }
        }

        public void Delete(ITM4 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM4.Find(item.FamiliaCode);
                if (t != null)
                {
                    db.ITM4.Remove(t);
                    db.SaveChanges();
                }

            }
        }

        public List<ITM4> List()
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM4 select e;
                return query.ToList();

            }
        }
    }
}
