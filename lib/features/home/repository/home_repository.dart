import '../data/home_api.dart';
import '../enums/home_section.dart';
import '../models/home_anime_model.dart';

class HomeRepository {
  final HomeApi _api = HomeApi();

  Future<List<HomeAnimeModel>> getAnime(
    HomeSection section,
  ) async {
    late final dynamic result;

    switch (section) {
      case HomeSection.trending:
        result = await _api.getTrendingAnime();
        break;

      case HomeSection.thisSeason:
        result = await _api.getThisSeasonAnime();
        break;

      case HomeSection.justReleased:
        result = await _api.getJustReleasedAnime();
        break;

      case HomeSection.popularThisWeek:
        result = await _api.getPopularThisWeek();
        break;

      case HomeSection.continueWatching:
        // Temporary until Continue Watching is implemented
        result = await _api.getTrendingAnime();
        break;
    }

    if (result.hasException) {
      throw Exception(
        result.exception.toString(),
      );
    }

    final List media =
        result.data!['Page']['media'];

    return media
        .map<HomeAnimeModel>(
          (anime) =>
              HomeAnimeModel.fromJson(anime),
        )
        .toList();
  }
}