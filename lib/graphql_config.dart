import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlConfiguration {
  static HttpLink httpLink = HttpLink('http://35.215.20.21:5555/');

  GraphQLClient clientToQuery() => GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      );
}
