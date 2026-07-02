class AnimeDetailsModel {
  final int id;

  final String romajiTitle;
  final String? englishTitle;
  final String? nativeTitle;

  final String description;

  final String bannerImage;
  final String coverImage;

  final int? averageScore;
  final int? episodes;
  final String? status;

  final List<String> genres;

  final String? season;
  final int? seasonYear;

  final int? duration;
  final String? format;

  final int? popularity;

  final String studio;

  AnimeDetailsModel({
    required this.id,
    required this.romajiTitle,
    required this.englishTitle,
    required this.nativeTitle,
    required this.description,
    required this.bannerImage,
    required this.coverImage,
    required this.averageScore,
    required this.episodes,
    required this.status,
    required this.genres,
    required this.season,
    required this.seasonYear,
    required this.duration,
    required this.format,
    required this.popularity,
    required this.studio,
  });

  factory AnimeDetailsModel.fromJson(Map<String, dynamic> json) {
    return AnimeDetailsModel(
      id: json['id'],

      romajiTitle: json['title']['romaji'] ?? '',
      englishTitle: json['title']['english'],
      nativeTitle: json['title']['native'],

      description: json['description'] ?? '',

      bannerImage: json['bannerImage'] ?? '',

      coverImage: json['coverImage']['extraLarge'] ??
          json['coverImage']['large'] ??
          '',

      averageScore: json['averageScore'],

      episodes: json['episodes'],

      status: json['status'],

      genres: List<String>.from(json['genres'] ?? []),

      season: json['season'],

      seasonYear: json['seasonYear'],

      duration: json['duration'],

      format: json['format'],

      popularity: json['popularity'],

      studio: (json['studios']?['nodes'] as List?)?.isNotEmpty == true
          ? json['studios']['nodes'][0]['name']
          : '',
    );
  }
}