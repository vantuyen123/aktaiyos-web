import 'package:aktaiyos_web_app/common/fade_page_route_builder.dart';
import 'package:aktaiyos_web_app/common/router_constants.dart';
import 'package:aktaiyos_web_app/config/firebase_config.dart';
import 'package:aktaiyos_web_app/config/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await setupFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aktaiyou Sushi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: RouterConstants.initial,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        final routes = Routes.getRoutes(settings);
        final WidgetBuilder? builder = routes[settings.name];
        return FadePageRouteBuilder(builder: builder!, settings: settings);
      },
    );
  }
}
