import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/anime_details_provider.dart';
import '../widgets/anime_banner.dart';
import '../widgets/anime_poster.dart';

class AnimeDetailsScreen extends ConsumerWidget {
  final int animeId;

  const AnimeDetailsScreen({
    super.key,
    required this.animeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anime = ref.watch(animeDetailsProvider(animeId));

    return Scaffold(
      body: anime.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
        data: (animeData) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    animeData.romajiTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: AnimeBanner(
                    imageUrl: animeData.bannerImage,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    Center(
                      child: AnimePoster(
                        imageUrl: animeData.coverImage,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        animeData.romajiTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    if (animeData.englishTitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          animeData.englishTitle!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}