import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';
import 'package:universal_io/io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQlConfiguration {
  Future<GraphQLClient> clientToQuery() async {
    String? token = await getToken();
    HttpClient _httpClient = new HttpClient();
    _httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient _ioClient = new IOClient(_httpClient);
    final HttpLink httpLink = HttpLink(
      'https://35.215.61.223/graphql',
      defaultHeaders: {
        'Authorization': 'Bearer ${token ?? 'your_default_token_here'}',
      },
      httpClient: _ioClient,
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
