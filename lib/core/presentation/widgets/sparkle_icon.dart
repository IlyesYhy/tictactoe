import 'package:flutter/material.dart';

/// Small decorative sparkle used behind mascots and hero illustrations.
///
/// Shared here so multiple features can reuse it without depending on one
/// another.
class SparkleIcon extends StatelessWidget {
  const SparkleIcon({super.key, required this.color, this.size = 16});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.auto_awesome_rounded, color: color, size: size);
  }
}
