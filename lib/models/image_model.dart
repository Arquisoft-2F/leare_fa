import 'dart:typed_data';

class ImageModel {
  String file;
  Uint8List? base64;

  ImageModel({required this.file, this.base64});
}