﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Colonos.Entidades
{
    public class CondiciondePago
    {
        public int CondicionCode { get; set; }
        public string CondicionNombre { get; set; }
        public Nullable<int> Dias { get; set; }
        public Nullable<int> Orden { get; set; }
    }
}
