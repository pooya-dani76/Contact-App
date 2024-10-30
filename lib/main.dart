import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions.dart';
import 'package:special_phone_book/utils/utils.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Storage.openDB();
    await Storage.createMe();
  } catch (e) {
    Utils.logEvent(message: 'ensureInitialized Failed! -> $e', logType: LogType.error);
  }
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xffefedd4),
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super Phone Book',
      getPages: Pages.pages,
      initialRoute: Routes.homePage,
      color: const Color(0xffefedd4),
      theme: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          scaffoldBackgroundColor: const Color(0xffefedd4),
          iconTheme: const IconThemeData(color: Color(0xff78c7bc)),
          listTileTheme: const ListTileThemeData(iconColor: Color(0xff78c7bc)),
          fontFamily: "Vazir"),
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQueryData.copyWith(textScaler: const TextScaler.linear(1)),
          child: child!,
        );
      },
    );
  }
}
