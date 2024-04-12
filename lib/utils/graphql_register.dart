import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/user_model.dart';

class GraphQLRegister {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Future<UserModel> createUser(
    {required UserModel userModel}) async {

     Map<String, dynamic> userMap = {
    'name': '"${userModel.name}"', // Include quotation marks around the value
    'lastname': '"${userModel.lastname}"',
    'nickname': '"${userModel.nickname}"',
    'email': '"${userModel.email}"',
    'nationality': '"${userModel.nationality}"',
    'picture_id': '"${userModel.picture_id}"',
    'web_site': '"${userModel.web_site}"', 
    'biography': '"${userModel.biography}"', 
    'linkedin_link': '"${userModel.linkedin_link}"', 
    'facebook_link': '"${userModel.facebook_link}"', 
    'twitter_link': '"${userModel.twitter_link}"',
    'created_at': '"${userModel.created_at}"',
    'updated_at': '"${userModel.updated_at}"',

  };
    String x = '''mutation CreateUser {
    createUser(user: $userMap) {
      
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
      if (result.data == null ||
          result.data?['updateMe'] == null) {
        throw Exception("User not found");
      }
      UserModel res = UserModel.fromMap(map: result.data?['updateMe']);

      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}
