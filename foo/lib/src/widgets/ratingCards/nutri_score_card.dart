import 'package:flutter/material.dart';

class NutriScoreCard extends StatelessWidget {
  final String grade; // A, B, C, D, E
  final double size;

  const NutriScoreCard({
    super.key,
    required this.grade,
    this.size = 80,
  });

  static const List<String> acceptableLetters = ["A", "B", "C", "D", "E"];

  


  Color _getColor(String g) {
    switch (g.toUpperCase()) {
      case 'A':
        return Colors.green.shade700;   // лучший
      case 'B':
        return Colors.greenAccent.shade400;
      case 'C':
        return Colors.yellow.shade700;
      case 'D':
        return Colors.orange;
      case 'E':
        return Colors.red;
      default:
        return Colors.grey; // если передали что-то другое
    }
  }

  @override
  Widget build(BuildContext context) {
    final normalised = grade.toUpperCase();
    final isValid = acceptableLetters.contains(normalised);

    return Card(
      color: _getColor(grade),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            isValid ? normalised : "?",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
