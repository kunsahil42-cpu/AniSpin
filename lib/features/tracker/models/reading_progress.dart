import 'package:isar/isar.dart';

part 'reading_progress.g.dart';

@collection
class ReadingProgress {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int mangaId;

  late String romajiTitle;
  String? englishTitle;
  late String coverImage;
  String? bannerImage;

  int? totalChapters;

  // Last read chapter info
  late int lastReadChapter;
  late int lastReadPage;
  late double readingPercentage;
  late DateTime lastReadAt;

  // Completed chapters list
  List<int> completedChapters = [];
}
