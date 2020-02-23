import 'package:sqflite/sqflite.dart';
import 'package:agenda_app/model/Contact.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class ContactHelper {
  static ContactHelper _databaseHelper;
  static Database _database;

  String contactTable = "contact";
  String colId = "id";
  String colName = "name";
  String colEmail = "email";
  String colPhone = "phone";
  String colImg = "image";

  ContactHelper._createInstance();

  factory ContactHelper() {
    if (_databaseHelper == null)
      _databaseHelper = ContactHelper._createInstance();

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path + 'contactDb.db';

    var contactDB = await openDatabase(path, version: 1, onCreate: _createDB);
    return contactDB;
  }

  void _createDB(Database db, int version) async {
    String sql =
        "CREATE TABLE $contactTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colEmail TEXT, $colPhone TEXT, $colImg TEXT)";

    await db.execute(sql);
  }

  Future<Contact> insert(Contact contact) async {
    Database db = await this.database;

    contact.id = await db.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<List<Contact>> getContacts() async {
    Database db = await this.database;
    var result = await db.query(contactTable);

    return result.isNotEmpty
        ? result.map((contact) => Contact.fromMap(contact)).toList()
        : [];
  }

  Future<Contact> getContactBy(int id) async {
    Database db = await this.database;
    List<Map> result = await db.query(contactTable,
        columns: [colId, colName, colEmail, colImg],
        where: "$colId = ?",
        whereArgs: [id]);

    return (result.length > 0) ? Contact.fromMap(result.first) : null;
  }

  Future<int> delete(int id) async {
    Database db = await this.database;
    return await db.delete(contactTable, where: "$colId = ?", whereArgs: [id]);
  }

  Future<int> update(Contact contact) async {
    Database db = await this.database;
    return await db.update(contactTable, contact.toMap(),
        where: '$colId = ?', whereArgs: [contact.id]);
  }

  Future<int> getCountContacts() async {
    Database db = await this.database;
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
