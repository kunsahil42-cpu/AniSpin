import '../../../core/error/app_failure.dart';
import '../../../core/network/mock_data_helper.dart';
import '../data/search_api.dart';
import '../models/anime_model.dart';
import '../models/manga_model.dart';

class SearchRepository {
  final SearchApi _api = SearchApi();

  Future<List<AnimeModel>> searchAnime(String query) async {
    try {
      final result = await _api.searchAnime(query);

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final List media = result.data?['Page']?['media'] ?? [];

      return media
          .map((anime) => AnimeModel.fromJson(anime))
          .toList();
    } catch (e) {
      // Fallback to mock search results if API fails
      return MockDataHelper.getSearchAnime(query);
    }
  }

  Future<List<MangaModel>> searchManga(String query) async {
    try {
      final result = await _api.searchManga(query);

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final List media = result.data?['Page']?['media'] ?? [];

      return media
          .map((manga) => MangaModel.fromJson(manga))
          .toList();
    } catch (e) {
      // Fallback to mock search results if API fails
      return MockDataHelper.getSearchManga(query);
    }
  }
}