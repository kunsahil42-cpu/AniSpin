class HomeQueries {
  // 🔥 Trending
  static const String trendingAnime = r'''
query TrendingAnime {
  Page(page: 1, perPage: 20) {
    media(
      type: ANIME
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
      }
      averageScore
      episodes
      genres
    }
  }
}
''';

  // 🌸 This Season
  static const String thisSeasonAnime = r'''
query ThisSeasonAnime {
  Page(page: 1, perPage: 20) {
    media(
      type: ANIME
      seasonYear: 2026
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
      }
      averageScore
      episodes
      genres
    }
  }
}
''';

  // 🆕 Just Released
  static const String justReleasedAnime = r'''
query JustReleasedAnime {
  Page(page: 1, perPage: 20) {
    media(
      type: ANIME
      sort: START_DATE_DESC
      isAdult: false
    ) {
      id
      title {
        romaji
        english
      }
      coverImage {
        extraLarge
      }
      averageScore
      episodes
      genres
    }
  }
}
''';

  // 🏆 Popular This Week
  static const String popularThisWeek = r'''
query PopularThisWeek {
  Page(page: 1, perPage: 20) {
    media(
      type: ANIME
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
      }
      averageScore
      episodes
      genres
    }
  }
}
''';
}