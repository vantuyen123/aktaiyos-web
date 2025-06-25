import 'package:flutter/material.dart';

void pushUntil(
  String routeName, {
  required BuildContext context,
  Map<String, String> pathParameters = const <String, String>{},
  Map<String, dynamic> queryParameters = const <String, dynamic>{},
  Object? extra,
}) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    routeName,
    (Route<dynamic> route) => false,
  );
}
