import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/manga_model.dart';

class MangaTile extends StatelessWidget {
  final MangaModel manga;

  const MangaTile({
    super.key,
    required this.manga,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () {
          context.push('/manga/${manga.id}');
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            manga.imageUrl,
            width: 55,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(manga.title),
        subtitle: Text(
          "⭐ ${manga.score ?? '-'} | 📖 ${manga.chapters ?? '-'}",
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
