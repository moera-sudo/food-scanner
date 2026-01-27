import 'package:flutter/material.dart';
import 'package:foo/src/models/analytics.dart';
import 'package:foo/src/services/analytics_service.dart';
import 'package:foo/src/services/auth_service.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  Future<Analytics?>? _analyticsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (await AuthService.isAuthenticated()) {
      setState(() {
        _analyticsFuture = AnalyticsService().getAnalytics();
      });
    } else {
      setState(() {
        _analyticsFuture = Future.value(null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Моя статистика"), centerTitle: true),
      body: FutureBuilder<Analytics?>(
        future: _analyticsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final data = snapshot.data;
          if (data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 60, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text("Войдите или сканируйте продукты,\nчтобы видеть статистику", textAlign: TextAlign.center),
                  TextButton(onPressed: _loadData, child: const Text("Обновить"))
                ],
              ),
            );
          }

          if (data.totalScans == 0) {
             return const Center(child: Text("Пока нет данных. Сканируйте больше!"));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _StatCard(
                title: "Вердикт",
                value: data.verdict,
                color: Colors.green,
                icon: Icons.health_and_safety,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _StatCard(title: "Сканирований", value: "${data.totalScans}", color: Colors.blue)),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(title: "Сред. рейтинг", value: "${data.averageScore}", color: Colors.orange)),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Средние показатели (на 100г)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _NutrientBar("Белки", data.avgProtein, 20, Colors.blue),
              _NutrientBar("Жиры", data.avgFat, 20, Colors.yellow),
              _NutrientBar("Сахар", data.avgSugar, 15, Colors.red),
              const SizedBox(height: 20),
              const Text("Распределение Nutri-Score", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ["A", "B", "C", "D", "E"].map((grade) {
                    final count = data.nutriscoreDistribution[grade] ?? 0;
                    final max = data.totalScans > 0 ? data.totalScans : 1;
                    final heightFactor = count / max;
                    
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("$count"),
                        const SizedBox(height: 5),
                        
                        // --- ИСПРАВЛЕНИЕ ЗДЕСЬ ---
                        Container(
                          width: 30,
                          height: 150 * heightFactor + 10, // Мин высота 10
                          // color: ... УБРАЛИ ОТСЮДА
                          decoration: BoxDecoration(
                            color: _getScoreColor(grade), // ПЕРЕНЕСЛИ СЮДА
                            borderRadius: BorderRadius.circular(4)
                          ),
                        ),
                        // -------------------------
                        
                        const SizedBox(height: 5),
                        Text(grade, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    );
                  }).toList(),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Color _getScoreColor(String g) {
    switch (g) {
      case 'A': return Colors.green[800]!;
      case 'B': return Colors.green;
      case 'C': return Colors.yellow;
      case 'D': return Colors.orange;
      case 'E': return Colors.red;
      default: return Colors.grey;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData? icon;

  const _StatCard({required this.title, required this.value, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          if (icon != null) Icon(icon, color: color, size: 30),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _NutrientBar extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final Color color;

  const _NutrientBar(this.label, this.value, this.max, this.color);

  @override
  Widget build(BuildContext context) {
    double percent = (value / max).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label)),
          Expanded(
            child: LinearProgressIndicator(value: percent, color: color, backgroundColor: Colors.grey[800], minHeight: 8),
          ),
          const SizedBox(width: 10),
          Text("$value г"),
        ],
      ),
    );
  }
}