import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GraphQlConfiguration {
  Future<GraphQLClient> clientToQuery() async {
    String? token = await getToken();
    final http.Client httpClient = http.Client();
    final HttpLink httpLink = HttpLink(
      'https://35.215.30.59/graphql',
      defaultHeaders: {
        'Authorization': 'Bearer ${token ?? 'your_default_token_here'}',
      },
      httpClient: httpClient,
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
