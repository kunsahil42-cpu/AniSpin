import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/manga_home_model.dart';
import '../repository/manga_home_repository.dart';

final mangaHomeRepositoryProvider = Provider<MangaHomeRepository>((ref) {
  return MangaHomeRepository();
});

final mangaHomeSectionProvider = FutureProvider.family<List<MangaHomeModel>, MangaHomeSection>((ref, section) async {
  final repo = ref.watch(mangaHomeRepositoryProvider);
  return repo.getMangaList(section);
});
