import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/network/graphql_service.dart';
import '../../../core/network/queries/anime_details_queries.dart';

class AnimeDetailsApi {
  Future<QueryResult> getAnimeDetails(int id) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(AnimeDetailsQueries.getAnimeDetails),
        variables: {
          'id': id,
        },
      ),
    );
  }
}