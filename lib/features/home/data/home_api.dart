import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/network/graphql_service.dart';
import '../../../core/network/queries/home_queries.dart';

class HomeApi {
  Future<QueryResult> getTrendingAnime() {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(
          HomeQueries.trendingAnime,
        ),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  Future<QueryResult> getThisSeasonAnime() {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(
          HomeQueries.thisSeasonAnime,
        ),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  Future<QueryResult> getJustReleasedAnime() {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(
          HomeQueries.justReleasedAnime,
        ),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  Future<QueryResult> getPopularThisWeek() {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(
          HomeQueries.popularThisWeek,
        ),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }
}