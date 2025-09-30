import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foo/src/themes/theme.dart';

class GlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), // размытие заднего плана
          child: Container(
            width: 330,
            height: 420,
            decoration: BoxDecoration(
              color: AppTheme.dark.primaryColor.withValues(alpha: 0.5), // полупрозрачный фон
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.dark.primaryColor.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 72,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
