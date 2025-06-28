// ignore_for_file: use_build_context_synchronously

import 'package:aktaiyos_web_app/common/app_path.dart';
import 'package:aktaiyos_web_app/common/app_toast.dart';
import 'package:aktaiyos_web_app/common/router_constants.dart';
import 'package:aktaiyos_web_app/config/firebase_config.dart';
import 'package:aktaiyos_web_app/helper/navigator_functions.dart';
import 'package:aktaiyos_web_app/singletons/connection_status_singleton.dart';
import 'package:aktaiyos_web_app/singletons/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    await connectionStatus.initialize();
    await sharedPreferences.init();
    String? firstOpenApp = sharedPreferences.get(fistOpenApp);
    print(firstOpenApp);
    if (firstOpenApp == null) {
      print(11111);
      showSuccess(
        message: 'Hệ thống đang tải dữ liệu vui lòng đợi trong giây lát',
      );
      await setupFirebase();
      if (listAllImageFirebase != null) {
        for (String imgLink in listAllImageFirebase!) {
          await downloadAndCacheImage(imgLink);
        }
      }
      await sharedPreferences.save(fistOpenApp, '1');
      await sharedPreferences.saveListString(listUrl, listAllImageFirebase);
    } else {
      listAllImageFirebase = sharedPreferences.getListString(listUrl);
      Future.delayed(const Duration(seconds: 3));
    }

    pushUntil(RouterConstants.home, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppPath.background),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: const SizedBox(
          height: 200,
          width: 200,
          // padding: const EdgeInsets.symmetric(horizontal: 50),
          child: CircleAvatar(backgroundImage: AssetImage(AppPath.logo)),
        ),
      ),
    );
  }
}
