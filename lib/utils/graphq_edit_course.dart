import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/create_course_model.dart';
import 'package:leare_fa/models/models.dart';
import 'package:leare_fa/models/my_courses_model.dart';

class GraphQLEditCourse {
  static GraphQlConfiguration graphQlConfig = GraphQlConfiguration();

  String getLastPartOfUrl(String url) {
    // Updated RegExp to match the file name without the extension
    RegExp regex = RegExp(r'/([^/]+)\.\w+$');
    Match? match = regex.firstMatch(url);
    if (match != null && match.groupCount > 0) {
      return match.group(1)!; // group(1) to exclude the '.' and extension
    } else {
      return url; // returns the original url if no match found
    }
  }

  static String _escapeString(String input) {
    // Replace newline characters with escaped characters
    return input.replaceAll('\n', ' ');
  }

  Map<String, dynamic> createCourseModelToMap(
      {required CreateCourseModel createCourseModel}) {
    Map<String, dynamic> map = {
      'course_id': '"${createCourseModel.course_id}"',
      'course_name': '"${createCourseModel.course_name}"',
      'course_description':
          '"${_escapeString(createCourseModel.course_description)}"',
      'is_public': '${createCourseModel.is_public}',
      'picture_id': '"${getLastPartOfUrl(createCourseModel.picture_id)}"',
      'categories':
          '[${createCourseModel.categories.map((str) => '"$str"').join(',')}]',
    };
    if (createCourseModel.chat_id != null) {
      map['chat_id'] = '"${createCourseModel.chat_id}"';
    }
    return map;
  }

  Future<String> editCourse(
      {required CreateCourseModel createCourseModel}) async {
    var map = createCourseModelToMap(createCourseModel: createCourseModel);
    String x = '''mutation editCourse {
    editCourse(input: $map) {
        course_id
    }
}
    ''';
    try {
      GraphQLClient client = await graphQlConfig.clientToQuery();
      QueryResult result = await client.mutate(MutationOptions(
        fetchPolicy: FetchPolicy.noCache,
        document: gql(x),
        variables: {
          'input': map,
        },
      ));
      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['editCourse'] == null) {
        throw Exception("No Courses");
      }
      String res = result.data?['editCourse']['course_id'];
      return res;
    } catch (error) {
      throw Exception(error);
    }
  }
}
