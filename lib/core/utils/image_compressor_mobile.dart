// lib/utils/image_compressor_mobile.dart
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List> compressImage(Uint8List data) async {
  return await FlutterImageCompress.compressWithList(
    data,
    minHeight: 512,
    minWidth: 512,
    quality: 70,
  );
}