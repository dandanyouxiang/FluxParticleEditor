﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace ParticleEditor.Data
{
    public static class DataProvider
    {
        public static bool IsDesignMode
            => (bool)(DesignerProperties.IsInDesignModeProperty.GetMetadata(typeof(DependencyObject)).DefaultValue);

        public static string DataPath { get; } = "D:/2016-2017/S5 - Tool Development/Exam/ParticleEditor/bin/Debug";

        private static readonly string FallbackImage = "../../Resources/ErrorTexture.jpg";
        public static ImageSource ToImageSource(string filePath)
        {
            string rootPath = IsDesignMode ? DataPath : "";
            string fileName = Path.Combine(rootPath, filePath);
            fileName = Path.GetFullPath(fileName);

            byte[] data;
            if (File.Exists(fileName))
                data = File.ReadAllBytes(fileName);
            else
            {
                MessageBox.Show($"Image at location '{fileName}' could not be found. Using fallback image",
                    "Error loading image", MessageBoxButton.OK, MessageBoxImage.Warning);
                data = File.ReadAllBytes($"{rootPath}{FallbackImage}");
            }
            var imageData = new BitmapImage();
            imageData.BeginInit();
            imageData.StreamSource = new MemoryStream(data);
            imageData.EndInit();
            imageData.Freeze();
            return imageData;
        }
    }
}