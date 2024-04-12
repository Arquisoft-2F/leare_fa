import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQlConfiguration {
  Future<GraphQLClient> clientToQuery() async {
    String? token = await getToken();
    final HttpLink httpLink = HttpLink(
      'http://35.215.20.21:5555/graphql',
      defaultHeaders: {
        'Authorization': 'Bearer ${token ?? ''}',
      },
    );
    return GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
  }

  Future<String?> getToken() async {
    SharedPreferences x = await SharedPreferences.getInstance();
    return x.getString('token');
  }
}
