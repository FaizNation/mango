class ImageProxy {
  static const String _proxyBaseUrl = 'https://images.weserv.nl/?url=';

  /// Wraps image URL with weserv.nl proxy to avoid CORS issues
  /// Example: https://example.com/image.jpg -> https://images.weserv.nl/?url=https://example.com/image.jpg
  static String proxy(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return '';

    // If URL is already using weserv.nl, return as is
    if (imageUrl.startsWith(_proxyBaseUrl)) return imageUrl;

    // Ensure URL is properly encoded
    final encodedUrl = Uri.encodeFull(imageUrl);
    return '$_proxyBaseUrl$encodedUrl';
  }

  /// Wraps multiple image URLs with weserv.nl proxy
  static List<String> proxyList(List<String> imageUrls) {
    return imageUrls.map((url) => proxy(url)).toList();
  }

  /// Additional options can be added to the weserv.nl URL
  /// Example: &w=800&h=600 for resizing
  static String proxyWithOptions(
    String? imageUrl, {
    int? width,
    int? height,
    int? quality,
    String? fit, // 'inside', 'outside', 'cover', 'contain', 'fill'
    String? output, // 'jpg', 'png', 'gif', 'webp'
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
