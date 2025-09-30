import 'package:flutter/material.dart';

class RatingCard extends StatelessWidget {
  final double value;
  final double size;

  const RatingCard({
    super.key,
    required this.value,
    this.size = 80, // можно менять размер (по умолчанию 80)
  });

  Color _getColor(double rating) {
    if (rating < 4) {
      return Colors.red;
    } else if (rating < 6) {
      return Colors.yellow.shade700;
    } else if (rating < 9) {
      return Colors.green;
    } else if (rating == 10) {
      return Colors.green.shade900;
    } else {
      return Colors.lightGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getColor(value),
      shape: const CircleBorder(),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            value.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
