import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlConfiguration {
  static HttpLink httpLink = HttpLink('http://35.215.20.21:5555/graphql', defaultHeaders: {
  'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOiIwNDg2YmRjMC05ZDg2LTQ0ZTgtYTk5Mi1hZDg4Zjk0YjI1ZWMiLCJVc2VybmFtZSI6ImpzYXJtaWVudG9wdSIsIlJvbGUiOiJ0ZWFjaGVyIiwiZXhwIjoxNzEyNzg0NDAyLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAyIiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NzIwMiJ9.vb30P_FZFGK19jvSZ05c3idGRXulgt_3nIenDI2t_jY',
 },);

  GraphQLClient clientToQuery() => GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
        
      );
}
