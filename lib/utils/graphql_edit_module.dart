import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';

class GraphQLEditModule {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  
  Future<String> editModule({required String module_name, required String module_id, required int pos_index}) async {

    
    String x = '''mutation editModule {
    editModule(moduleEdit: {
        module_name: "$module_name",
        module_id: "$module_id",
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
      if (result.data == null || result.data?['editModule'] == null) {
        throw Exception("No Courses");
      } 
      String res = result.data?['editModule']['module_id'];
      return res;

    } catch (error) {
      throw Exception(error);
    }
  }
}