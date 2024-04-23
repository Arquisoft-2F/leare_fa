import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/user/user_model.dart';
import 'package:leare_fa/models/user_model.dart';
import 'package:leare_fa/models/feed_model.dart';

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

  Future<List<EnrollModel>> myCourses({required String user_id}) async {
    String x = r'''query MyCourses($user_id:ID!){
    myCourses(user_id:$user_id){
        course {
        course_id
        course_name
        course_description
        picture_id
        creator_id
      }
      progress
      score
      listed_on
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
            'user_id': user_id,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }
      List? res = result.data?['myCourses'];

      if (res == null || res.isEmpty) {
        return [];
      }
      List<EnrollModel> enrolls =
          res.map((enroll) => EnrollModel.fromMap(map: enroll)).toList();
      for (int i = 0; i < enrolls.length; i++) {
        try {
          if (enrolls[i].course.creatorId != null) {
            UserModel y = await userbyId(id: enrolls[i].course.creatorId!);
            enrolls[i] = EnrollModel(
                progress: enrolls[i].progress,
                score: enrolls[i].score,
                listed_on: enrolls[i].listed_on,
                course: Course(
                    id: enrolls[i].course.id,
                    name: enrolls[i].course.name,
                    description: enrolls[i].course.description,
                    picture: enrolls[i].course.picture,
                    creatorId: y.id,
                    creator: Creator(
                        id: y.id,
                        nickname: y.nickname,
                        picture: y.picture_id ?? "")));
            print(y.nickname);
          }
        } catch (error) {
          continue;
        }
      }
      print(enrolls[0].course.creator?.nickname);
      return enrolls;
    } catch (error) {
      throw Exception(error);
    }
  }
}
