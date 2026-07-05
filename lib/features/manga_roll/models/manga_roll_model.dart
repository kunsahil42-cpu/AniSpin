class MangaRollModel {
  final int id;
  final String title;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int? averageScore;
  final int? chapters;
  final int? volumes;
  final List<String> genres;
  final String description;
  final String? status;

  MangaRollModel({
    required this.id,
    required this.title,
    required this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.averageScore,
    required this.chapters,
    required this.volumes,
    required this.genres,
    required this.description,
    required this.status,
  });

  String get romajiTitle => title;

  factory MangaRollModel.fromJson(Map<String, dynamic> json) {
    return MangaRollModel(
      id: json['id'],
      title: json['title']['romaji'] ?? '',
      englishTitle: json['title']['english'],
      coverImage: json['coverImage']?['extraLarge'] ?? '',
      bannerImage: json['bannerImage'] ?? '',
      averageScore: json['averageScore'],
      chapters: json['chapters'],
      volumes: json['volumes'],
      genres: List<String>.from(json['genres'] ?? []),
      description: json['description'] ?? '',
      status: json['status'],
    );
  }
}
