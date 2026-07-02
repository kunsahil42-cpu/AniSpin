import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/network/graphql_service.dart';
import '../../../core/network/queries/discover_queries.dart';

class DiscoverApi {
  Future<QueryResult> getAnimeOfTheDay(int page) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(DiscoverQueries.animeOfTheDay),
        variables: {
          'page': page,
        },
      ),
    );
  }

  Future<QueryResult> getMangaOfTheDay(int page) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(DiscoverQueries.mangaOfTheDay),
        variables: {
          'page': page,
        },
      ),
    );
  }

  Future<QueryResult> getRandomAnime(int page) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(DiscoverQueries.randomAnime),
        variables: {
          'page': page,
        },
      ),
    );
  }

  Future<QueryResult> getTrendingAnime(int page) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(DiscoverQueries.trendingAnime),
        variables: {
          'page': page,
        },
      ),
    );
  }

  Future<QueryResult> getHiddenGems(int page) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(DiscoverQueries.hiddenGems),
        variables: {
          'page': page,
        },
      ),
    );
  }

  Future<QueryResult> getTopRatedAnime(int page) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(DiscoverQueries.topRatedAnime),
        variables: {
          'page': page,
        },
      ),
    );
  }

  Future<QueryResult> getAiringAnime(int page) async {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(DiscoverQueries.airingAnime),
        variables: {
          'page': page,
        },
      ),
    );
  }
}