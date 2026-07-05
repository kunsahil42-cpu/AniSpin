import 'dart:math';

import '../../../core/error/app_failure.dart';
import '../../../core/network/jikan/jikan_api.dart';
import '../../../core/network/mock_data_helper.dart';
import '../data/anime_roll_api.dart';
import '../models/anime_roll_model.dart';

class AnimeRollRepository {
  final AnimeRollApi _api = AnimeRollApi();
  final Random _random = Random();

  Future<AnimeRollModel> getRandomAnime({
    String? genre,
    String? format,
    int? minScore,
  }) async {
    try {
      // 1. Get the total number of items matching filters
      final pageInfoResult = await _api.getRandomAnime(
        page: 1,
        genre: genre,
        format: format,
        minScore: minScore,
      );

      if (pageInfoResult.hasException) {
        throw AppFailure.fromOperation(pageInfoResult.exception);
      }

      final total =
          pageInfoResult.data?['Page']?['pageInfo']?['total'] as int? ?? 0;

      if (total == 0) {
        throw AppFailure.notFound('No anime found matching your filters.');
      }

      // 2. Select a random page. Cap at 500.
      final maxPages = min(total, 500);
      final randomPage = _random.nextInt(maxPages) + 1;

      // 3. Query the random page
      final result = await _api.getRandomAnime(
        page: randomPage,
        genre: genre,
        format: format,
        minScore: minScore,
      );

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final mediaList = result.data?['Page']?['media'] as List?;

      if (mediaList == null || mediaList.isEmpty) {
        throw AppFailure.notFound('No anime found.');
      }

      var model = AnimeRollModel.fromJson(mediaList.first);

      // Back-fill missing fields from Jikan if AniList leaves gaps
      if (model.hasGaps) {
        try {
          final jikan = JikanApi();
          final jikanData = await jikan.getAnimeFull(model.idMal ?? model.id);
          if (jikanData != null) {
            model = model.fillMissing(jikanData);
          }
        } catch (_) {
          // Ignore backfill failures and proceed with AniList-only data
        }
      }

      return model;
    } catch (e) {
      try {
        return await _tryJikanFallback(
          genre: genre,
          format: format,
          minScore: minScore,
        );
      } catch (_) {
        // Fallback to high-fidelity mock anime roll if both fail
        return MockDataHelper.getRandomAnimeRoll();
      }
    }
  }

  Future<AnimeRollModel> _tryJikanFallback({
    String? genre,
    String? format,
    int? minScore,
  }) async {
    final JikanApi jikan = JikanApi();

    // Build query parameters
    final params = <String, String>{
      'limit': '25',
      'sfw': 'true',
      'order_by': 'popularity',
      'sort': 'desc',
    };
    if (minScore != null) {
      params['min_score'] = (minScore / 10).toString();
    }
    if (format != null) {
      String type = format.toLowerCase().replaceAll('_', '');
      if (type == 'tvshort') type = 'tv';
      params['type'] = type;
    }

    final randomPage = _random.nextInt(5) + 1;
    final queryString = '?page=$randomPage&${Uri(queryParameters: params).query}';

    final list = await jikan.fetchList('/anime$queryString');

    if (list.isEmpty) {
      // Try page 1 if page N is empty
      final queryStringPage1 = '?page=1&${Uri(queryParameters: params).query}';
      final listPage1 = await jikan.fetchList('/anime$queryStringPage1');
      if (listPage1.isEmpty) {
        throw Exception('No Jikan anime found');
      }
      final item = listPage1[_random.nextInt(listPage1.length)];
      return AnimeRollModel.fromJikan(item);
    }

    final item = list[_random.nextInt(list.length)];
    return AnimeRollModel.fromJikan(item);
  }
}