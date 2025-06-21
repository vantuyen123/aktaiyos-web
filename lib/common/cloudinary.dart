import 'package:cloudinary_flutter/cloudinary_object.dart';

class CloudinaryService {
  // Singleton instance
  static final CloudinaryService _instance = CloudinaryService._internal();

  // Private constructor
  CloudinaryService._internal();

  // Factory để trả về instance duy nhất
  factory CloudinaryService() {
    return _instance;
  }

  late final CloudinaryObject cloudinary;

  void init({required String cloudName}) {
    cloudinary = CloudinaryObject.fromCloudName(cloudName: cloudName);
  }
}