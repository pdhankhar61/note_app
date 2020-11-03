import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/models/noteDb.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
//singleton

  static DatabaseHelper _databaseHelper;
  static Database _database;
  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initialzeDatabase();
    }
    return _database;
  }

  Future<Database> initialzeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    //open or create the database at a given PATH
    var notesDatabse =
        await openDatabase(path, version: 1, onCreate: _createdb);
    return notesDatabse;
  }

  void _createdb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,$colDescription TEXT,$colPriority INTEGER,$colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getnotemaplist() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertNote(NoteDb noteDb) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, noteDb.toMap());
    return result;
  }

  Future<int> updateNote(NoteDb noteDb) async {
    Database db = await this.database;
    var result = await db.update(noteTable, noteDb.toMap(),
        where: "$colId=?", whereArgs: [noteDb.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId=$id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    return Sqflite.firstIntValue(x);
  }

Future<List<NoteDb>> getNoteList() async{
  var noteMapList= await getnotemaplist();
int count=noteMapList.length;
List<NoteDb> noteList=[];
for(int i=0;i<count;i++){
  noteList.add(NoteDb.fromMap(noteMapList[i]));

}
return noteList;
}
}
