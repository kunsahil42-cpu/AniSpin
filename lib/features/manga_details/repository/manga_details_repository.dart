import '../../../core/error/app_failure.dart';
import '../../../core/merge/manga_merge_service.dart';
import '../../../core/network/jikan/jikan_api.dart';
import '../../../core/network/mock_data_helper.dart';
import '../data/manga_details_api.dart';
import '../models/manga_details_model.dart';

class MangaDetailsRepository {
  final MangaDetailsApi _api = MangaDetailsApi();
  final JikanApi _jikan = JikanApi();
  final MangaMergeService _merge = const MangaMergeService();

  // In-memory session cache of merged models by id.
  final Map<int, MangaDetailsModel> _cache = {};

  Future<MangaDetailsModel> getMangaDetails(int id) async {
    final cached = _cache[id];
    if (cached != null) return cached;

    MangaDetailsModel model;
    try {
      final result = await _api.getMangaDetails(id);

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final data = result.data?['Media'];
      if (data == null) {
        throw AppFailure.notFound("This manga couldn't be found.");
      }

      model = MangaDetailsModel.fromJson(data);

      // AniList responded but left gaps → back-fill only the missing fields
      // from Jikan (never overwrites valid AniList data).
      if (_merge.hasGaps(model)) {
        final jikan = await _tryJikan(model.idMal ?? id);
        if (jikan != null) {
          model = _merge.fillMissing(model, jikan);
        }
      }
    } catch (_) {
      try {
        // AniList failed (403 / 429 / 500 / network). Try to load from Jikan.
        final jikan = await _tryJikan(id);
        if (jikan == null) {
          // If Jikan also fails/404s (e.g. for mock IDs), fallback to mock data
          return MockDataHelper.getMangaDetails(id);
        }
        model = _merge.fromJikan(jikan);
      } catch (_) {
        return MockDataHelper.getMangaDetails(id);
      }
    }

    _cache[id] = model;
    return model;
  }

  /// Fetches a Jikan manga record, returning null on any failure.
  Future<Map<String, dynamic>?> _tryJikan(int malId) async {
    try {
      return await _jikan.fetchOne('/manga/$malId/full');
    } catch (_) {
      return null;
    }
  }
}
