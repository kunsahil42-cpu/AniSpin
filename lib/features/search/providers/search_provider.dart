import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/anime_model.dart';
import '../models/manga_model.dart';
import '../repository/search_repository.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository();
});

final animeSearchProvider =
    FutureProvider.family<List<AnimeModel>, String>((ref, query) async {
  final repository = ref.read(searchRepositoryProvider);

  if (query.trim().isEmpty) {
    return [];
  }

  return repository.searchAnime(query);
});

final mangaSearchProvider =
    FutureProvider.family<List<MangaModel>, String>((ref, query) async {
  final repository = ref.read(searchRepositoryProvider);

  if (query.trim().isEmpty) {
    return [];
  }

  return repository.searchManga(query);
});