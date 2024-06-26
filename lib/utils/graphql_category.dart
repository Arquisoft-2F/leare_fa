import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/models.dart';

class GraphQLCategory {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Future<List<Course>> getCoursesByCategory({ required String category }) async {
    String x = r'''query getCoursesByCategory($categories: [String]!) {
      coursesByCategory(categories: $categories) {
        course_id
        course_name
        course_description
        picture_id
        creator_id
        creator {
          id
          nickname
          picture_id
        }
      }
    }
    ''';
    try {
      print('>>> $category');
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
          variables: {
            'categories': [category],
          },
        )
      );
      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['coursesByCategory'] == null) {
        throw Exception("Not courses");
      }

      List<Course> res = (result.data?['coursesByCategory'] as List).map((e) => Course.fromMap(map: e)).toList();

      print(res.isNotEmpty ? res[0].name : null);

      return res;

    } catch (error) {
      throw Exception(error);
    }
  }
}