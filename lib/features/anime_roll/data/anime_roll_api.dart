import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/network/graphql_service.dart';
import '../../../core/network/queries/anime_roll_queries.dart';

class AnimeRollApi {
  Future<QueryResult> getRandomAnime(int page) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(AnimeRollQueries.randomAnime),
        variables: {
          'page': page,
        },
      ),
    );
  }
}