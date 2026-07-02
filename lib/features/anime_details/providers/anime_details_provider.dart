import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/anime_details_model.dart';
import '../repository/anime_details_repository.dart';

final animeDetailsRepositoryProvider =
    Provider<AnimeDetailsRepository>((ref) {
  return AnimeDetailsRepository();
});

final animeDetailsProvider =
    FutureProvider.family<AnimeDetailsModel, int>((ref, animeId) async {
  final repository = ref.read(animeDetailsRepositoryProvider);

  return repository.getAnimeDetails(animeId);
});