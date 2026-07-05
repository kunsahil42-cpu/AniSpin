import 'dart:math';

import '../../../core/error/app_failure.dart';
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

      return MangaRollModel.fromJson(mediaList.first);
    } catch (e) {
      // Fallback to mock manga roll if API fails
      return MockDataHelper.getRandomMangaRoll();
    }
  }
}
