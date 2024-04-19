import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> uploadFile({required File file, required String file_name, required String data_type, required String user_id, required String token}) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://35.215.20.21:8001/documents/upload'),
      );
      request.fields['file_name'] = file_name;
      request.fields['data_type'] = data_type;
      request.fields['user_id'] = user_id;

      // Add file to multipart
      var multipartFile = http.MultipartFile.fromBytes('content', file.readAsBytesSync(),
          filename: file_name);
      
      request.files.add(multipartFile);
      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonData = json.decode(responseBody);

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Error uploading file: ${response.reasonPhrase}');
      }
      var fileId = jsonData['file_id'];
      return fileId.toString();

    } catch (e) {
      print('Error: $e');
      return '';
    }
  }