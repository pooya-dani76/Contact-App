import 'package:get/get.dart';
import 'package:special_phone_book/routes/routes.dart';

class DetailPageController extends GetxController {
  Map contactBaseInfo;
  List? numbers;

  DetailPageController({required this.contactBaseInfo});

  @override
  onInit() {
    setContactInfo();
    super.onInit();
  }

  void setContactInfo() async {
    update();
  }

  Future<void> reloadContact() async {
    setContactInfo();
  }
}

void onEditTap() {
  DetailPageController detailPageController = Get.find();
  routeToPage(page: Routes.editPage, arguments: {
    'base': detailPageController.contactBaseInfo,
    'numbers': detailPageController.numbers
  });
}
