import '../data/anime_details_api.dart';
import '../models/anime_details_model.dart';

class AnimeDetailsRepository {
  final AnimeDetailsApi _api = AnimeDetailsApi();

  Future<AnimeDetailsModel> getAnimeDetails(int id) async {
    final result = await _api.getAnimeDetails(id);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data?['Media'];

    if (data == null) {
      throw Exception('Anime not found');
    }

    return AnimeDetailsModel.fromJson(data);
  }
}