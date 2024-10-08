import 'package:get/get.dart';
import 'package:special_phone_book/pages/detail_page/view/detail_page_view.dart';
import 'package:special_phone_book/pages/edit_page/view/edit_page_view.dart';
import 'package:special_phone_book/pages/home_page/controller/home_page_controller.dart';
import 'package:special_phone_book/pages/home_page/view/home_page.dart';

class Routes {
  static String homePage = '/home';
  static String detailPage = '/detail';
  static String editPage = '/edit';
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
      page: () => DetailPage(),
    ),
    GetPage(
      name: Routes.editPage,
      page: () => EditPage(),
    ),
  ];
}

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomePageController());
  }
}

// class DetailPageBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(DetailPageController());
//   }
// }

void routeToPage({required String page, Map? arguments}) async {
  await Get.toNamed(page, arguments: arguments);
}
