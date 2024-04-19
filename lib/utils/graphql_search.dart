import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/models.dart';

class GraphQLSearch {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

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
      GraphQLClient client = await graphQlConfig.clientToQuery();
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
      if (result.data == null || result.data?['getPosts'] == null) {
        throw Exception("Not search");
      }

      List<SearchModel> res = (result.data?['getPosts'] as List).map((e) => SearchModel.fromMap(map: e)).toList();

      print(res.isNotEmpty ? res[0].post.picture : null);

      return res;

    } catch (error) {
      throw Exception(error);
    }
  }
}