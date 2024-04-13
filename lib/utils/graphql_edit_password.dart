import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';

class GraphQLEditPassword {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Future<String> changePassword(
    {required String oldPassword, required String newPassword, required String id}) async {

    String x = '''mutation changePassword {
    editPassword(id: "$id", OldPassword: "$oldPassword", NewPassword: "$newPassword") {
      message,
      flag
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
          result.data?['editPassword'] == null) {
        throw Exception("User not found");
      }
      String res = result.data?['editPassword']['flag'];

      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}
