class ImageProxy {
  static const String _proxyBaseUrl = 'https://images.weserv.nl/?url=';

  static String proxy(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';

    if (imageUrl.startsWith(_proxyBaseUrl)) return imageUrl;

    final encodedUrl = Uri.encodeFull(imageUrl);
    return '$_proxyBaseUrl$encodedUrl';
  }
  static List<String> proxyList(List<String> imageUrls) {
    return imageUrls.map((url) => proxy(url)).toList();
  }

  static String proxyWithOptions(
    String? imageUrl, {
    int? width,
    int? height,
    int? quality,
    String? fit,
    String? output,
  }) {
    final baseUrl = proxy(imageUrl);
    if (baseUrl.isEmpty) return '';

    final List<String> options = [];

    if (width != null) options.add('&w=$width');
    if (height != null) options.add('&h=$height');
    if (quality != null) options.add('&q=$quality');
    if (fit != null) options.add('&fit=$fit');
    if (output != null) options.add('&output=$output');

    return baseUrl + options.join();
  }
}
