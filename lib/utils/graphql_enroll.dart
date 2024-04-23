import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/course_model.dart';

class GraphQLEnroll {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  Future<String> createEnrollment(
      {required String idCourse, required String idUser}) async {
    String x =
        r'''mutation createEnrollment ($idCourse: String!,$idUser: String!) {
    createEnrollment(course_id: $idCourse, user_id: $idUser) {
      course_id
    }
  }
''';
    try {
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
          variables: {
            'idCourse': idCourse,
            'idUser': idUser,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['createEnrollment'] == null) {
        throw Exception("Could not enroll to course");
      }

      String res = result.data?['createEnrollment']['course_id'];
      print(res);

      return res;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> deleteEnrollment(
      {required String idCourse, required String idUser}) async {
    String x =
        r'''mutation deleteEnrollment ($idCourse: String!,$idUser: String!) {
    deleteEnrollment(course_id: $idCourse, user_id: $idUser) {
      course_id
    }
  }
''';
    try {
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(x),
          variables: {
            'idCourse': idCourse,
            'idUser': idUser,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['deleteEnrollment'] == null) {
        throw Exception("Could not delete enroll to course");
      }

      String res = result.data?['deleteEnrollment']['course_id'];
      print(res);

      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}
