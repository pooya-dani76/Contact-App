// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
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
    for (var number in info['numbers']) {
      try {
        await database.insert("Numbers", {
          "contact": info['contact'],
          "number": number,
        });
      } catch (e) {
        Utils.showToast(message: "شماره $number از قبل موجود است", isError: true);
      }
    }
    await database.close();
  }

// ---------------------------------Read------------------------------------------
  static Future<List> getContacts() async {
    Database database = await openDB();
    List data = await database.query(
      'Contacts',
      orderBy: 'name',
    );
    await database.close();
    return data;
  }

  static Future<Map> getContactBaseInfo({required int contactId}) async {
    Database database = await openDB();
    List data = await database.query('Contacts', where: 'id = ?', whereArgs: [contactId]);
    await database.close();
    return data[0];
  }

  static Future getContactNumberInfo({required int contactId}) async {
    Database database = await openDB();
    List data = await database.query('Numbers', where: 'contact = ?', whereArgs: [contactId]);
    await database.close();
    return data;
  }

  static Future searchContact({required String searchText}) async {
    Database database = await openDB();
    List data =
        await database.rawQuery('''SELECT * FROM Contacts WHERE name LIKE "%$searchText%"''');
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
