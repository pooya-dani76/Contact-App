// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:hive/hive.dart';
import 'package:special_phone_book/storage/models/models.dart';
import 'package:special_phone_book/utils/utils.dart';

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

//----------------------------------Create--------------------------------
  static Future<bool> addContact({required Contact contact}) async {
    try {
      Box box = await openContactsBox();
      contact.id = await generateId();
      await box.put(contact.id, contact);
      await closeContactBox();
      return true;
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
      return false;
    }
  }

  //----------------------------------Read----------------------------------
  static Future<List?> getAllContacts() async {
    try {
      Box box = await openContactsBox();
      List data = box.values.toList();
      data = await sortContacts(data: data);
      await closeContactBox();
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
}
