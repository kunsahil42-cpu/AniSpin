import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/favorite_anime.dart';
import '../repository/favorites_repository.dart';

final favoritesRepositoryProvider =
    Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(),
);

final favoritesProvider =
    StreamProvider<List<FavoriteAnime>>(
  (ref) {
    return ref
        .read(favoritesRepositoryProvider)
        .watchFavorites();
  },
);

final isFavoriteProvider =
    FutureProvider.family<bool, int>(
  (ref, animeId) async {
    return ref
        .read(favoritesRepositoryProvider)
        .isFavorite(animeId);
  },
);

/// Favorites Controller
///
/// Handles all write operations related to favorites.
/// This keeps UI logic separate from database logic.
final favoritesControllerProvider =
    Provider<FavoritesController>(
  (ref) {
    return FavoritesController(
      ref.read(favoritesRepositoryProvider),
    );
  },
);

class FavoritesController {
  FavoritesController(this._repository);

  final FavoritesRepository _repository;

  Future<void> addFavorite(
    FavoriteAnime anime,
  ) async {
    await _repository.addFavorite(anime);
  }

  Future<void> removeFavorite(
    int animeId,
  ) async {
    await _repository.removeFavorite(animeId);
  }

  Future<void> toggleFavorite(
    FavoriteAnime anime,
  ) async {
    await _repository.toggleFavorite(anime);
  }

  Future<bool> isFavorite(
    int animeId,
  ) async {
    return _repository.isFavorite(animeId);
  }
}