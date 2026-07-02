import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/anime_model.dart';

class AnimeTile extends StatelessWidget {
  final AnimeModel anime;

  const AnimeTile({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () {
          context.push('/anime/${anime.id}');
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            anime.imageUrl,
            width: 55,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(anime.title),
        subtitle: Text(
          "⭐ ${anime.score ?? '-'} | 📺 ${anime.episodes ?? '-'}",
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}