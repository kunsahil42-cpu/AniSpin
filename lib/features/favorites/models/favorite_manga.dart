import 'package:isar/isar.dart';

part 'favorite_manga.g.dart';

@collection
class FavoriteManga {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int mangaId;

  late String romajiTitle;

  String? englishTitle;

  late String coverImage;

  String? bannerImage;

  int? chapters;

  int? volumes;

  String? status;

  String? author;

  DateTime addedAt = DateTime.now();
}