import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/course_model.dart';
import 'package:leare_fa/models/models.dart';

class GraphQLSection {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Future<SectionModel> sectionById({required String id}) async {
    String x = r'''query SectionById ($id: ID!) {
      sectionById(id: $id) {
        files_array
        pos_index
        section_content
        section_id
        section_name
        video_id
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

      // print(result);
      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['sectionById'] == null) {
        throw Exception("Section not found");
      }
      SectionModel res = SectionModel.fromMap(map: result.data?['sectionById']);
      print(res);

      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}
