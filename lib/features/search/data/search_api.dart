import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/network/graphql_service.dart';
import '../../../core/network/queries/anime_queries.dart';
import '../../../core/network/queries/manga_queries.dart';

class SearchApi {
  Future<QueryResult> searchAnime(String search) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(AnimeQueries.searchAnime),
        variables: {
          'search': search,
        },
      ),
    );
  }

  Future<QueryResult> searchManga(String search) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(MangaQueries.searchManga),
        variables: {
          'search': search,
        },
      ),
    );
  }
}