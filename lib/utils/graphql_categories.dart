import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/models.dart';

class GraphQLCategories {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Future<List<CategoryModel>> getCategories() async {
    String x = r'''query Categories {
    categories {
        category_id
        category_name
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
      if (result.data == null || result.data?['categories'] == null) {
        throw Exception("Not categories");
      }

      List<CategoryModel> res = (result.data?['categories'] as List).map((e) => CategoryModel.fromMap(map: e)).toList();
      return res;

    } catch (error) {
      throw Exception(error);
    }
  }
}