﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using ParticleEditor.Data.ParticleSystem;

namespace ParticleEditor.ViewModels.ParameterTabs
{
    public class GeneralTabViewModel
    {
        public MainViewModel MainViewModel
        {
            get
            {
                return Application.Current.MainWindow.DataContext as MainViewModel;
            }
        }
    }
}
