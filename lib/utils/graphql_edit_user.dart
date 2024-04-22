import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/user_model.dart';

class GraphQLEditUser {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  static String _escapeString(String input) {
    // Replace newline characters with escaped characters
    return input.replaceAll('\n', ' ');
  }

  String getLastPartOfUrl(String url) {
    // Updated RegExp to match the file name without the extension
    RegExp regex = RegExp(r'/([^/]+)\.\w+$');
    Match? match = regex.firstMatch(url);
    if (match != null && match.groupCount > 0) {
      return match.group(1)!; // group(1) to exclude the '.' and extension
    } else {
      return url; // returns the original url if no match found
    }
  }

  Future<UserModel> updateMe({required UserModel userModel}) async {
    Map<String, dynamic> userMap = {
      'name': '"${userModel.name}"', // Include quotation marks around the value
      'lastname': '"${userModel.lastname}"',
      'nickname': '"${userModel.nickname}"',
      'email': '"${userModel.email}"',
      'nationality': '"${userModel.nationality}"',
      'picture_id': '"${getLastPartOfUrl(userModel.picture_id!)}"',
      'web_site': '"${userModel.web_site}"',
      'biography': '"${_escapeString(userModel.biography as String)}"',
      'linkedin_link': '"${userModel.linkedin_link}"',
      'facebook_link': '"${userModel.facebook_link}"',
      'twitter_link': '"${userModel.twitter_link}"',
      'created_at': '"${userModel.created_at}"',
      'updated_at': '"${userModel.updated_at}"',
    };
    String x = '''mutation updateMe {
    updateMe(user: $userMap) {
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
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['updateMe'] == null) {
        throw Exception("User not found");
      }
      UserModel res = UserModel.fromMap(map: result.data?['updateMe']);

      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}
