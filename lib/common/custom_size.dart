import 'package:flutter/material.dart';

double horizontalMargin(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth >= 1200) {
    return 250.0; // Màn hình lớn (desktop)
  } else if (screenWidth >= 600) {
    return 100.0; // Tablet
  } else {
    return 0; // Mobile
  }
}

double menuFontSize(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth >= 1200) {
    return 24.0; // Màn hình lớn (desktop)
  } else if (screenWidth >= 600) {
    return 20.0; // Tablet
  } else {
    return 16.0; // Mobile
  }
}
