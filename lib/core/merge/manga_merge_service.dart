import '../../features/manga_details/models/manga_details_model.dart';
import 'jikan_field_utils.dart';

/// Merges AniList and Jikan manga detail data into one final model.
///
/// AniList is authoritative: [fillMissing] only fills fields AniList left
/// empty/null and never overwrites a valid value. [fromJikan] builds a complete
/// model when AniList is entirely unavailable. (MangaDex chapter integration is
/// a separate, deferred source.)
class MangaMergeService {
  const MangaMergeService();

  bool hasGaps(MangaDetailsModel m) {
    return m.bannerImage.isEmpty ||
        m.coverImage.isEmpty ||
        m.description.isEmpty ||
        m.author.isEmpty ||
        m.averageScore == null ||
        m.chapters == null ||
        m.volumes == null ||
        m.genres.isEmpty;
  }

  MangaDetailsModel fillMissing(
    MangaDetailsModel m,
    Map<String, dynamic> j,
  ) {
    return MangaDetailsModel(
      id: m.id,
      idMal: m.idMal ?? JikanFieldUtils.intField(j, 'mal_id'),
      romajiTitle: m.romajiTitle,
      englishTitle: m.englishTitle,
      nativeTitle: m.nativeTitle,
      description: m.description.isEmpty
          ? JikanFieldUtils.string(j['synopsis'])
          : m.description,
      bannerImage: m.bannerImage.isEmpty
          ? JikanFieldUtils.banner(j)
          : m.bannerImage,
      coverImage: m.coverImage.isEmpty
          ? JikanFieldUtils.cover(j)
          : m.coverImage,
      averageScore: m.averageScore ?? JikanFieldUtils.score100(j),
      chapters: m.chapters ?? JikanFieldUtils.intField(j, 'chapters'),
      volumes: m.volumes ?? JikanFieldUtils.intField(j, 'volumes'),
      status: m.status ?? JikanFieldUtils.mediaStatus(j['status']),
      genres: m.genres.isEmpty ? JikanFieldUtils.genres(j) : m.genres,
      format: m.format ?? JikanFieldUtils.upper(j['type']),
      popularity: m.popularity ?? JikanFieldUtils.intField(j, 'members'),
      author: m.author.isEmpty ? JikanFieldUtils.firstAuthor(j) : m.author,
    );
  }

  MangaDetailsModel fromJikan(Map<String, dynamic> j) {
    return MangaDetailsModel(
      id: JikanFieldUtils.intField(j, 'mal_id') ?? 0,
      idMal: JikanFieldUtils.intField(j, 'mal_id'),
      romajiTitle: JikanFieldUtils.string(j['title']),
      englishTitle: j['title_english'] as String?,
      nativeTitle: j['title_japanese'] as String?,
      description: JikanFieldUtils.string(j['synopsis']),
      bannerImage: JikanFieldUtils.banner(j),
      coverImage: JikanFieldUtils.cover(j),
      averageScore: JikanFieldUtils.score100(j),
      chapters: JikanFieldUtils.intField(j, 'chapters'),
      volumes: JikanFieldUtils.intField(j, 'volumes'),
      status: JikanFieldUtils.mediaStatus(j['status']),
      genres: JikanFieldUtils.genres(j),
      format: JikanFieldUtils.upper(j['type']),
      popularity: JikanFieldUtils.intField(j, 'members'),
      author: JikanFieldUtils.firstAuthor(j),
    );
  }
}
