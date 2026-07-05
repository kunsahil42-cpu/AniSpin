import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/manga_roll_model.dart';
import '../repository/manga_roll_repository.dart';

class MangaRollFilters {
  final String? genre;
  final String? format;
  final int? minScore;

  const MangaRollFilters({
    this.genre,
    this.format,
    this.minScore,
  });

  bool get isEmpty => genre == null && format == null && minScore == null;

  MangaRollFilters copyWith({
    String? genre,
    String? format,
    int? minScore,
    bool clearGenre = false,
    bool clearFormat = false,
    bool clearMinScore = false,
  }) {
    return MangaRollFilters(
      genre: clearGenre ? null : (genre ?? this.genre),
      format: clearFormat ? null : (format ?? this.format),
      minScore: clearMinScore ? null : (minScore ?? this.minScore),
    );
  }
}

final mangaRollRepositoryProvider = Provider<MangaRollRepository>((ref) {
  return MangaRollRepository();
});

final mangaRollFiltersProvider = StateProvider<MangaRollFilters>((ref) {
  return const MangaRollFilters();
});

final mangaRollProvider =
    FutureProvider.autoDispose<MangaRollModel>((ref) async {
  final repository = ref.watch(mangaRollRepositoryProvider);
  final filters = ref.watch(mangaRollFiltersProvider);

  return repository.getRandomManga(
    genre: filters.genre,
    format: filters.format,
    minScore: filters.minScore,
  );
});
