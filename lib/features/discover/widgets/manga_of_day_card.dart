import 'package:flutter/material.dart';

import '../models/discover_manga_model.dart';
import 'discover_card.dart';

class MangaOfDayCard extends StatelessWidget {
  final DiscoverMangaModel manga;
  final VoidCallback? onTap;

  const MangaOfDayCard({
    super.key,
    required this.manga,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DiscoverCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              manga.coverImage,
              width: 90,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  manga.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text("${manga.averageScore ?? "-"}"),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  manga.genres.take(2).join(" • "),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Text(
                      "View Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}