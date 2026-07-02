import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/discover_mode.dart';
import '../providers/discover_provider.dart';
import '../widgets/anime_grid_tile.dart';

class DiscoverResultsScreen extends ConsumerWidget {
  final DiscoverMode mode;

  const DiscoverResultsScreen({
    super.key,
    required this.mode,
  });

  String get pageTitle {
    switch (mode) {
      case DiscoverMode.randomAnime:
        return "🎲 Roll Anime";

      case DiscoverMode.trending:
        return "🔥 Trending";

      case DiscoverMode.hiddenGems:
        return "💎 Hidden Gems";

      case DiscoverMode.airing:
        return "📅 Airing This Season";

      case DiscoverMode.topRated:
        return "⭐ Top Rated";

      case DiscoverMode.surpriseMe:
        return "🎁 Surprise Me";

      case DiscoverMode.mood:
        return "🎭 Mood Roll";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeList = ref.watch(
      discoverListProvider(mode),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        centerTitle: true,
      ),
      body: animeList.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
        data: (anime) {
          if (anime.isEmpty) {
            return const Center(
              child: Text(
                "No anime found.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                discoverListProvider(mode),
              );
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.70,
              ),
              itemCount: anime.length,
              itemBuilder: (context, index) {
                final item = anime[index];

                return AnimeGridTile(
                  anime: item,
                  onTap: () {
                    // TODO: Navigate to Anime Details
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}