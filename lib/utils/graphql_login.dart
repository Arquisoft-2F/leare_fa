import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/login_model.dart';

class GraphQLLogin {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();
  GraphQLClient client = graphQlConfig.clientToQuery();

  Future<LoginModel> login(
      {required String email, required String password}) async {
    String x = r"""
            mutation {
              login(
                email:"jsarmiento@gmail.com",
                password:"User@123"
                )
                {
                token
              }
            }
            """;
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
        ),
      );
      print("HOLA2");
      if (result.hasException) {
        throw Exception(result.exception);
      }
      print("HOLA1");
      if (result == null ||
          result.data == null ||
          result.data?['login'] == null) {
        throw Exception("Not login");
      }
      print("HOLA");
      LoginModel res = LoginModel.fromMap(map: result.data?['login']);
      print(res.token);
      print(res.flag);
      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}
