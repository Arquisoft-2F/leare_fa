import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlConfiguration {
  static HttpLink httpLink = HttpLink('http://35.215.20.21:5555/graphql', defaultHeaders: {
  'Authorization': 'Bearer',
 },);

  GraphQLClient clientToQuery() => GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
        
      );
}
