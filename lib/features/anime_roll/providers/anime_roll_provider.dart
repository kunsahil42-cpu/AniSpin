import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/anime_roll_model.dart';
import '../repository/anime_roll_repository.dart';

class AnimeRollFilters {
  final String? genre;
  final String? format;
  final int? minScore;

  const AnimeRollFilters({
    this.genre,
    this.format,
    this.minScore,
  });

  bool get isEmpty => genre == null && format == null && minScore == null;

  AnimeRollFilters copyWith({
    String? genre,
    String? format,
    int? minScore,
    bool clearGenre = false,
    bool clearFormat = false,
    bool clearMinScore = false,
  }) {
    return AnimeRollFilters(
      genre: clearGenre ? null : (genre ?? this.genre),
      format: clearFormat ? null : (format ?? this.format),
      minScore: clearMinScore ? null : (minScore ?? this.minScore),
    );
  }
}

final animeRollRepositoryProvider = Provider<AnimeRollRepository>((ref) {
  return AnimeRollRepository();
});

final animeRollFiltersProvider = StateProvider<AnimeRollFilters>((ref) {
  return const AnimeRollFilters();
});

final animeRollProvider =
    FutureProvider.autoDispose<AnimeRollModel>((ref) async {
  final repository = ref.watch(animeRollRepositoryProvider);
  final filters = ref.watch(animeRollFiltersProvider);

  return repository.getRandomAnime(
    genre: filters.genre,
    format: filters.format,
    minScore: filters.minScore,
  );
});