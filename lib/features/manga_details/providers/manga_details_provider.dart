import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/network/mangadex/mangadex_api.dart';
import '../models/chapter_model.dart';
import '../models/manga_details_model.dart';
import '../repository/manga_details_repository.dart';

final mangaDetailsRepositoryProvider =
    Provider<MangaDetailsRepository>((ref) {
  return MangaDetailsRepository(
    dexApi: ref.watch(mangaDexApiProvider),
  );
});

final mangaDetailsProvider =
    FutureProvider.family<MangaDetailsModel, int>(
  (ref, mangaId) async {
    final repository = ref.read(
      mangaDetailsRepositoryProvider,
    );

    return repository.getMangaDetails(
      mangaId,
    );
  },
);

/// Provider to fetch real chapters list from MangaDex, with a graceful fallback to mock chapters if not found.
final mangaChaptersProvider = FutureProvider.family<List<ChapterModel>, int>(
  (ref, mangaId) async {
    final detailsAsync = ref.watch(mangaDetailsProvider(mangaId));
    final details = detailsAsync.valueOrNull;
    if (details == null) {
      return const [];
    }

    final dexApi = ref.read(mangaDexApiProvider);
    
    // Find all candidate MangaDex IDs using AniList/MAL details
    List<String> dexIds = await dexApi.findMangaDexIds(
      title: details.romajiTitle,
      aniListId: details.id,
      malId: details.idMal,
    );

    if (dexIds.isEmpty && details.englishTitle != null && details.englishTitle!.isNotEmpty) {
      dexIds = await dexApi.findMangaDexIds(
        title: details.englishTitle!,
        aniListId: details.id,
        malId: details.idMal,
      );
    }

    if (dexIds.isEmpty) {
      // Fallback: return mock chapters if not found on MangaDex
      final mockChapters = List.generate(
        details.chapters ?? 24,
        (i) => ChapterModel.mock(mangaId, i + 1),
      );
      mockChapters.sort((a, b) => a.number.compareTo(b.number));
      return mockChapters;
    }

    List<ChapterModel>? selectedChapters;
    String? selectedDexId;
    int selectedScore = -1;

    // Only ever a handful of authoritative (link-matched) candidates; cap the
    // scan so a fuzzy title fallback returning many IDs can't fan out into
    // dozens of full feed downloads. This bounds candidate MANGA, never chapters.
    const int maxCandidates = 6;
    final candidateIds =
        dexIds.length > maxCandidates ? dexIds.sublist(0, maxCandidates) : dexIds;

    for (final dexId in candidateIds) {
      try {
        final feed = await dexApi.getMangaFeed(dexId);

        final chaptersMap = <int, ChapterModel>{};
        // Tracks whether the retained entry for a chapter number is external
        // (VIZ/MangaPlus link, unreadable in-app) so a hosted duplicate can
        // upgrade it — without ever dropping the chapter from the list.
        final externalByNum = <int, bool>{};

        for (final item in feed) {
          final id = item['id'] as String;
          final attrs = item['attributes'] as Map<String, dynamic>? ?? {};
          final chStr = attrs['chapter'] as String? ?? '';
          if (chStr.isEmpty) continue; // Skip chapters without numbers

          final externalUrl = attrs['externalUrl'] as String?;
          final isExternal = externalUrl != null;

          int? parsed = int.tryParse(chStr);
          if (parsed == null) {
            final d = double.tryParse(chStr);
            if (d != null) {
              parsed = d.toInt();
            }
          }
          final chNum = parsed ?? 0;
          final rawTitle = attrs['title'] as String? ?? '';
          final title = rawTitle.isNotEmpty
              ? 'Chapter $chNum — $rawTitle'
              : 'Chapter $chNum';

          final publishAtStr = attrs['publishAt'] as String? ?? '';

          String dateStr = '';
          if (publishAtStr.isNotEmpty) {
            try {
              final dt = DateTime.parse(publishAtStr);
              dateStr = '${dt.day}/${dt.month}/${dt.year}';
            } catch (_) {}
          }

          final lang = (attrs['translatedLanguage'] as String? ?? 'en').toUpperCase();

          // Resolve the real translator from the included scanlation_group
          // relationship; fall back to a generic label if it's absent.
          String scanGroup = 'MangaDex';
          final relationships = item['relationships'] as List? ?? const [];
          for (final rel in relationships) {
            if (rel is Map && rel['type'] == 'scanlation_group') {
              final relAttrs = rel['attributes'] as Map?;
              final name = relAttrs?['name'];
              if (name is String && name.isNotEmpty) {
                scanGroup = name;
                break;
              }
            }
          }

          final chapterModel = ChapterModel(
            id: id,
            number: chNum,
            title: title,
            scanGroup: scanGroup,
            date: dateStr,
            language: lang,
            pages: const [],
          );

          final existing = chaptersMap[chNum];
          if (existing == null) {
            chaptersMap[chNum] = chapterModel;
            externalByNum[chNum] = isExternal;
          } else if ((externalByNum[chNum] ?? false) && !isExternal) {
            // Prefer a MangaDex-hosted version over a previously-seen external
            // one so the reader can actually load pages for this chapter.
            chaptersMap[chNum] = chapterModel;
            externalByNum[chNum] = false;
          }
        }

        if (chaptersMap.isEmpty) continue;

        final readableCount =
            externalByNum.values.where((external) => !external).length;
        // Rank by total unique chapters first (the canonical complete series
        // always wins), then by how many are readable in-app. This prevents a
        // small fully-hosted edition from shadowing the full series.
        final score = chaptersMap.length * 1000000 + readableCount;
        if (score > selectedScore) {
          selectedScore = score;
          selectedChapters = chaptersMap.values.toList();
          selectedDexId = dexId;
        }
      } catch (_) {
        // Continue to next candidate
      }
    }

    if (selectedChapters == null || selectedChapters.isEmpty) {
      final mockChapters = List.generate(
        details.chapters ?? 24,
        (i) => ChapterModel.mock(mangaId, i + 1),
      );
      mockChapters.sort((a, b) => a.number.compareTo(b.number));
      return mockChapters;
    }

    // Cache the chosen MangaDex ID so subsequent pages requests route to it
    if (selectedDexId != null) {
      MangaDexApi.uuidToId(selectedDexId);
      MangaDexApi.registerMapping(details.id, selectedDexId);
    }

    // Sort numerically by chapter number
    selectedChapters.sort((a, b) => a.number.compareTo(b.number));
    return selectedChapters;
  }
);

