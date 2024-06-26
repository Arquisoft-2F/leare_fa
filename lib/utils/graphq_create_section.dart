import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:leare_fa/graphql_config.dart';
import 'package:leare_fa/models/course_model.dart';
import 'package:leare_fa/models/create_course_model.dart';
import 'package:leare_fa/models/models.dart';
import 'package:leare_fa/models/my_courses_model.dart';

class GraphQLCreateSection {
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

    createSectiontoMap({required SectionModel sectionModel, required String module_id}) {
    Map<String, dynamic> map = {
      'module_id': '"${module_id}"',
      'section_name': '"${sectionModel.section_name}"',
      'section_content': '"${_escapeString(sectionModel.section_content)}"',
      'video_id': '"${getLastPartOfUrl(sectionModel.video_id)}"',
      'files_array': '[${sectionModel.files_array.map((str) => '"${getLastPartOfUrl(str)}"').join(',')}]',
      'pos_index': sectionModel.pos_index,
    };
    return map;
    }
  
  Future<String> createSection({required SectionModel sectionModel, required String module_id}) async {

    var map = createSectiontoMap(sectionModel: sectionModel, module_id: module_id);
    
    String x = '''mutation createSection {
    createSection(input: $map) {
        section_id
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
            'input': map,
          },
        )
      );
      if (result.hasException) {
        throw Exception(result.exception);
      }
      if (result.data == null || result.data?['createSection'] == null) {
        throw Exception("No Sections");
      } 
      String res = result.data?['createSection']['section_id'];
      return res;

    } catch (error) {
      throw Exception(error);
    }
  }
}