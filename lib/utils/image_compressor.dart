// lib/utils/image_compressor.dart

// Ini adalah file "pemandu". 
// File ini tidak berisi implementasi, hanya ekspor kondisional.

export 'image_compressor_stub.dart' // Ekspor default (fallback)
    if (dart.library.io) 'image_compressor_mobile.dart' // Jika platform punya 'dart:io' (Mobile)
    if (dart.library.html) 'image_compressor_web.dart'; // Jika platform punya 'dart:html' (Web)