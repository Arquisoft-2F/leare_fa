import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:universal_io/io.dart';

class GraphQlConfiguration {
  Future<GraphQLClient> clientToQuery() async {
    String? token = await getToken();
    HttpClient _httpClient = new HttpClient();
    _httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient _ioClient = new IOClient(_httpClient);
    final HttpLink httpLink = HttpLink(
      'https://35.215.30.59/graphql',
      defaultHeaders: {
        
        'Authorization':
            'Bearer ${token ?? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOiIwNDg2YmRjMC05ZDg2LTQ0ZTgtYTk5Mi1hZDg4Zjk0YjI1ZWMiLCJVc2VybmFtZSI6ImpzYXJtaWVudG9wIiwiUm9sZSI6InRlYWNoZXIiLCJleHAiOjE3MTI5Nzc0MzYsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDIiLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo3MjAyIn0.0h_R-lf1YpR1mCfPJWLflywtN03EEbogFks2Mi7C5v4'}',
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
