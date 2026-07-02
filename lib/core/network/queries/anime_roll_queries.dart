class AnimeRollQueries {
  static const String randomAnime = r'''
query RandomAnime($page: Int) {
  Page(page: $page, perPage: 1) {
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

      bannerImage

      averageScore

      episodes

      genres

      description(asHtml: false)

      status
    }
  }
}
''';
}