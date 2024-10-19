// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:hive/hive.dart';
import 'package:special_phone_book/storage/models/models.dart';
import 'package:special_phone_book/utils/utils.dart';

enum ExistMode { name, number, none }

class Storage {
  // -----------------------------ID Generator--------------------------------
  static Future<Box> openIdGeneratorBox() async {
    Box box = await Hive.openBox('id_generator');
    return box;
  }

  static Future<void> closeIdGeneratorBox() async {
    Box box = await openIdGeneratorBox();
    await box.close();
  }

  static Future<int> generateId() async {
    Box box = await openIdGeneratorBox();
    int id = box.get('last_id') ?? 0;
    id = id + 1;
    await box.put('last_id', id);
    await closeIdGeneratorBox();
    return id;
  }

// -----------------------------MySelf---------------------------------
  static Future<bool> saveMyInfo({required Contact contact}) async {
    try {
      Box box = await Hive.openBox('my_self');
      await box.put('me', contact);
      await box.close();
      return true;
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
      return false;
    }
  }

  static Future<Contact?> getMyInfo() async {
    Box box = await Hive.openBox('my_self');
    if (box.toMap()['me'] == null) {
      await box.put('me', Contact());
    }
    Contact contact = await box.get('me');
    await box.close();
    return contact;
  }

// -----------------------------Contacts---------------------------------
  static Future<Box> openContactsBox() async {
    Box box = await Hive.openBox('Contacts');
    return box;
  }

  static Future<void> closeContactBox() async {
    Box box = await openContactsBox();
    await box.close();
  }

  static Future<List> sortContacts({required List data}) async {
    data.sort((a, b) => a.name!.compareTo(b.name!));
    return data;
  }

  static Future<Map> numbersAreExist(
      {required Contact previousContact, required Contact newContact}) async {
    for (String newNumber in newContact.numbers ?? []) {
      for (String number in previousContact.numbers!) {
        if (newNumber == number) {
          return {'status': true, 'number': number};
        }
      }
    }
    return {'status': false};
  }

  static Future<Map> checkContact({required Contact contact}) async {
    List allContacts = await getAllContacts(closeBox: false) ?? [];
    for (Contact cnt in allContacts) {
      if (cnt.name == contact.name) {
        return {'status': ExistMode.name, 'conflict': cnt.name};
      }
      Map status = await numbersAreExist(newContact: contact, previousContact: cnt);
      if (status.containsKey('number')) {
        return {'status': ExistMode.number, 'conflict': status['number']};
      }
    }
    return {'status': ExistMode.none};
  }

//----------------------------------Create--------------------------------
  static Future<bool> addContact({required Contact contact, int? id}) async {
    try {
      Box box = await openContactsBox();
      if (id == null) {
        contact.id = await generateId();
      }
      Map contactStatus = await checkContact(contact: contact);
      switch (contactStatus['status']) {
        case ExistMode.number:
          Utils.showToast(
              message: 'شماره ${contactStatus['conflict']} قبلا برای مخاطب دیگری ذخیره شده است',
              isError: true);
          return false;

        case ExistMode.name:
          Utils.showToast(message: 'مخاطبی با این نام قبلا ذخیره شده است', isError: true);
          return false;

        case ExistMode.none:
          await box.put(contact.id, contact);
          await closeContactBox();
          return true;

        default:
          return false;
      }
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
      return false;
    }
  }

  //----------------------------------Read----------------------------------
  static Future<List?> getAllContacts({bool? sort = true, bool? closeBox = true}) async {
    try {
      Box box = await openContactsBox();
      List data = box.values.toList();
      if (sort!) {
        data = await sortContacts(data: data);
      }
      if (closeBox!) {
        await closeContactBox();
      }
      return data;
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
      return null;
    }
  }

  static Future<Contact?> getContact({required int contactId}) async {
    try {
      Box box = await openContactsBox();
      Contact contact = box.get(contactId);
      await closeContactBox();
      return contact;
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
      return null;
    }
  }

  static Future<List?> searchContact({required String search}) async {
    try {
      Box box = await openContactsBox();
      List data = box.values
          .where((contact) =>
              contact.name.contains(search) ||
              contact.numbers.toList().any((String number) => number.contains(search)))
          .toList();
      data = await sortContacts(data: data);
      await closeContactBox();
      return data;
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
      return null;
    }
  }

  //--------------------------------Update----------------------------------
  static Future<bool> updateContact({required Contact contact}) async {
    try {
      Box box = await openContactsBox();
      await box.put(contact.id, contact);
      await closeContactBox();
      return true;
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
      return false;
    }
  }

  //----------------------------------Delete--------------------------------
  static Future<bool> deleteContact({required int contactId}) async {
    try {
      Box box = await openContactsBox();
      await box.delete(contactId);
      await closeContactBox();
      return true;
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
      return false;
    }
  }

  static Future<Map> getDataAsMap() async {
    Map result = {};
    Box box = await openContactsBox();
    Map data = box.toMap();
    for (var key in data.keys.toList()) {
      result[key.toString()] = data[key].toJson();
    }
    return result;
  }
}
