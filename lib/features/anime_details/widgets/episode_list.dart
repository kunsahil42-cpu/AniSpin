import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../models/episode_model.dart';

class EpisodeList extends ConsumerWidget {
  final int animeId;
  final int totalEpisodes;
  final String romajiTitle;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;

  const EpisodeList({
    super.key,
    required this.animeId,
    required this.totalEpisodes,
    required this.romajiTitle,
    this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progressAsync = ref.watch(animeProgressProvider(animeId));

    return progressAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (progress) {
        final currentEp = progress?.lastWatchedEpisode ?? 1;
        final completed = progress?.completedEpisodes ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🎬 Episodes',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$totalEpisodes Episodes',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: totalEpisodes,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final episodeNum = index + 1;
                final episode = EpisodeModel.mock(animeId, episodeNum);
                final isCurrent = episodeNum == currentEp;
                final isCompleted = completed.contains(episodeNum);
                
                // Get progress for this episode if it's the current one
                double watchPercent = 0.0;
                if (isCurrent && progress != null) {
                  watchPercent = progress.watchPercentage;
                } else if (isCompleted) {
                  watchPercent = 1.0;
                }

                return _EpisodeCard(
                  episode: episode,
                  isCurrent: isCurrent,
                  isCompleted: isCompleted,
                  progress: watchPercent,
                  onTap: () {
                    context.push(
                      '/anime/$animeId/play/$episodeNum',
                      extra: {
                        'romajiTitle': romajiTitle,
                        'englishTitle': englishTitle,
                        'coverImage': coverImage,
                        'bannerImage': bannerImage,
                        'totalEpisodes': totalEpisodes,
                      },
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  final EpisodeModel episode;
  final bool isCurrent;
  final bool isCompleted;
  final double progress;
  final VoidCallback onTap;

  const _EpisodeCard({
    required this.episode,
    required this.isCurrent,
    required this.isCompleted,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      elevation: isCurrent ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrent
            ? BorderSide(color: primaryColor, width: 2)
            : BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: episode.thumbnail,
                        width: 140,
                        height: 90,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          width: 140,
                          height: 90,
                          color: Colors.grey.shade900,
                          child: const Icon(Icons.movie, color: Colors.white24),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black54, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xCC000000),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'EP ${episode.number}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (isCompleted)
                        const Positioned(
                          top: 6,
                          right: 6,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.green,
                            child: Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            episode.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCurrent ? primaryColor : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            episode.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.schedule_rounded, size: 12, color: theme.colorScheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                episode.runtime ?? '24 min',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              if (episode.airDate != null) ...[
                                const SizedBox(width: 12),
                                Icon(Icons.calendar_today_rounded, size: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                                const SizedBox(width: 4),
                                Text(
                                  episode.airDate!,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (progress > 0.0)
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted ? Colors.green : primaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
