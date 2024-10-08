import 'package:get/get.dart';
import 'package:special_phone_book/storage/functions/functions.dart';

class DetailPageController extends GetxController {
  final Map contactBaseInfo;
  List? numbers;

  DetailPageController({required this.contactBaseInfo});

  @override
  onInit() {
    setContactInfo();
    super.onInit();
  }

  setContactInfo() async {
    numbers = await Storage.getContactNumberInfo(contactId: contactBaseInfo['id']);
    update();
  }
}
