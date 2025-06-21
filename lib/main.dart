import 'package:aktaiyos_web_app/common/cloudinary.dart';
import 'package:aktaiyos_web_app/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  CloudinaryService().init(cloudName: 'dxqv6lywg');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aktaiyou Sushi',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
