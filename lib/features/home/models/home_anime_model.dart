class HomeAnimeModel {
  final int id;
  final String title;
  final String coverImage;
  final int? averageScore;
  final int? episodes;

  const HomeAnimeModel({
    required this.id,
    required this.title,
    required this.coverImage,
    this.averageScore,
    this.episodes,
  });

  factory HomeAnimeModel.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as Map<String, dynamic>?;

    return HomeAnimeModel(
      id: json['id'],
      title: title?['english'] ??
          title?['romaji'] ??
          'Unknown',
      coverImage: json['coverImage']['extraLarge'],
      averageScore: json['averageScore'],
      episodes: json['episodes'],
    );
  }
}