import 'package:get/get.dart';
import 'package:special_phone_book/storage/functions/functions.dart';

class HomePageController extends GetxController {
  List? data;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    data = await Storage.getContacts();
    update();
  }
}
