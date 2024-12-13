using Newtonsoft.Json;
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

        public string Get(int id)
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM5 where e.AnimalCode == id select e;
                var result = query.FirstOrDefault();
                string JSONresult = JsonConvert.SerializeObject(result);
                JSONresult = JSONresult.Substring(1, JSONresult.Length - 2);
                return JSONresult;
            }
        }

        public string Modify(ITM5 item)
        {
            using (var db = new cnnDatos())
            {
                var t = db.ITM5.Find(item.AnimalCode);
                if (t != null)
                {
                    db.Entry(t).CurrentValues.SetValues(item);
                    db.SaveChanges();
                }
                string JSONresult = JsonConvert.SerializeObject(item);
                JSONresult = JSONresult.Substring(1, JSONresult.Length - 2);
                return JSONresult;

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

        public string List()
        {
            using (var db = new cnnDatos())
            {
                var query = from e in db.ITM5 select e;
                var result = query.ToList();
                string JSONresult = JsonConvert.SerializeObject(result);
                return JSONresult;
            }
        }
    }
}
