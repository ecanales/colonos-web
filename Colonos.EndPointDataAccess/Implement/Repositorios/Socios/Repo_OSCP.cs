using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_OSCP
    {
        public void Add(OSCP item)
        {
            using (var db = new cnnDatos())
            {
                var t = from e in db.OSCP where e.SocioCode == item.SocioCode select e;
                if (t.FirstOrDefault() == null)
                {
                    db.OSCP.Add(item);
                    db.SaveChanges();
                }
            }
        }
    }
}
