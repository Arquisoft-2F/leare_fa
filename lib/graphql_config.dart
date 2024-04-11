import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQlConfiguration {
  GraphQLClient clientToQuery() {
    return GraphQLClient(
        cache: GraphQLCache(),
        link: HttpLink('http://35.215.20.21:5555/graphql', defaultHeaders: {
          'Authorization': 'Bearer ',
        }));
  }

  Future<String?> getToken() async {
    SharedPreferences x = await SharedPreferences.getInstance();
    return x.getString('token');
  }
}
