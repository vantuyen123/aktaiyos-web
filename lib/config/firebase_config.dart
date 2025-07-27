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
    if (!kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAqybnp8IpIR8BhIpqYE1kG8ElGSojHdaQ",
          authDomain: "aktaiyo-sushi.firebaseapp.com",
          projectId: "aktaiyo-sushi",
          storageBucket: "aktaiyo-sushi.firebasestorage.app",
          messagingSenderId: "633349712568",
          appId: "1:633349712568:web:abf3de4f4288f07b6a624d",
          measurementId: "G-ZQ3N3JB8L3",
        ),
      );
      listAllImageFirebase = await getAllImages();
    } else {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDxLzhBrR-abmAaqKxgjxigkWlT4S7rviA",
          authDomain: "akataiyo-web.firebaseapp.com",
          projectId: "akataiyo-web",
          storageBucket: "akataiyo-web.firebasestorage.app",
          messagingSenderId: "973302100618",
          appId: "1:973302100618:web:d40d99fe8ef86335c07373",
        ),
      );
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

    // Tải URL song song thay vì tuần tự
    final List<String> urls = await Future.wait(
      folderResult.items.map((fileRef) => fileRef.getDownloadURL()),
    );

    // Sắp xếp theo số trong tên file (nếu có)
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
    if (ref.name == 'set-lunch') continue;
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
    final filePath = await cacheManager.putFile(imageUrl, response.bodyBytes);

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
