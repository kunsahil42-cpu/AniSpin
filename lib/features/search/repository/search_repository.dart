import '../data/search_api.dart';
import '../models/anime_model.dart';

class SearchRepository {
  final SearchApi _api = SearchApi();

  Future<List<AnimeModel>> searchAnime(String query) async {
    final result = await _api.searchAnime(query);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List media = result.data?['Page']?['media'] ?? [];

    return media
        .map((anime) => AnimeModel.fromJson(anime))
        .toList();
  }
}