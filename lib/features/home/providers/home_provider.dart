import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/home_section.dart';
import '../models/home_anime_model.dart';
import '../repository/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepository(),
);

final homeSectionProvider =
    FutureProvider.family<
        List<HomeAnimeModel>,
        HomeSection>(
  (ref, section) async {
    return ref
        .read(homeRepositoryProvider)
        .getAnime(section);
  },
);

enum HomeType { anime, manga }

final homeTypeProvider = StateProvider<HomeType>((ref) => HomeType.anime);