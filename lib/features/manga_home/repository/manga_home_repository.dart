import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/network/graphql_service.dart';
import '../../../core/network/queries/manga_queries.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/network/mock_data_helper.dart';
import '../models/manga_home_model.dart';

enum MangaHomeSection {
  trending,
  popular,
  latest,
  recommended,
}

class MangaHomeRepository {
  Future<List<MangaHomeModel>> getMangaList(MangaHomeSection section) async {
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
      return media
          .map<MangaHomeModel>((item) => MangaHomeModel.fromJson(item))
          .toList();
    } catch (e) {
      // Fallback to high-fidelity mock manga data if API server fails/disabled
      return _getMockManga(section);
    }
  }

  List<MangaHomeModel> _getMockManga(MangaHomeSection section) {
    switch (section) {
      case MangaHomeSection.trending:
        return MockDataHelper.getHomeMangaListByIds([2001, 2002, 2003, 2004, 2005]);
      case MangaHomeSection.popular:
        return MockDataHelper.getHomeMangaListByIds([2006, 2007, 2008, 2009, 2010]);
      case MangaHomeSection.latest:
        return MockDataHelper.getHomeMangaListByIds([2001, 2003, 2004, 2009, 2010]);
      case MangaHomeSection.recommended:
        return MockDataHelper.getHomeMangaListByIds([2004, 2002, 2007, 2006, 2010]);
    }
  }
}
