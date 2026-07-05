import 'package:flutter/material.dart';
import '../../anime_details/widgets/genre_chip.dart' as details;

class GenreChip extends StatelessWidget {
  final String genre;

  const GenreChip({
    super.key,
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
    return details.GenreChip(genre: genre);
  }
}
