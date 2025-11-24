class JsonParser {
  // Helpers to handle variable shapes (Pindahan dari ApiService lama)
  static List extractList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is Map) {
      if (data['data'] is List) return data['data'];
      if (data['results'] is List) return data['results'];
      if (data['comics'] is List) return data['comics'];
      if (data['chapters'] is List) return data['chapters'];
      if (data['items'] is List) return data['items'];
      return [data];
    }
    return [];
  }

  static Map<String, dynamic> extractMap(dynamic data) {
    if (data == null) return {};
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(data['data']);
      }
      if (data['result'] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(data['result']);
      }
      return Map<String, dynamic>.from(data);
    }
    return {};
  }
}