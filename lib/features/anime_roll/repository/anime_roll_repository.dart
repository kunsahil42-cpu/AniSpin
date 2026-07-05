import 'dart:math';

import '../../../core/error/app_failure.dart';
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

      return AnimeRollModel.fromJson(mediaList.first);
    } catch (e) {
      // Fallback to high-fidelity mock anime roll if API fails
      return MockDataHelper.getRandomAnimeRoll();
    }
  }
}