import 'dart:typed_data';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

/// Dealing with platform specific API to work with images
class ImageService implements IImageService {
  final albumName = "ThePhotobooth";
  /// Tries to return image as bytes array from OS gallery
  Future<Uint8List> getImageFromGallery() async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      return await image.readAsBytes();
    } catch (e) {
      print(e);
      return null;
    }
  }
  /// Tries to return image as bytes array from OS camera
  Future<Uint8List> getImageFromCamera() async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      return await image.readAsBytes();
    } catch (e) {
      print(e);
      return null;
    }
  }
  /// Tries to save an image to ThePhotobooth album in the gallery
  /// 
  /// [path] - path to the image in app directory
  Future<bool> saveImageInGallery(String path) async {
    try {
      return await GallerySaver.saveImage(path, albumName: albumName);
    } catch (e) {
      print(e);
      return false;
    }
  }
}

abstract class IImageService {
  Future<Uint8List> getImageFromGallery();
  Future<Uint8List> getImageFromCamera();
  Future<bool> saveImageInGallery(String path);
}