import 'package:sqflite/sqflite.dart';
import 'package:agenda_app/model/Contato.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';



class ContatoHelper{

  static ContatoHelper _databaseHelper;
  static Database _database;

  String contatoTable = "contato";
  String colId        = "id";
  String colNome      = "nome";
  String colEmail     = "email";
  String colTel       = "telefone";
  String colImg       = "imagem";


  ContatoHelper._createInstance();

  factory ContatoHelper() {
    if (_databaseHelper == null) _databaseHelper = ContatoHelper._createInstance();

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
    final String path = directory.path + 'contatoDB.db';

    var contatoDB = await openDatabase(path, version: 1, onCreate: _createDB);
    return contatoDB;
  }

  void _createDB(Database db, int version) async {
    String sql = "CREATE TABLE $contatoTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colNome TEXT, $colEmail TEXT, $colTel TEXT, $colImg TEXT)";

    await db.execute(sql);
  }

  Future<Contato> insert(Contato contato) async {
    Database db = await this.database;

     contato.id = await db.insert(contatoTable, contato.toMap()); //ele retorna o id

    return contato;
  }


  Future<List<Contato>> getContatos() async {
    Database db = await this.database;
    var resultado = await db.query(contatoTable);

     return resultado.isNotEmpty ? resultado.map((contato) => Contato.fromMap(contato)).toList() : [];
  }

  Future<Contato> getContatoBy(int id) async {
    Database db = await this.database;
   List<Map> resultado = await db.query(contatoTable,
       columns: [colId, colNome, colEmail, colImg],
       where: "$colId = ?",
       whereArgs: [id]);

   return (resultado.length > 0) ?  Contato.fromMap(resultado.first) : null;

  }

  Future<int>deleteContato(int id) async{
    Database db = await this.database;
    return await db.delete(contatoTable,
        where:"$colId = ?",
        whereArgs: [id]);
  }

  Future<int>updateContato(Contato contato) async{
    Database db = await this.database;
   return  await db.update(contatoTable,
       contato.toMap(),
       where:'$colId = ?',
       whereArgs: [contato.id] );

  }

  Future<int>getCountContatos() async{
    Database db = await this.database;
    return Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $contatoTable"));
  }

  Future close() async {
    Database db = await this.database;
    db.close();
  }

}