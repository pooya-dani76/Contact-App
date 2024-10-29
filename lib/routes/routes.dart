import 'package:get/get.dart';
import 'package:special_phone_book/pages/detail_page/view/detail_page_view.dart';
import 'package:special_phone_book/pages/edit_page/view/edit_page_view.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/pages/home_page/view/home_page.dart';
import 'package:special_phone_book/pages/map_page/view/map_page.dart';
import 'package:special_phone_book/pages/setting_page/controller/setting_page_controller.dart';
import 'package:special_phone_book/pages/setting_page/view/setting_page_view.dart';

class Routes {
  static String homePage = '/home';
  static String detailPage = '/detail';
  static String editPage = '/edit';
  static String settingPage = '/setting';
  static String mapPage = '/map';
}

class Pages {
  static List<GetPage> pages = [
    GetPage(
      name: Routes.homePage,
      page: () => const HomePage(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: Routes.detailPage,
      page: () => const DetailPage(),
    ),
    GetPage(
      name: Routes.editPage,
      page: () => const EditPage(),
    ),
    GetPage(
        name: Routes.settingPage, page: () => const SettingPage(), binding: SettingPageBinding()),
    GetPage(
      name: Routes.mapPage,
      page: () => const MapPage(),
    ),
  ];
}

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomePageController());
  }
}

class SettingPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingPageController());
  }
}

void routeToPage({required String page, Map? arguments, bool? clearPreviousPages = false}) async {
  if (clearPreviousPages!) {
    await Get.offAllNamed(page, arguments: arguments);
  } else {
    await Get.toNamed(page, arguments: arguments);
  }
}
