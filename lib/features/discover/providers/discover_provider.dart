import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/discover_mode.dart';
import '../models/discover_anime_model.dart';
import '../models/discover_manga_model.dart';
import '../repository/discover_repository.dart';

final discoverRepositoryProvider =
    Provider<DiscoverRepository>((ref) {
  return DiscoverRepository();
});

final animeOfTheDayProvider =
    FutureProvider<DiscoverAnimeModel>((ref) async {
  return ref
      .read(discoverRepositoryProvider)
      .getAnimeOfTheDay();
});

final mangaOfTheDayProvider =
    FutureProvider<DiscoverMangaModel>((ref) async {
  return ref
      .read(discoverRepositoryProvider)
      .getMangaOfTheDay();
});

final discoverListProvider =
    FutureProvider.family<
        List<DiscoverAnimeModel>,
        DiscoverMode>((ref, mode) async {
  return ref
      .read(discoverRepositoryProvider)
      .getAnimeList(mode);
});