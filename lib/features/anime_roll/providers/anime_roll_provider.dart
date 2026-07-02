import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/anime_roll_model.dart';
import '../repository/anime_roll_repository.dart';

final animeRollRepositoryProvider =
    Provider<AnimeRollRepository>((ref) {
  return AnimeRollRepository();
});

final animeRollProvider =
    FutureProvider<AnimeRollModel>((ref) async {
  final repository = ref.read(animeRollRepositoryProvider);

  return repository.getRandomAnime();
});