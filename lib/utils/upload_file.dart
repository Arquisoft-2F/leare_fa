import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

// Future<List<String>> uploadFiles({
//   required List<Uint8List> files,
//   required List<String> file_names,
//   required String data_type,
//   required String user_id,
//   required String token,
// }) async {
//   List<String> uploadedFileIds = [];

//   try {
//     for (int i = 0; i < files.length; i++) {
//       var fileId = await uploadFile(
//         file: files[i],
//         file_name: file_names[i],
//         data_type: data_type,
//         user_id: user_id,
//         token: token,
//       );
//       uploadedFileIds.add(fileId);
//     }
//   } catch (e) {
//     print('Error: $e');
//   }

//   return uploadedFileIds;
// }

Future<String> uploadFile({
  required Uint8List file,
  required String file_name,
  required String data_type,
  required String user_id,
  required String token,
}) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://35.215.3.194/documents/upload'),
    );

    request.fields['file_name'] = file_name;
    request.fields['data_type'] = data_type;
    request.fields['user_id'] = user_id;

    var multipartFile =
        http.MultipartFile.fromBytes('content', file, filename: file_name);
    request.files.add(multipartFile);

    request.headers['Authorization'] = 'Bearer $token';

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('File uploaded successfully');
      var jsonData = json.decode(responseBody);
      var fileId = jsonData['file_id'];
      return fileId.toString();
    } else {
      print('Error uploading file: ${response.reasonPhrase}');
      return '';
    }
  } catch (e) {
    print('Error: $e');
    return '';
  }
}
