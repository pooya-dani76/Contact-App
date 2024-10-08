import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
import 'package:special_phone_book/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Storage.openDB();
    await Hive.initFlutter();
  } catch (e) {
    Utils.logEvent(message: e.toString(), logType: LogType.error);
  }
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
          title: 'Contacts',
          getPages: Pages.pages,
          initialRoute: Routes.homePage,
          theme: ThemeData.dark(),
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: MediaQuery(
                data: mediaQueryData.copyWith(textScaler: const TextScaler.linear(1)),
                child: child!,
              ),
            );
          },
        );
  }
}
