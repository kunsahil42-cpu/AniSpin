import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../models/chapter_model.dart';

class ChapterList extends ConsumerStatefulWidget {
  final int mangaId;
  final int totalChapters;
  final String romajiTitle;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;

  const ChapterList({
    super.key,
    required this.mangaId,
    required this.totalChapters,
    required this.romajiTitle,
    this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
  });

  @override
  ConsumerState<ChapterList> createState() => _ChapterListState();
}

class _ChapterListState extends ConsumerState<ChapterList> {
  bool _ascending = false; // Default: show newest first

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressAsync = ref.watch(mangaProgressProvider(widget.mangaId));

    return progressAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (progress) {
        final currentChapter = progress?.lastReadChapter ?? 1;
        final completed = progress?.completedChapters ?? [];

        // Build list of chapter indices depending on sort order
        final indices = List.generate(widget.totalChapters, (index) => index + 1);
        if (!_ascending) {
          indices.sort((a, b) => b.compareTo(a));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '📚 Chapters',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${widget.totalChapters} Chapters',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          _ascending ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _ascending = !_ascending;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: indices.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final chapterNum = indices[index];
                final chapter = ChapterModel.mock(widget.mangaId, chapterNum);
                final isCurrent = chapterNum == currentChapter;
                final isRead = completed.contains(chapterNum);

                return _ChapterRow(
                  chapter: chapter,
                  isCurrent: isCurrent,
                  isRead: isRead,
                  onTap: () {
                    context.push(
                      '/manga/${widget.mangaId}/read/$chapterNum',
                      extra: {
                        'romajiTitle': widget.romajiTitle,
                        'englishTitle': widget.englishTitle,
                        'coverImage': widget.coverImage,
                        'bannerImage': widget.bannerImage,
                        'totalChapters': widget.totalChapters,
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

class _ChapterRow extends StatelessWidget {
  final ChapterModel chapter;
  final bool isCurrent;
  final bool isRead;
  final VoidCallback onTap;

  const _ChapterRow({
    required this.chapter,
    required this.isCurrent,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      elevation: isCurrent ? 4 : 0,
      color: isCurrent
          ? theme.colorScheme.primary.withValues(alpha: 0.08)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCurrent ? primaryColor : theme.colorScheme.outline.withValues(alpha: 0.08),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Read status circle
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent
                      ? primaryColor
                      : isRead
                          ? Colors.grey.withValues(alpha: 0.4)
                          : Colors.green, // Unread is bright green
                ),
              ),
              const SizedBox(width: 14),
              // Chapter Title & Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? primaryColor : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          chapter.scanGroup,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          chapter.date,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Language Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  chapter.language,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
