import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/create_course_model.dart';
import 'package:leare_fa/models/models.dart';
import 'package:leare_fa/models/my_courses_model.dart';

class GraphQLCreateModule {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  
  Future<String> createModule({required String module_name, required String course_id, required int pos_index}) async {

    
    String x = '''mutation createModule {
    createModule(input: {
        module_name: "$module_name",
        course_id: "$course_id",
        pos_index: $pos_index
    
    } ) {
        module_id
    }
}
    ''';
    try {
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
        )
      );
      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['createModule'] == null) {
        throw Exception("No Courses");
      } 
      String res = result.data?['createModule']['module_id'];
      return res;

    } catch (error) {
      throw Exception(error);
    }
  }
}