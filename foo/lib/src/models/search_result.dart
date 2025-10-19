class SearchResult {
  final int id;
  final String name;

  SearchResult({required this.id, required this.name});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'],
      name: json['name'],
    );
  }
}
