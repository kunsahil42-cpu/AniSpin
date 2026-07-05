import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../error/app_failure.dart';

/// Thin REST client for the Jikan v4 API (unofficial MyAnimeList API).
///
/// Used as an automatic fallback for AniList across Home and details. It never
/// returns mock data and never leaks a raw HTTP status or the word "Jikan" to
/// the UI — every failure becomes a friendly [AppFailure] that the shared
/// [AsyncNetworkView] renders as a clean error/retry state.
///
/// Reliability:
///  * Requests are funnelled through a serial gate spaced by [_minGap] so bursts
///    (several Home sections falling back at once) respect Jikan's ~3 req/s cap.
///  * Transient upstream failures (429 / 5xx / timeout / network) are retried
///    up to [_maxAttempts] times with linear backoff before giving up. A single
///    504 no longer fails a section.
///  * `404` is treated as a definitive "not found" and is never retried.
class JikanApi {
  JikanApi([http.Client? client]) : _client = client ?? http.Client();

  static const String _base = 'https://api.jikan.moe/v4';
  static const Duration _minGap = Duration(milliseconds: 350);
  static const Duration _timeout = Duration(seconds: 10);
  static const int _maxAttempts = 2;
  static const Duration _backoffUnit = Duration(milliseconds: 500);

  final http.Client _client;

  /// Serial gate shared across all instances so bursts respect the rate limit.
  static Future<void> _gate = Future<void>.value();

  Future<T> _throttled<T>(Future<T> Function() task) {
    final completer = Completer<T>();
    _gate = _gate.then((_) async {
      try {
        completer.complete(await task());
      } catch (e, s) {
        completer.completeError(e, s);
      }
      await Future<void>.delayed(_minGap);
    });
    return completer.future;
  }

  /// GET a list endpoint (e.g. `/top/anime`). Returns the `data` array.
  Future<List<dynamic>> fetchList(String path) async {
    final body = await _requestWithRetry(path);
    return (body['data'] as List?) ?? const [];
  }

  /// Tries each candidate endpoint in order, returning the first non-empty
  /// result. Each candidate is independently retried by [fetchList]. Only if
  /// every candidate fails does a friendly [AppFailure] propagate.
  ///
  /// This is the "don't stop after one failure" guarantee applied across
  /// endpoints: a section whose ideal (heavier) endpoint is timing out upstream
  /// automatically falls back to a lighter, more reliable one.
  Future<List<dynamic>> fetchListFallback(List<String> paths) async {
    AppFailure lastFailure = AppFailure.server();
    for (final path in paths) {
      try {
        final data = await fetchList(path);
        if (data.isNotEmpty) return data;
      } on AppFailure catch (e) {
        lastFailure = e;
      }
    }
    throw lastFailure;
  }

  /// GET a single-object endpoint (e.g. `/anime/{id}/full`). Returns `data`.
  Future<Map<String, dynamic>?> fetchOne(String path) async {
    final body = await _requestWithRetry(path);
    return body['data'] as Map<String, dynamic>?;
  }

  /// GET /anime/{id}/full
  Future<Map<String, dynamic>?> getAnimeFull(int id) =>
      fetchOne('/anime/$id/full');

  /// GET /anime/{id}
  Future<Map<String, dynamic>?> getAnime(int id) =>
      fetchOne('/anime/$id');

  /// GET /anime/{id}/characters
  Future<List<dynamic>> getAnimeCharacters(int id) =>
      fetchList('/anime/$id/characters');

  /// GET /anime/{id}/staff
  Future<List<dynamic>> getAnimeStaff(int id) =>
      fetchList('/anime/$id/staff');

  /// GET /anime/{id}/episodes
  Future<List<dynamic>> getAnimeEpisodes(int id) =>
      fetchList('/anime/$id/episodes');

  /// GET /anime/{id}/episodes/{episode}
  Future<Map<String, dynamic>?> getAnimeEpisode(int id, int episode) =>
      fetchOne('/anime/$id/episodes/$episode');

  /// GET /anime/{id}/videos
  Future<Map<String, dynamic>?> getAnimeVideos(int id) =>
      fetchOne('/anime/$id/videos');

  /// GET /anime/{id}/videos/episodes
  Future<List<dynamic>> getAnimeVideoEpisodes(int id) =>
      fetchList('/anime/$id/videos/episodes');

  /// GET /anime/{id}/pictures
  Future<List<dynamic>> getAnimePictures(int id) =>
      fetchList('/anime/$id/pictures');

