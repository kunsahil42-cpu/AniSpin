import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/mangadex/mangadex_api.dart';
import '../models/manga_home_model.dart';
import '../repository/manga_home_repository.dart';

final mangaHomeRepositoryProvider = Provider<MangaHomeRepository>((ref) {
  return MangaHomeRepository(
    mangaDex: ref.watch(mangaDexApiProvider),
  );
});

final mangaHomeSectionProvider = FutureProvider.family<List<MangaHomeModel>, MangaHomeSection>((ref, section) async {
  final repo = ref.watch(mangaHomeRepositoryProvider);
  return repo.getMangaList(section);
});
