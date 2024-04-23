import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/chat/chat_message.dart';
import 'package:leare_fa/models/chat/chat_response.dart';

class GraphQLDeletes {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Future<bool> deleteCourse(String courseId) async {
    String x = r'''mutation DeleteCourse($course_id: ID!){
      deleteCourse(
        id:$course_id
      )
    }
  ''';
    try {
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
          variables: {
            'course_id': courseId,
          },
        ),
      );
      print(result);
      if (result.hasException) {
        throw Exception(result.exception);
      }

      bool? res = result.data?['deleteCourse'];

      if (res == null) {
        return false;
      }
      return res;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteModule(String moduleId) async {
    print(moduleId);
    String x = r'''mutation DeleteModule($module_id: ID!){
      deleteModule(
        id: $module_id
      )
    }
  ''';
    try {
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
          variables: {
            'module_id': moduleId,
          },
        ),
      );
      print(result);
      if (result.hasException) {
        return false;
      }

      bool? res = result.data?['deleteModule'];

      if (res == null) {
        return false;
      }
      return res;
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteSection(String sectionId) async {
    String x = r'''mutation DeleteSection($section_id: ID!){
      deleteSection(
        id: $section_id
      )
    }
  ''';
    try {
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
          variables: {
            'section_id': sectionId,
          },
        ),
      );
      print(result);
      if (result.hasException) {
        return false;
      }

      bool? res = result.data?['deleteSection'];

      if (res == null) {
        return false;
      }
      return res;
    } catch (error) {
      return false;
    }
  }
}
