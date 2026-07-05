class MangaQueries {
  static const String trendingManga = r'''
query TrendingManga($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: MANGA
      sort: TRENDING_DESC
      isAdult: false
    ) {
      id
      title {
        romaji
        english
      }
      coverImage {
        extraLarge
        large
      }
      averageScore
      genres
      chapters
    }
  }
}
''';

  static const String popularManga = r'''
query PopularManga($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: MANGA
      sort: POPULARITY_DESC
      isAdult: false
    ) {
      id
      title {
        romaji
        english
      }
      coverImage {
        extraLarge
        large
      }
      averageScore
      genres
      chapters
    }
  }
}
''';

  static const String latestManga = r'''
query LatestManga($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: MANGA
      sort: UPDATED_AT_DESC
      isAdult: false
    ) {
      id
      title {
        romaji
        english
      }
      coverImage {
        extraLarge
        large
      }
      averageScore
      genres
      chapters
    }
  }
}
''';

  static const String recommendedManga = r'''
query RecommendedManga($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: MANGA
      sort: SCORE_DESC
      isAdult: false
    ) {
      id
      title {
        romaji
        english
      }
      coverImage {
        extraLarge
        large
      }
      averageScore
      genres
      chapters
    }
  }
}
''';
}
