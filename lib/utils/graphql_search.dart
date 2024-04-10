import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/models.dart';

class GraphQLSearch {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();
  GraphQLClient client = graphQlConfig.clientToQuery();

  Future<List<SearchModel>> search({ required String q }) async {
    String x = r'''query Search($q: String!) {
      getPosts(q: $q) {
        highlight {
          name
          lastname
          nickname
          description
        }
        post {
          name
          lastname
          nickname
          picture
          id
          description
          type
        }
      }
    }
    ''';
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
          variables: {
            'q': q,
          },
        )
      );
      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result == null || result.data == null || result.data?['getPosts'] == null) {
        throw Exception("Not search");
      }

      List<SearchModel> res = (result.data?['getPosts'] as List).map((e) => SearchModel.fromMap(map: e)).toList();

      print(res.isNotEmpty ? res[0].highlight.name : null);

      return res;

    } catch (error) {
      throw Exception(error);
    }
  }
}