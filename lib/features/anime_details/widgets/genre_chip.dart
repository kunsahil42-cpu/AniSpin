import 'dart:ui';

import 'package:flutter/material.dart';

class GenreChip extends StatelessWidget {
  final String genre;

  const GenreChip({
    super.key,
    required this.genre,
  });

  IconData _iconForGenre(String genre) {
    switch (genre.toLowerCase()) {
      case "action":
        return Icons.flash_on_rounded;
      case "adventure":
        return Icons.explore_rounded;
      case "comedy":
        return Icons.sentiment_very_satisfied_rounded;
      case "drama":
        return Icons.theater_comedy_rounded;
      case "fantasy":
        return Icons.auto_awesome_rounded;
      case "romance":
        return Icons.favorite_rounded;
      case "horror":
        return Icons.nightlight_round;
      case "mystery":
        return Icons.search_rounded;
      case "psychological":
        return Icons.psychology_rounded;
      case "sci-fi":
        return Icons.rocket_launch_rounded;
      case "sports":
        return Icons.sports_esports_rounded;
      case "music":
        return Icons.music_note_rounded;
      case "slice of life":
        return Icons.coffee_rounded;
      case "supernatural":
        return Icons.bolt_rounded;
      default:
        return Icons.local_offer_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconForGenre(genre),
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                genre,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}