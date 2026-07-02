import 'dart:math';

import '../data/anime_roll_api.dart';
import '../models/anime_roll_model.dart';

class AnimeRollRepository {
  final AnimeRollApi _api = AnimeRollApi();
  final Random _random = Random();

  Future<AnimeRollModel> getRandomAnime() async {
    // Random page between 1 and 500
    final randomPage = _random.nextInt(500) + 1;

    final result = await _api.getRandomAnime(randomPage);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final mediaList = result.data?['Page']?['media'];

    if (mediaList == null || mediaList.isEmpty) {
      throw Exception('No anime found.');
    }

    return AnimeRollModel.fromJson(mediaList.first);
  }
}