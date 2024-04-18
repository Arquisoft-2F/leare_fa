import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/course_model.dart';

class GraphQLCourse {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Future<CourseModel> courseById({required String id}) async {
    String x = r'''query courseById ($id: ID!) {
    courseById(id: $id) {
      course_id
      course_name
      course_description
      creator_id
      chat_id
      is_public
      picture_id
      created_at
      updated_at
      categories {
        category_id
        category_name
      }
      modules {
        module_id
        module_name
        pos_index
        sections {
          section_id
          section_name
          section_content
          video_id
          files_array
          pos_index
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
          variables: {
            'id': id,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['courseById'] == null) {
        throw Exception("Course not found");
      }
      CourseModel res = CourseModel.fromMap(map: result.data?['courseById']);
      print(res);
      print(res.course_id);
      print(res.course_name);

      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}
