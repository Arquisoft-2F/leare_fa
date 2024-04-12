import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/user_model.dart';

class GraphQLUser {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();


  Future<UserModel> userbyId({required String id}) async {
    String x = r'''query userById ($id: ID!) {
    userById(id: $id) {
      id,
      name,
      lastname,
      nickname,
      email,
      nationality,
      picture_id,
      web_site,
      biography,
      linkedin_link,
      facebook_link,
      twitter_link
    }
  }
''';
    try {
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
          variables: {
            'id': id,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['userById'] == null) {
        throw Exception("User not found");
      }
      UserModel res = UserModel.fromMap(map: result.data?['userById']);

      print(res.id);
      print(res.name);
      print(res.nickname);

      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}
