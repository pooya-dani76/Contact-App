// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:special_phone_book/storage/models/models.dart';
import 'package:special_phone_book/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class Storage {
  static List initScripts = [
    """CREATE TABLE IF NOT EXISTS Contacts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      pic_path TEXT NOT NULL)""",
    //----------------------------------------
    """CREATE TABLE IF NOT EXISTS Numbers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
  	  contact INTEGER NOT NULL,
  	  number TEXT NOT NULL UNIQUE,
      FOREIGN KEY (contact) REFERENCES Contacts(id))"""
  ];

  static Future<Database> openDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'contacts.db');

    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (e) {
      Utils.logEvent(message: e.toString(), logType: LogType.error);
    }

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => initScripts.forEach((element) => db.execute(element)),
    );

    return db;
  }

  static Future<bool> numberIsExist({required String number}) async {
    Database database = await openDB();
    List data = await database.query(
      'Numbers',
      where: 'number = ?',
      whereArgs: [number],
    );
    await database.close();
    return data.isNotEmpty;
  }

// ---------------------------------Create----------------------------------------
  static Future<bool> createBaseContact({required Contact contact}) async {
    Database database = await openDB();
    int response = await database.insert(
      'Contacts',
      contact.getBaseInfo(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    contact.setContactId(createdId: response);
    await database.close();
    return response != 0;
  }

  static Future<void> addContactNumbers({required Contact contact}) async {
    Database database = await openDB();
    Map info = contact.getNumberInfo();
    info['numbers'].forEach((number) async {
      try {
        await database.insert("Numbers", {
          "contact": info['contact'],
          "number": number,
        });
      } catch (e) {
        Utils.showToast(message: "Number".tr + number.toString() + "Not Added!".tr, isError: true);
      }
    });
    await database.close();
  }

static Future<int> addNewContact({required Contact contact}) async {
    // for (var element in contact.getNumberInfo()['numbers']) {
    //   bool isExist = await numberIsExist(number: element);
    //   if (isExist) {
    //     Utils.showToast(message: "Contact Saving Error!", isError: true);
    //     return -1;
    //   }
    // }
    bool isAdded = await createBaseContact(contact: contact);
    if (isAdded) {
      await addContactNumbers(contact: contact);
      return 1;
    } else {
      Utils.showToast(message: "Contact Saving Error!", isError: true);
      return -1;
    }
  }
// ---------------------------------Read------------------------------------------
  static Future<List> getContacts({String? name}) async {
    Database database = await openDB();
    List data = await database.query(
      'Contacts',
      where: name != null ? 'name = ?' : null,
      whereArgs: name != null ? [name] : null,
      orderBy: 'name',
    );
    await database.close();
    return data;
  }

// ---------------------------------Update----------------------------------------
  static Future updateContactBaseInfo({required Contact contact}) async {}

  static Future updateContactNumber() async {}

// ---------------------------------Delete----------------------------------------
  static Future deleteContact() async {}

  static Future deleteNumber() async {}
}
