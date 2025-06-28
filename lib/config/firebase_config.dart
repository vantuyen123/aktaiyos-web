import 'dart:io';

import 'package:aktaiyos_web_app/common/image_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';

List<String>? listAllImageFirebase;

Future<void> setupFirebase() async {
  try {
    if (kIsWeb) {
      // Chạy trên Web thì cần cấu hình FirebaseOptions
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCC6XlRzPNQCr8Qyf-q-7XrLSaMOtDj5cs",
          authDomain: "aktaiyou-web.firebaseapp.com",
          projectId: "aktaiyou-web",
          storageBucket: "aktaiyou-web.firebasestorage.app",
          messagingSenderId: "37093652987",
          appId: "1:37093652987:web:d2bda3c021f0adbeec335e",
          measurementId: "G-HX4RPTE64Q",
        ),
      );
    } else {
      // Trên mobile thì chỉ cần gọi không có options
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCC6XlRzPNQCr8Qyf-q-7XrLSaMOtDj5cs",
          authDomain: "aktaiyou-web.firebaseapp.com",
          projectId: "aktaiyou-web",
          storageBucket: "aktaiyou-web.firebasestorage.app",
          messagingSenderId: "37093652987",
          appId: "1:37093652987:web:d2bda3c021f0adbeec335e",
          measurementId: "G-HX4RPTE64Q",
        ),
      );
      listAllImageFirebase = await getAllImages();
    }
  } catch (e) {
    if (kDebugMode) {
      print('Lỗi khởi tạo Firebase: $e');
    }
  }
}

Future<Map<String, List<String>>> getAllImagesWeb() async {
  final ListResult result = await FirebaseStorage.instance.ref().listAll();
  final Map<String, List<String>> imagesMap = {};

  for (final Reference ref in result.prefixes) {
    final ListResult folderResult = await ref.listAll();
    final List<String> urls = [];
    for (final Reference fileRef in folderResult.items) {
      final String url = await fileRef.getDownloadURL();
      urls.add(url);
    }
    urls.sort((a, b) {
      final numA =
          int.tryParse(
            RegExp(
                  r'(\d+)(?=\.(jpg|png|gif|bmp|webp))',
                ).firstMatch(a)?.group(0) ??
                '0',
          ) ??
          0;
      final numB =
          int.tryParse(
            RegExp(
                  r'(\d+)(?=\.(jpg|png|gif|bmp|webp))',
                ).firstMatch(b)?.group(0) ??
                '0',
          ) ??
          0;
      return numA.compareTo(numB);
    });
    imagesMap[ref.name] = urls;
  }

  return imagesMap;
}

Future<List<String>> getAllImages() async {
  final ListResult result = await FirebaseStorage.instance.ref().listAll();
  final Map<String, List<String>> imagesMap = {};

  for (final Reference ref in result.prefixes) {
    final ListResult folderResult = await ref.listAll();
    final List<String> urls = [];
    for (final Reference fileRef in folderResult.items) {
      final String url = await fileRef.getDownloadURL();
      urls.add(url);
    }
    urls.sort((a, b) {
      final numA =
          int.tryParse(
            RegExp(
                  r'(\d+)(?=\.(jpg|png|gif|bmp|webp))',
                ).firstMatch(a)?.group(0) ??
                '0',
          ) ??
          0;
      final numB =
          int.tryParse(
            RegExp(
                  r'(\d+)(?=\.(jpg|png|gif|bmp|webp))',
                ).firstMatch(b)?.group(0) ??
                '0',
          ) ??
          0;
      return numA.compareTo(numB);
    });
    imagesMap[ref.name] = urls;
  }

  final List<String> allUrls = [];

  for (final folder in order) {
    final List<String> urls = imagesMap[folder] ?? [];

    allUrls.addAll(urls);
  }
  return allUrls;
}

// Future<void> downloadAndCacheImage(String imagePath) async {
//   final cacheManager = getCacheManager();

//   final storageRef = FirebaseStorage.instance.refFromURL(imagePath);
//   final imageUrl = await storageRef.getDownloadURL();

//   await cacheManager.downloadFile(imageUrl);
// }

Future<Uint8List> resizeImageBytes(Uint8List imageBytes) async {
  final originalImage = decodeImage(imageBytes);
  if (originalImage != null) {
    final resizedImage = copyResize(
      originalImage,
      height: 720, // Đặt chiều cao tối đa là 720p (hoặc tùy theo nhu cầu)
    );
    return Uint8List.fromList(encodePng(resizedImage));
  }
  return imageBytes; // Trả về ảnh gốc nếu resize thất bại
}

Future<void> downloadAndCacheImage(String imagePath) async {
  final cacheManager = getCacheManager();

  // Lấy tham chiếu ảnh từ Firebase Storage
  final storageRef = FirebaseStorage.instance.refFromURL(imagePath);
  final imageUrl = await storageRef.getDownloadURL();

  // Tải ảnh gốc
  final http.Response response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    // Resize ảnh
    // final resizedImageBytes = await resizeImageBytes(response.bodyBytes);
    print('1111 $response');

    // Lưu ảnh đã resize vào cache
    final filePath = await cacheManager.putFile(
      imageUrl,
      response.bodyBytes,
      // format: 'image/png', // Nếu muốn lưu ảnh với đ��nh dạng khác như PNG, thay b��ng 'image/jpeg' hoặc 'image/gif'...etc.
      // Hoặc định dạng phù hợp
    );

    print('Image cached at: $filePath');
  } else {
    print('Failed to download image: ${response.statusCode}');
  }
}

Future<List<File>> getCachedImages(List<String> listUrl) async {
  final cacheManager = getCacheManager();
  List<File> validFiles = <File>[];
  for (String item in listUrl) {
    final FileInfo? fileInfo = await cacheManager.getFileFromCache(
      item,
      // withProgress: false,
    );
    if (fileInfo != null) {
      validFiles.add(fileInfo.file);
    }
  }
  return validFiles;
}

CacheManager getCacheManager() {
  return CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );
}
