import 'package:flutter/material.dart';

class ScoreBadge extends StatelessWidget {
  final int? score;

  const ScoreBadge({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(
        Icons.star,
        color: Colors.amber,
        size: 18,
      ),
      label: Text(
        score?.toString() ?? "N/A",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.amber.withValues(alpha: 0.15),
    );
  }
}