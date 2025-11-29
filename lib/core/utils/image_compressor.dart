export 'image_compressor_stub.dart' 
    if (dart.library.io) 'image_compressor_mobile.dart' 
    if (dart.library.html) 'image_compressor_web.dart'; 