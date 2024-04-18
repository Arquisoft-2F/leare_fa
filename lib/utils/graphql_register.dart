import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/user_model.dart';

class GraphQLRegister {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

    static String _escapeString(String input) {
    // Replace newline characters with escaped characters
    return input.replaceAll('\n', ' ');
  }

  Future<String> createUser(
    {required UserModel userModel, required String password, required String confirmPassword, required String role}) async {

     Map<String, dynamic> userMap = {
    'name': '"${userModel.name}"', // Include quotation marks around the value
    'lastname': '"${userModel.lastname}"',
    'nickname': '"${userModel.nickname}"',
    'email': '"${userModel.email}"',
    'nationality': '"${userModel.nationality}"',
    'picture_id': null,
    'web_site': '"${userModel.web_site}"', 
    'biography': '"${_escapeString(userModel.biography as String)}"', 
    'linkedin_link': '"${userModel.linkedin_link}"', 
    'facebook_link': '"${userModel.facebook_link}"', 
    'twitter_link': '"${userModel.twitter_link}"',

  };
    String x = '''mutation CreateUser {
    createUser(user: $userMap, password: "$password", confirmPassword: "$confirmPassword", rol: "$role") {
      users {
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
      token
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
          result.data?['createUser'] == null) {
        throw Exception("User not created");
      }
      String res = result.data?['createUser']['token'];
      print(res);
      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}