  /// GET /anime/{id}/statistics
  Future<Map<String, dynamic>?> getAnimeStatistics(int id) =>
      fetchOne('/anime/$id/statistics');

  /// GET /anime/{id}/moreinfo
  Future<Map<String, dynamic>?> getAnimeMoreInfo(int id) =>
      fetchOne('/anime/$id/moreinfo');

  /// GET /manga/{id}/full
  Future<Map<String, dynamic>?> getMangaFull(int id) =>
      fetchOne('/manga/$id/full');

  /// GET /manga/{id}
  Future<Map<String, dynamic>?> getManga(int id) =>
      fetchOne('/manga/$id');

  /// GET /manga/{id}/characters
  Future<List<dynamic>> getMangaCharacters(int id) =>
      fetchList('/manga/$id/characters');

  /// GET /manga/{id}/news
  Future<List<dynamic>> getMangaNews(int id) =>
      fetchList('/manga/$id/news');

  /// GET /manga/{id}/forum
  Future<List<dynamic>> getMangaForum(int id) =>
      fetchList('/manga/$id/forum');

  /// GET /manga/{id}/pictures
  Future<List<dynamic>> getMangaPictures(int id) =>
      fetchList('/manga/$id/pictures');

  /// GET /manga/{id}/statistics
  Future<Map<String, dynamic>?> getMangaStatistics(int id) =>
      fetchOne('/manga/$id/statistics');

  /// GET /manga/{id}/moreinfo
  Future<Map<String, dynamic>?> getMangaMoreInfo(int id) =>
      fetchOne('/manga/$id/moreinfo');

  /// GET /manga/{id}/recommendations
  Future<List<dynamic>> getMangaRecommendations(int id) =>
      fetchList('/manga/$id/recommendations');

  /// GET /manga/{id}/userupdates
  Future<List<dynamic>> getMangaUserUpdates(int id) =>
      fetchList('/manga/$id/userupdates');

  /// GET /manga/{id}/reviews
  Future<List<dynamic>> getMangaReviews(int id) =>
      fetchList('/manga/$id/reviews');

  /// GET /manga/{id}/relations
  Future<List<dynamic>> getMangaRelations(int id) =>
      fetchList('/manga/$id/relations');

  /// GET /manga/{id}/external
  Future<List<dynamic>> getMangaExternal(int id) =>
      fetchList('/manga/$id/external');

  /// GET /manga
  Future<List<dynamic>> getMangaList({
    int? page,
    String? query,
    String? type,
    String? status,
    Map<String, String>? queryParams,
  }) {
    final Map<String, String> params = {};
    if (page != null) params['page'] = page.toString();
    if (query != null) params['q'] = query;
    if (type != null) params['type'] = type;
    if (status != null) params['status'] = status;
    if (queryParams != null) params.addAll(queryParams);

    final queryString = params.isNotEmpty
        ? '?${Uri(queryParameters: params).query}'
        : '';
    return fetchList('/manga$queryString');
  }

  /// Performs the request, retrying transient upstream failures. Throws a
  /// friendly [AppFailure] only after every attempt is exhausted.
  Future<Map<String, dynamic>> _requestWithRetry(String path) async {
    AppFailure lastFailure = AppFailure.server();

    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      if (attempt > 1) {
        await Future<void>.delayed(_backoffUnit * (attempt - 1));
      }

      try {
        final res = await _throttled(() => _rawGet(path));

        if (res.statusCode == 200) {
          return jsonDecode(res.body) as Map<String, dynamic>;
        }

        if (res.statusCode == 404) {
          // Definitive — do not retry.
          throw AppFailure.notFound('This title could not be found.');
        }

        // 429 / 500 / 502 / 503 / 504 … transient upstream problem → retry.
        lastFailure = AppFailure.server();
        _log('HTTP ${res.statusCode} on $path (attempt $attempt/$_maxAttempts)');
      } on AppFailure catch (e) {
        if (e.type == AppFailureType.notFound) rethrow;
        // Network / timeout → retry.
        lastFailure = e;
        _log('${e.type.name} on $path (attempt $attempt/$_maxAttempts)');
      }
    }

    throw lastFailure;
  }

  /// A single HTTP GET. Returns the raw response, or throws a network
  /// [AppFailure] on socket/timeout/host-lookup problems.
  Future<http.Response> _rawGet(String path) async {
    try {
      return await _client.get(Uri.parse('$_base$path')).timeout(_timeout);
    } catch (e) {
      throw AppFailure.from(e);
    }
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[JikanApi] $message');
  }
}
