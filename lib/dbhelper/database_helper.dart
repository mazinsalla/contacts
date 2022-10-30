import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/note_model.dart';
import 'constant.dart';

class DataBaseHelper {
  Database? db;

  Future open() async {
    String path = join(await getDatabasesPath(),
        "contacts.db"); // path to store your table,contact is name of the table

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // version is used when you want to add updates to table (increment it to update its version)
        //on create is called first time only as long as you are in the same version
        await db.execute('''  
      CREATE TABLE $tableContact (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnName TEXT NOT NULL,
      $columnPhone TEXT NOT NULL,
      $columnEmail TEXT NOT NULL)     
     ''');
      },
    );
  }

  //CURD

  //CREATE:insert
  Future insertContact(ContactModel contactModel) async {
    await open();
    return await db!.insert(tableContact, contactModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm
            .replace); // conflict algo: if old value exists replace it
  }

  //update
  Future updateContact(ContactModel contactModel) async {
    await open();
    return await db!.update(tableContact, contactModel.toMap(),
        where: '$columnId=?',
        whereArgs: [
          contactModel.id
        ]); //instead of columnId=note.id for db security
  }

  //READ
  Future<List<ContactModel>> getAllContact() async {
    await open();
    List<Map<String, dynamic>> maps = await db!.query(tableContact);
    return maps.isNotEmpty
        ? maps.map((e) => ContactModel.fromMap(e)).toList()
        : [];
  }

  //delete
  Future deleteContact(int index) async {
    await open();
    return await db!.delete(tableContact, where: '$columnId=?', whereArgs: [
      index
    ]); // index for list.builder(where the user tapped or swiped)
  }
}
