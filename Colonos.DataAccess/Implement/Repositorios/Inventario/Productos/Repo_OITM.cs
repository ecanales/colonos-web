using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.EndPointDataAccess.Repositorios
{
    public class Repo_OITM
    {
        public void Add(OITM item)
        {
            using (var db = new cnnDatos())
            {
                var t = from e in db.OITM where e.ProdCode == item.ProdCode select e;
                if (t.FirstOrDefault() == null)
                {
                    db.OITM.Add(item);
                    db.SaveChanges();
                }
            }
        }
    }
}
