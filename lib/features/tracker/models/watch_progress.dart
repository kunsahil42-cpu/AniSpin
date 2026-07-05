import 'package:isar/isar.dart';

part 'watch_progress.g.dart';

@collection
class WatchProgress {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int animeId;

  late String romajiTitle;
  String? englishTitle;
  late String coverImage;
  String? bannerImage;

  int? totalEpisodes;

  // Last watched episode info
  late int lastWatchedEpisode;
  late int lastWatchedPosition; // in milliseconds
  late int lastWatchedDuration; // in milliseconds
  late double watchPercentage;
  late String lastWatchedSource;
  late String lastWatchedAudio; // sub or dub
  late DateTime lastWatchedAt;

  // Completed episodes list
  List<int> completedEpisodes = [];
}
