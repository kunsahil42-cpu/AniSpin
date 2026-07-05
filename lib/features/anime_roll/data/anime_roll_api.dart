import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/network/graphql_service.dart';
import '../../../core/network/queries/anime_roll_queries.dart';

class AnimeRollApi {
  Future<QueryResult> getRandomAnime({
    required int page,
    String? genre,
    String? format,
    int? minScore,
  }) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(AnimeRollQueries.randomAnime),
        variables: {
          'page': page,
          if (genre != null) 'genre': genre,
          if (format != null) 'format': format,
          if (minScore != null) 'minScore': minScore,
        },
      ),
    );
  }
}