using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_SCP1
    {
        public void Add(SCP1 item)
        {
            using (var db = new cnnDatos())
            {
                var t = from e in db.SCP1 where e.SocioCode == item.SocioCode && e.DireccionTipo==item.DireccionTipo && e.DireccionCode==e.DireccionCode select e;
                if (t.FirstOrDefault() == null)
                {
                    db.SCP1.Add(item);
                    db.SaveChanges();
                }
            }
        }
    }
}
