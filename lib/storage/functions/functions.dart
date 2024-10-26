import 'dart:io';
import 'package:path/path.dart';
import 'package:special_phone_book/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class Storage {
  //----------------------------------------Scripts----------------------------------------
  static List initScripts = [
    '''
CREATE TABLE IF NOT EXISTS Contacts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      picture_path TEXT,
      is_me INTEGER)
    ''',
    '''
CREATE TABLE IF NOT EXISTS Numbers(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
  	  contact_id INTEGER NOT NULL,
      country_code TEXT NOT NULL,
      country_symbol TEXT NOT NULL,
  	  number TEXT NOT NULL UNIQUE,
      FOREIGN KEY (contact_id) REFERENCES Contacts(id))
    ''',
    '''
CREATE TABLE IF NOT EXISTS Emails(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
  	  contact_id INTEGER NOT NULL,
  	  email TEXT,
      FOREIGN KEY (contact_id) REFERENCES Contacts(id))
    ''',
    '''
 CREATE TABLE IF NOT EXISTS Addresses(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
  	  contact_id INTEGER NOT NULL,
  	  latitude REAL,
      longitude REAL,
      FOREIGN KEY (contact_id) REFERENCES Contacts(id));   
    '''
  ];
  static List migrationScripts = [];

  //----------------------------------------Create-----------------------------------------
  static Future<Database> openDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'contacts_special.db');

    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (e) {
      Utils.logEvent(message: 'Create Database Failed! -> $e ', logType: LogType.error);
    }

    Database db = await openDatabase(
      path,
      version: migrationScripts.length + 1,
      onCreate: (db, version) async {
        for (var element in initScripts) {
          await db.execute(element);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (var i = oldVersion - 1; i < newVersion - 1; i++) {
          try {
            await db.execute(migrationScripts[i]);
          } catch (e) {
            Utils.logEvent(message: 'Migration Failed! -> $e ', logType: LogType.error);
          }
        }
      },
    );
    return db;
  }
  //----------------------------------------Read-------------------------------------------

  static Future<List?> getAllContacts() async {
    Database database = await openDB();
    try {
      List<Map> data = await database.query(
        'Contacts',
        orderBy: 'name',
        where: 'is_me != ?',
        whereArgs: [1],
      );
      await database.close();
      return data;
    } catch (e) {
      Utils.logEvent(message: 'Load All Contatcts Failed! -> $e ', logType: LogType.error);
      await database.close();
      return null;
    }
  }

  static Future<Map?> getMyInfo() async {
    Database database = await openDB();
    try {
      List<Map> data = await database.query(
        'Contacts',
        orderBy: 'name',
        where: 'is_me = ?',
        whereArgs: [1],
      );
      await database.close();
      return data.isNotEmpty ? data[0] : {};
    } catch (e) {
      Utils.logEvent(message: 'Load My Info Failed! -> $e ', logType: LogType.error);
      await database.close();
      return null;
    }
  }

  static Future<Map?> getContactInfo({required int contactId}) async {
    Database database = await openDB();
    Batch batch = database.batch();
    batch.query('Contacts', where: 'id = ?', whereArgs: [contactId]);
    batch.query('Numbers', where: 'contact_id = ?', whereArgs: [contactId]);
    batch.query('Emails', where: 'contact_id = ?', whereArgs: [contactId]);
    batch.query('Addresses', where: 'contact_id = ?', whereArgs: [contactId]);
    try {
      List data = await batch.commit();
      await database.close();
      return {'base': data[0][0], 'numbers': data[1], 'emails': data[2], 'addresses': data[3]};
    } catch (e) {
      Utils.logEvent(message: 'Load Contact Failed! -> $e ', logType: LogType.error);
      await database.close();
      return null;
    }
  }

  static Future<List?> searchContact({required String search}) async {
    Database database = await openDB();
    try {
      List<Map> data = await database.query(
        'Contacts',
        orderBy: 'name',
        where: 'is_me = ? AND name LIKE ?',
        whereArgs: [0, "%$search%"],
      );
      await database.close();
      return data;
    } catch (e) {
      Utils.logEvent(message: 'Load All Contatcts Failed! -> $e ', logType: LogType.error);
      await database.close();
      return null;
    }
  }

  //----------------------------------------Add--------------------------------------------
  /// contactData = {
  /// 'base': {'name':str , 'picture_path':str, 'is_me':int<0,1>},
  ///
  /// 'numbers': list<{'country_code': str, 'number': str, 'country_symbol':str}>,
  ///
  /// 'emails': list<String>,
  ///
  /// 'addresses' : list<{'latitude':..., 'longitude':...}>,
  /// }
  static Future<void> addContact({required Map contactData}) async {
    Database database = await openDB();
    Batch batch = database.batch();
    int createdId = await database.insert('Contacts', contactData['base']);

    for (var number in contactData['numbers']) {
      batch.insert('Numbers', {
        'contact_id': createdId,
        'country_code': number['country_code'],
        'country_symbol': number['country_symbol'],
        'number': number['number']
      });
    }

    for (var email in contactData['emails']) {
      batch.insert('Emails', {
        'contact_id': createdId,
        'email': email,
      });
    }

    for (var address in contactData['addresses']) {
      batch.insert('Addresses', {
        'contact_id': createdId,
        'latitude': address['latitude'],
        'longitude': address['longitude'],
      });
    }
    await batch.commit();
    await database.close();
  }

  //----------------------------------------Update-----------------------------------------
  static Future<void> updateContact({required Map contactData}) async {
  }

  //----------------------------------------Delete-----------------------------------------

  static Future<bool> deleteContact({required int contactId}) async {
    Database database = await openDB();
    Batch batch = database.batch();
    batch.delete('Contacts', where: 'id = ?', whereArgs: [contactId]);
    batch.delete('Numbers', where: 'contact_id = ?', whereArgs: [contactId]);
    batch.delete('Emails', where: 'contact_id = ?', whereArgs: [contactId]);
    batch.delete('Addresses', where: 'contact_id = ?', whereArgs: [contactId]);
    try {
      await batch.commit(continueOnError: false);
      await database.close();
      return true;
    } catch (e) {
      Utils.logEvent(message: 'Load Contact Failed! -> $e ', logType: LogType.error);
      await database.close();
      return false;
    }
  }
  //----------------------------------------Aux Functions----------------------------------
}
