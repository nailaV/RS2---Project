﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eAutokuca.Models
{
    public class UserExceptions:Exception
    {
        public UserExceptions(string message):base(message) 
        { 

        }
    }
}
