import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/create_course_model.dart';
import 'package:leare_fa/models/models.dart';
import 'package:leare_fa/models/my_courses_model.dart';

class GraphQLCreateCourse {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Map<String, dynamic> createCourseModelToMap({required CreateCourseModel createCourseModel}) {
    Map<String, dynamic> map = {
      'course_name': '"${createCourseModel.course_name}"',
      'course_description': '"${createCourseModel.course_description}"',
      'picture_id': '"${createCourseModel.picture_id}"',
      'categories': '[${createCourseModel.categories.map((str) => '"$str"').join(',')}]',
    };
    return map;
  }
  
  Future<String> createCourse({required CreateCourseModel createCourseModel}) async {

    var map = createCourseModelToMap(createCourseModel: createCourseModel);
    
    String x = '''mutation createCourse {
    createCourse(input: $map) {
        course_id
    }
}
    ''';
    try {
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
          variables: {
            'input': map,
          },
        )
      );
      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['createCourse'] == null) {
        throw Exception("No Courses");
      }

      Future<String> res = (result.data?['createCourse']);

      return res;

    } catch (error) {
      throw Exception(error);
    }
  }
}