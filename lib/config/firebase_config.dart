import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

Future<void> setupFirebase() async {
  try {
    if (kIsWeb) {
      // Chạy trên Web thì cần cấu hình FirebaseOptions
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDiQM7AFOsSupY9wPkp8nQg9Eo7QT-xSCU",
          authDomain: "akataiyoss-fca1d.firebaseapp.com",
          projectId: "akataiyoss-fca1d",
          storageBucket: "akataiyoss-fca1d.firebasestorage.app",
          messagingSenderId: "361036728515",
          appId: "1:361036728515:web:3389cb8a85ae8bd0c33a76",
          measurementId: "G-84QF8924GP",
        ),
      );
    } else {
      // Trên mobile thì chỉ cần gọi không có options
      await Firebase.initializeApp();
    }
  } catch (e) {
    if (kDebugMode) {
      print('Lỗi khởi tạo Firebase: $e');
    }
  }
}

Future<Map<String, List<String>>> getAllImages() async {
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
