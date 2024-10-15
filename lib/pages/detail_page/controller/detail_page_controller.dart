import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:special_phone_book/routes/routes.dart';
import 'package:special_phone_book/storage/functions/functions.dart';
import 'package:special_phone_book/storage/models/models.dart';
import 'package:special_phone_book/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailPageController extends GetxController {
  Map? contactId;
  Contact? contact;

  DetailPageController({required this.contactId});

  @override
  onInit() {
    getContactInfo();
    super.onInit();
  }

  Future<void> getContactInfo() async {
    contact = await Storage.getContact(contactId: contactId!['id']);
    update();
  }
}

void onEditTap() {
  DetailPageController detailPageController = Get.find();
  routeToPage(
    page: Routes.editPage,
    arguments: {'contact': detailPageController.contact},
  );
}

Future<void> onBubbleMessageTap({required String number}) async {
  try {
    await launchUrlString("sms:$number");
  } catch (e) {
    Utils.logEvent(message: 'Can Send SMS to $number', logType: LogType.error);
  }
}

Future<void> onPhoneTap({required String number}) async {
  try {
    await FlutterPhoneDirectCaller.callNumber(number);
  } catch (e) {
    Utils.logEvent(message: 'Can Make Call to $number', logType: LogType.error);
  }
  
}
