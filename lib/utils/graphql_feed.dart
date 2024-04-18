import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/models.dart';

class GraphQLFeed {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Future<List<FeedModel>> getFeed() async {
    String x = r'''query GetFeed {
      listCoursesbyCategories {
        category {
          category_id
          category_name
        }
        courses {
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
      if (result.data == null || result.data?['listCoursesbyCategories'] == null) {
        throw Exception("Not feed");
      }

      List<FeedModel> res = (result.data?['listCoursesbyCategories'] as List).map((e) => FeedModel.fromMap(map: e)).toList();

      print(res.isNotEmpty ? res[0].category.name : null);

      return res;

    } catch (error) {
      throw Exception(error);
    }
  }
}