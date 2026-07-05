import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/watch_progress.dart';
import '../models/reading_progress.dart';
import '../repository/watch_progress_repository.dart';
import '../repository/reading_progress_repository.dart';

final watchProgressRepositoryProvider = Provider<WatchProgressRepository>((ref) {
  return WatchProgressRepository();
});

final readingProgressRepositoryProvider = Provider<ReadingProgressRepository>((ref) {
  return ReadingProgressRepository();
});

final continueWatchingProvider = StreamProvider<List<WatchProgress>>((ref) {
  final repo = ref.watch(watchProgressRepositoryProvider);
  return repo.watchContinueWatching();
});

final continueReadingProvider = StreamProvider<List<ReadingProgress>>((ref) {
  final repo = ref.watch(readingProgressRepositoryProvider);
  return repo.watchContinueReading();
});

final animeProgressProvider = FutureProvider.family<WatchProgress?, int>((ref, animeId) async {
  final repo = ref.watch(watchProgressRepositoryProvider);
  return repo.getProgress(animeId);
});

final mangaProgressProvider = FutureProvider.family<ReadingProgress?, int>((ref, mangaId) async {
  final repo = ref.watch(readingProgressRepositoryProvider);
  return repo.getProgress(mangaId);
});
