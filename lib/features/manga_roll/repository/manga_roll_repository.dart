import 'dart:math';

import '../../../core/error/app_failure.dart';
import '../../../core/network/jikan/jikan_api.dart';
import '../../../core/network/mock_data_helper.dart';
import '../data/manga_roll_api.dart';
import '../models/manga_roll_model.dart';

class MangaRollRepository {
  final MangaRollApi _api = MangaRollApi();
  final Random _random = Random();

  Future<MangaRollModel> getRandomManga({
    String? genre,
    String? format,
    int? minScore,
  }) async {
    try {
      // 1. Fetch total matching entries
      final pageInfoResult = await _api.getRandomManga(
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
        throw AppFailure.notFound('No manga found matching your filters.');
      }

      // 2. Select a random page. Cap at 500
      final maxPages = min(total, 500);
      final randomPage = _random.nextInt(maxPages) + 1;

      // 3. Fetch the item
      final result = await _api.getRandomManga(
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
        throw AppFailure.notFound('No manga found.');
      }

      var model = MangaRollModel.fromJson(mediaList.first);

      // Back-fill missing fields from Jikan if AniList leaves gaps
      if (model.hasGaps) {
        try {
          final jikan = JikanApi();
          final jikanData = await jikan.getMangaFull(model.idMal ?? model.id);
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
        // Fallback to mock manga roll if both API and Jikan fail
        return MockDataHelper.getRandomMangaRoll();
      }
    }
  }

  Future<MangaRollModel> _tryJikanFallback({
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
      final type = format.toLowerCase().replaceAll('_', '');
      params['type'] = type;
    }

    // Select a random item by fetching from a random page among the first few pages
    final randomPage = _random.nextInt(5) + 1;

    final list = await jikan.getMangaList(
      page: randomPage,
      queryParams: params,
    );

    if (list.isEmpty) {
      // Try page 1 if page N is empty
      final listPage1 = await jikan.getMangaList(
        page: 1,
        queryParams: params,
      );
      if (listPage1.isEmpty) {
        throw Exception('No Jikan manga found');
      }
      final item = listPage1[_random.nextInt(listPage1.length)];
      return MangaRollModel.fromJikan(item);
    }

    final item = list[_random.nextInt(list.length)];
    return MangaRollModel.fromJikan(item);
  }
}
