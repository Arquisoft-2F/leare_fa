import 'package:image_picker/image_picker.dart';
import 'package:leare_fa/models/image_model.dart';

Future<ImageModel> pickImage({required ImageSource source}) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);
  if (image == null) {
    return ImageModel(file: '');
  }
  ImageModel imageModel = ImageModel(file: image!.path);
  imageModel.base64 = await image.readAsBytes();
  return imageModel;
}