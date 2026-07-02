class AnimeRollModel {
  final int id;
  final String title;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int? averageScore;
  final int? episodes;
  final List<String> genres;
  final String description;
  final String? status;

  AnimeRollModel({
    required this.id,
    required this.title,
    required this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.averageScore,
    required this.episodes,
    required this.genres,
    required this.description,
    required this.status,
  });

  factory AnimeRollModel.fromJson(Map<String, dynamic> json) {
    return AnimeRollModel(
      id: json['id'],

      title: json['title']['romaji'] ?? '',

      englishTitle: json['title']['english'],

      coverImage:
          json['coverImage']?['extraLarge'] ?? '',

      bannerImage: json['bannerImage'] ?? '',

      averageScore: json['averageScore'],

      episodes: json['episodes'],

      genres: List<String>.from(
        json['genres'] ?? [],
      ),

      description: json['description'] ?? '',

      status: json['status'],
    );
  }
}