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

  // 🌸 This Season — current season is resolved dynamically at call time
  static const String thisSeasonAnime = r'''
query ThisSeasonAnime($season: MediaSeason, $seasonYear: Int) {
  Page(page: 1, perPage: 20) {
    media(
      type: ANIME
      season: $season
      seasonYear: $seasonYear
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

  // 🆕 Just Released — most recently premiered titles that are actually airing
  static const String justReleasedAnime = r'''
query JustReleasedAnime {
  Page(page: 1, perPage: 20) {
    media(
      type: ANIME
      status: RELEASING
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

  // 🏆 Popular This Week
  static const String popularThisWeek = r'''
query PopularThisWeek {
  Page(page: 1, perPage: 20) {
    media(
      type: ANIME
      status: RELEASING
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
}