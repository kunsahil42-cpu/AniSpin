import 'dart:math';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../data/discover_api.dart';
import '../enums/discover_mode.dart';
import '../models/discover_anime_model.dart';
import '../models/discover_manga_model.dart';

class DiscoverRepository {
  final DiscoverApi _api = DiscoverApi();

  int _dailyPage() {
    final now = DateTime.now();
    final seed =
        now.year * 1000 +
        now.month * 100 +
        now.day;

    return Random(seed).nextInt(500) + 1;
  }

  Future<DiscoverAnimeModel> getAnimeOfTheDay() async {
    final result = await _api.getAnimeOfTheDay(
      _dailyPage(),
    );

    if (result.hasException) {
      throw Exception(
        result.exception.toString(),
      );
    }

    final media = result.data?['Page']?['media'];

    if (media == null || media.isEmpty) {
      throw Exception('Anime not found');
    }

    return DiscoverAnimeModel.fromJson(
      media.first,
    );
  }

  Future<DiscoverMangaModel> getMangaOfTheDay() async {
    final result = await _api.getMangaOfTheDay(
      _dailyPage(),
    );

    if (result.hasException) {
      throw Exception(
        result.exception.toString(),
      );
    }

    final media = result.data?['Page']?['media'];

    if (media == null || media.isEmpty) {
      throw Exception('Manga not found');
    }

    return DiscoverMangaModel.fromJson(
      media.first,
    );
  }

  Future<List<DiscoverAnimeModel>> getAnimeList(
    DiscoverMode mode, {
    int page = 1,
  }) async {
    late final QueryResult result;

    switch (mode) {
      case DiscoverMode.trending:
        result = await _api.getTrendingAnime(
          page,
        );
        break;

      case DiscoverMode.hiddenGems:
        result = await _api.getHiddenGems(
          page,
        );
        break;

      case DiscoverMode.airing:
        result = await _api.getAiringAnime(
          page,
        );
        break;

      case DiscoverMode.topRated:
        result = await _api.getTopRatedAnime(
          page,
        );
        break;

      case DiscoverMode.surpriseMe:
        result = await _api.getTrendingAnime(
          page,
        );
        break;
    }

    if (result.hasException) {
      throw Exception(
        result.exception.toString(),
      );
    }

    final List<dynamic> media =
        result.data?['Page']?['media'] ?? [];

    return media
        .map(
          (item) => DiscoverAnimeModel.fromJson(
            item,
          ),
        )
        .toList();
  }
}