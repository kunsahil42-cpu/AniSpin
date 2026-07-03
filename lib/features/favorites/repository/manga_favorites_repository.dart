import 'package:isar/isar.dart';

import '../../../core/database/isar_service.dart';
import '../models/favorite_manga.dart';

class MangaFavoritesRepository {
  Isar get _isar => IsarService.instance;

  Future<void> addFavorite(
    FavoriteManga manga,
  ) async {
    await _isar.writeTxn(() async {
      await _isar.favoriteMangas.put(manga);
    });
  }

  Future<void> removeFavorite(
    int mangaId,
  ) async {
    final favorite = await _isar.favoriteMangas
        .filter()
        .mangaIdEqualTo(mangaId)
        .findFirst();

    if (favorite == null) return;

    await _isar.writeTxn(() async {
      await _isar.favoriteMangas.delete(
        favorite.id,
      );
    });
  }

  Future<bool> isFavorite(
    int mangaId,
  ) async {
    final favorite = await _isar.favoriteMangas
        .filter()
        .mangaIdEqualTo(mangaId)
        .findFirst();

    return favorite != null;
  }

  Future<List<FavoriteManga>> getFavorites() async {
    return await _isar.favoriteMangas
        .where()
        .sortByAddedAtDesc()
        .findAll();
  }

  Future<void> toggleFavorite(
    FavoriteManga manga,
  ) async {
    final exists = await isFavorite(
      manga.mangaId,
    );

    if (exists) {
      await removeFavorite(
        manga.mangaId,
      );
    } else {
      await addFavorite(
        manga,
      );
    }
  }

  Stream<List<FavoriteManga>> watchFavorites() {
    return _isar.favoriteMangas
        .where()
        .watch(
          fireImmediately: true,
        );
  }
}