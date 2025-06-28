import 'package:aktaiyos_web_app/common/router_constants.dart';
import 'package:aktaiyos_web_app/pages/home_mobile.dart';
import 'package:aktaiyos_web_app/pages/home_web.dart';
import 'package:aktaiyos_web_app/pages/splash/splash_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting) => {
    RouterConstants.initial: (context) =>
        kIsWeb ? const HomePageWeb() : const SplashPage(),
    RouterConstants.home: (context) => const HomePageMobile(),
  };
}
