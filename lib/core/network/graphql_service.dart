import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class LoggerLink extends Link {
  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    final vars = request.variables;
    
    debugPrint('--> [GraphQL Request] Operation: ${request.operation.operationName}');
    debugPrint('Variables: $vars');
    debugPrint('URL: https://graphql.anilist.co');
    debugPrint('Headers: {User-Agent: AniSpin/1.0.0 (Windows; Chrome)}');
    
    if (forward != null) {
      return forward(request).map((response) {
        debugPrint('<-- [GraphQL Response] Status Code: 200');
        if (response.errors != null && response.errors!.isNotEmpty) {
          debugPrint('Errors: ${response.errors?.map((e) => e.message).join(", ")}');
        } else {
          debugPrint('Data: ${response.data != null ? "SUCCESS (Payload non-null)" : "NULL"}');
        }
        return response;
      });
    }
    return const Stream.empty();
  }
}

class GraphQLService {
  static final HttpLink _httpLink = HttpLink(
    'https://graphql.anilist.co',
    defaultHeaders: {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );

  static final Link _link = Link.from([
    LoggerLink(),
    _httpLink,
  ]);

  static GraphQLClient get client {
    return GraphQLClient(
      link: _link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
}