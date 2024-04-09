import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/models.dart';

class GraphQLLogin {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();
  GraphQLClient client = graphQlConfig.clientToQuery();

  Future<LoginModel> login(
      {required String email, required String password}) async {
    String x = r'''mutation Login($email: String!, $password: String!) {
    login(email: $email, password: $password) {
      token,
      flag,
      message
    }
  }
''';
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
          variables: {
            'email': email,
            'password': password,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result == null ||
          result.data == null ||
          result.data?['login'] == null) {
        throw Exception("Not login");
      }
      LoginModel res = LoginModel.fromMap(map: result.data?['login']);

      print(res.token);
      print(res.message);
      print(res.flag);

      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}
