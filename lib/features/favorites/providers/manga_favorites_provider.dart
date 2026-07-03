import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/favorite_manga.dart';
import '../repository/manga_favorites_repository.dart';

final mangaFavoritesRepositoryProvider =
    Provider<MangaFavoritesRepository>(
  (ref) => MangaFavoritesRepository(),
);

final mangaFavoritesProvider =
    StreamProvider<List<FavoriteManga>>(
  (ref) {
    return ref
        .read(mangaFavoritesRepositoryProvider)
        .watchFavorites();
  },
);

final isMangaFavoriteProvider =
    FutureProvider.family<bool, int>(
  (ref, mangaId) async {
    return ref
        .read(mangaFavoritesRepositoryProvider)
        .isFavorite(mangaId);
  },
);

/// Manga Favorites Controller
///
/// Handles all write operations related to manga favorites.
final mangaFavoritesControllerProvider =
    Provider<MangaFavoritesController>(
  (ref) {
    return MangaFavoritesController(
      ref.read(mangaFavoritesRepositoryProvider),
    );
  },
);

class MangaFavoritesController {
  MangaFavoritesController(this._repository);

  final MangaFavoritesRepository _repository;

  Future<void> addFavorite(
    FavoriteManga manga,
  ) async {
    await _repository.addFavorite(manga);
  }

  Future<void> removeFavorite(
    int mangaId,
  ) async {
    await _repository.removeFavorite(mangaId);
  }

  Future<void> toggleFavorite(
    FavoriteManga manga,
  ) async {
    await _repository.toggleFavorite(manga);
  }

  Future<bool> isFavorite(
    int mangaId,
  ) async {
    return _repository.isFavorite(mangaId);
  }
}