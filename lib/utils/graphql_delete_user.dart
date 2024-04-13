import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/user_model.dart';

class GraphQLDeleteUser {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Future<UserModel> deleteMe() async {
    String x = '''mutation deleteMe{
    deleteMe{
        id,
        nickname,
        name,
        lastname,
        picture_id,
        nationality,
        email,
        web_site,
        biography,
        twitter_link,
        linkedin_link,
        facebook_link,
        created_at,
        updated_at
    }
  }
''';
    try {
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null ||
          result.data?['deleteMe'] == null) {
        throw Exception("User not found");
      }
      UserModel res = UserModel.fromMap(map: result.data?['deleteMe']);

      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}
