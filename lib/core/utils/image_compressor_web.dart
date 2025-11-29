// lib/utils/image_compressor_web.dart
import 'dart:typed_data';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:async';
import 'dart:convert';

Future<Uint8List> compressImage(Uint8List data) async {
  final completer = Completer<Uint8List>();
  final blob = html.Blob([data]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final image = html.ImageElement();

  image.onLoad.listen((_) {
    final canvas = html.CanvasElement(width: 512, height: 512);
    final ctx = canvas.getContext('2d') as html.CanvasRenderingContext2D;

    // Draw the image to the canvas, resizing it
    ctx.drawImageScaled(image, 0, 0, 512, 512);

    // Get the data URI with specified quality
    final dataUrl = canvas.toDataUrl('image/jpeg', 0.7); // 0.7 quality
    
    // Revoke the object URL to free up memory
    html.Url.revokeObjectUrl(url);

    // Convert data URI back to Uint8List
    final base64String = dataUrl.split(',').last;
    completer.complete(Uint8List.fromList(base64.decode(base64String)));
  });

  image.onError.listen((event) {
    html.Url.revokeObjectUrl(url);
    completer.completeError(Exception('Failed to load image for compression.'));
  });

  image.src = url;
  return completer.future;
}