import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/models.dart';
import 'package:leare_fa/models/my_courses_model.dart';

class GraphQLMyCourses {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Future<List<MyCoursesModel>> myCourses({required String userId}) async {
    String x = r'''query myCourses {
      myCourses(user_id: $userId){
        course {
          course_id
          course_name
          course_description
          picture_id
          creator {
            id
            nickname
            picture_id
          }
        }
      }
    }
    ''';
    try {
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
        )
      );
      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['myCourses'] == null) {
        throw Exception("No Courses");
      }

      List<MyCoursesModel> res = (result.data?['myCourses'] as List).map((e) => MyCoursesModel.fromMap(map: e)).toList();

      return res;

    } catch (error) {
      throw Exception(error);
    }
  }
}