/// Argument helper for chapter pages provider
class ChapterPagesArg {
  final int mangaId;
  final int chapterNumber;

  ChapterPagesArg({
    required this.mangaId,
    required this.chapterNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterPagesArg &&
          runtimeType == other.runtimeType &&
          mangaId == other.mangaId &&
          chapterNumber == other.chapterNumber;

  @override
  int get hashCode => mangaId.hashCode ^ chapterNumber.hashCode;
}

/// Provider to fetch pages list for a specific chapter
final mangaChapterPagesProvider = FutureProvider.autoDispose.family<List<String>, ChapterPagesArg>(
  (ref, arg) async {
    final chaptersAsync = await ref.watch(mangaChaptersProvider(arg.mangaId).future);
    
    // Find the chapter with the matching number
    final chapterIndex = chaptersAsync.indexWhere((c) => c.number == arg.chapterNumber);
    if (chapterIndex == -1) {
      throw AppFailure.notFound('Chapter ${arg.chapterNumber} not found.');
    }
    
    final chapter = chaptersAsync[chapterIndex];

    if (chapter.id != null) {
      final dexApi = ref.read(mangaDexApiProvider);
      return await dexApi.getChapterPages(chapter.id!);
    }

    // Fallback to mock pages ONLY if the chapter has no MangaDex ID (e.g. mock manga)
    final mockChapter = ChapterModel.mock(arg.mangaId, arg.chapterNumber);
    return mockChapter.pages;
  }
);