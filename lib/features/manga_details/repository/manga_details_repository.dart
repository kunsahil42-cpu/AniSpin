import '../../../core/error/app_failure.dart';
import '../../../core/merge/manga_merge_service.dart';
import '../../../core/network/jikan/jikan_api.dart';
import '../../../core/network/mangadex/mangadex_api.dart';
import '../../../core/network/mock_data_helper.dart';
import '../data/manga_details_api.dart';
import '../models/manga_details_model.dart';

class MangaDetailsRepository {
  final MangaDetailsApi _api = MangaDetailsApi();
  final MangaDexApi _dexApi;
  final JikanApi _jikan = JikanApi();
  final MangaMergeService _merge = const MangaMergeService();

  MangaDetailsRepository({required MangaDexApi dexApi}) : _dexApi = dexApi;

  // In-memory session cache of merged models by id.
  final Map<int, MangaDetailsModel> _cache = {};

  Future<MangaDetailsModel> getMangaDetails(int id) async {
    final cached = _cache[id];
    if (cached != null) return cached;

    // Check if this is a hashed MangaDex ID
    final cachedUuid = MangaDexApi.idToUuid(id);
    if (cachedUuid != null) {
      try {
        final dexData = await _dexApi.getMangaDetails(cachedUuid);
        final model = _merge.fromMangaDex(dexData, cachedUuid);
        _cache[id] = model;
        return model;
      } catch (_) {
        return MockDataHelper.getMangaDetails(id);
      }
    }

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

      // AniList responded, enrich with MangaDex first (never overwrites valid AniList data)
      try {
        String? dexId = await _dexApi.findMangaDexId(
          title: model.romajiTitle,
          aniListId: model.id,
          malId: model.idMal,
        );

        if (dexId == null && model.englishTitle != null && model.englishTitle!.isNotEmpty) {
          dexId = await _dexApi.findMangaDexId(
            title: model.englishTitle!,
            aniListId: model.id,
            malId: model.idMal,
          );
        }

        if (dexId != null) {
          final dexData = await _dexApi.getMangaDetails(dexId);
          model = _merge.fillMissingFromMangaDex(model, dexData, dexId);
        }
      } catch (_) {
        // Ignore enrichment errors
      }

      // If there are still gaps, back-fill from Jikan
      if (_merge.hasGaps(model)) {
        final jikan = await _tryJikan(model.idMal ?? id);
        if (jikan != null) {
          model = _merge.fillMissing(model, jikan);
        }
      }
    } catch (_) {
      try {
        // AniList failed. Try to fetch from Jikan first to resolve the metadata/title,
        // then try to search MangaDex.
        final jikan = await _tryJikan(id);
        if (jikan == null) {
          return MockDataHelper.getMangaDetails(id);
        }
        var jikanModel = _merge.fromJikan(jikan);

        // Try to enrich Jikan metadata from MangaDex
        try {
          final dexId = await _dexApi.findMangaDexId(
            title: jikanModel.romajiTitle,
            malId: jikanModel.idMal,
          );
          if (dexId != null) {
            final dexData = await _dexApi.getMangaDetails(dexId);
            jikanModel = _merge.fillMissingFromMangaDex(jikanModel, dexData, dexId);
          }
        } catch (_) {}

        model = jikanModel;
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
