class Analytics {
  final int totalScans;
  final double averageScore;
  final Map<String, int> nutriscoreDistribution;
  final int avgCalories;
  final int avgProtein;
  final int avgFat;
  final int avgSugar;
  final String verdict;

  Analytics({
    required this.totalScans,
    required this.averageScore,
    required this.nutriscoreDistribution,
    required this.avgCalories,
    required this.avgProtein,
    required this.avgFat,
    required this.avgSugar,
    required this.verdict,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      totalScans: json['total_scans'] ?? 0,
      averageScore: (json['average_score'] ?? 0).toDouble(),
      nutriscoreDistribution: Map<String, int>.from(json['nutriscore_distribution'] ?? {}),
      avgCalories: json['avg_calories'] ?? 0,
      avgProtein: json['avg_protein'] ?? 0,
      avgFat: json['avg_fat'] ?? 0,
      avgSugar: json['avg_sugar'] ?? 0,
      verdict: json['verdict'] ?? 'Нет данных',
    );
  }
}