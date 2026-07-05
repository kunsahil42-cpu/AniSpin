import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/network/graphql_service.dart';
import '../../../core/network/jikan/jikan_api.dart';
import '../../../core/network/queries/manga_queries.dart';
import '../../../core/error/app_failure.dart';
import '../models/manga_home_model.dart';

enum MangaHomeSection {
  trending,
  popular,
  latest,
  recommended,
}

class MangaHomeRepository {
  final JikanApi _jikan = JikanApi();

  // In-memory session cache (mirrors HomeRepository) so a section is fetched
  // from whichever source succeeds at most once per [_cacheDuration].
  final Map<MangaHomeSection, List<MangaHomeModel>> _cache = {};
  final Map<MangaHomeSection, DateTime> _cacheTime = {};

  static const Duration _cacheDuration = Duration(minutes: 5);

  Future<List<MangaHomeModel>> getMangaList(MangaHomeSection section) async {
    final cached = _cache[section];
    final cachedAt = _cacheTime[section];
    if (cached != null &&
        cachedAt != null &&
        DateTime.now().difference(cachedAt) < _cacheDuration) {
      return cached;
    }

    try {
      late final String query;
      switch (section) {
        case MangaHomeSection.trending:
          query = MangaQueries.trendingManga;
          break;
        case MangaHomeSection.popular:
          query = MangaQueries.popularManga;
          break;
        case MangaHomeSection.latest:
          query = MangaQueries.latestManga;
          break;
        case MangaHomeSection.recommended:
          query = MangaQueries.recommendedManga;
          break;
      }

      final result = await GraphQLService.client.query(
        QueryOptions(
          document: gql(query),
          variables: {'page': 1},
        ),
      );

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final List media = result.data?['Page']?['media'] ?? [];
      final list = media
          .map<MangaHomeModel>((item) => MangaHomeModel.fromJson(item))
          .toList();
      _cache[section] = list;
      _cacheTime[section] = DateTime.now();
      return list;
    } catch (_) {
      // AniList failed (403 / 429 / 500 / network) → automatic Jikan fallback.
      // If Jikan also fails, the AppFailure propagates to a clean error state.
      final list = await _fetchMangaFromJikan(section);
      _cache[section] = list;
      _cacheTime[section] = DateTime.now();
      return list;
    }
  }

  /// Fetches the equivalent section from Jikan when AniList is unavailable.
  /// Each section tries its ideal endpoint first, then falls back to more
  /// reliable ones so an upstream timeout on one endpoint doesn't blank it.
  Future<List<MangaHomeModel>> _fetchMangaFromJikan(
    MangaHomeSection section,
  ) async {
    final data = await _jikan.fetchListFallback(_jikanMangaPaths(section));
    return data
        .whereType<Map<String, dynamic>>()
        .map(_mangaFromJikan)
        .toList();
  }

  List<String> _jikanMangaPaths(MangaHomeSection section) {
    switch (section) {
      case MangaHomeSection.trending:
        return const [
          '/top/manga?filter=publishing&limit=20',
          '/top/manga?limit=20',
        ];
      case MangaHomeSection.popular:
        return const [
          '/top/manga?filter=bypopularity&limit=20',
          '/top/manga?limit=20',
        ];
      case MangaHomeSection.latest:
        return const [
          '/top/manga?filter=publishing&limit=20',
          '/top/manga?limit=20',
        ];
      case MangaHomeSection.recommended:
        return const [
          '/top/manga?limit=20',
          '/top/manga?filter=bypopularity&limit=20',
        ];
    }
  }

  MangaHomeModel _mangaFromJikan(Map<String, dynamic> j) {
    final jpg = (j['images'] as Map<String, dynamic>?)?['jpg']
        as Map<String, dynamic>?;
    final english = j['title_english'] as String?;
    final score = j['score'];
    final chapters = j['chapters'];
    final genres = (j['genres'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((g) => g['name']?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList() ??
        <String>[];

    return MangaHomeModel(
      id: (j['mal_id'] as num?)?.toInt() ?? 0,
      title: (english != null && english.isNotEmpty)
          ? english
          : (j['title'] as String? ?? 'Unknown'),
      coverImage: (jpg?['large_image_url'] ?? jpg?['image_url'] ?? '') as String,
      averageScore: score is num ? (score * 10).round() : null,
      genres: genres,
      chapters: chapters is num ? chapters.toInt() : null,
    );
  }
}
