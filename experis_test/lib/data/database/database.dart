import 'package:experis_test/data/database/helpers/database_constants.dart';
import 'package:experis_test/data/model/favorite/favorite_dao.dart';
import 'package:experis_test/data/model/favorite/favorite_reporsitory.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database _database;

  ///Declaring instance of DatabaseHelper
  static final DatabaseHelper db = DatabaseHelper._();

  ///Private constructor to create a new instance of DatabaseHelper
  DatabaseHelper._();

  ///Getter of current Database
  ///If Database is already created return same database
  ///If Database is not created already, initDB is executed
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  ///If Database file is already created it gets the file created and open it
  ///If Database file is not created it creates a new file into the device's directory
  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, DatabaseConstants.DATABASE_NAME);
    return await openDatabase(path, version: DatabaseConstants.DATABASE_VERSION,
        onCreate: (Database _db, int version) async {
      ///This section is executed when database is open for the first time
      ///Add all initial tables from database here
      ///Where can I add new tables when database is initialized?
      await _db.transaction((Transaction txn) async {
        try {
          txn.execute(FavoriteDao().createTableQuery);
        } catch (e) {
          print("Error while creating tables: $e");
        }
      });
    });
  }

  ///Closing Database
  static void closeDB() async {
    ///How and where database is closed?
    _database.close();
  }

  ///Deleting Database
  void deleteDB() async {
    ///Where and when database and its data is deleted
    final _db = await database;

    if (_db != null && _db.isOpen) {
      await _db.transaction((Transaction txn) async {
        try {
          await txn.execute("DELETE FROM ${FavoriteRepository().getTableName()}");
        } catch (e) {
          print("Error while deleting data from tables: $e");
        }
      });
    }
  }

  ///Insert into database function
  Future<int> insert(String tableName, Map<String, dynamic> values) async {
    ///Gets database instance
    final _db = await database;
    int res = 0;
    if (_db != null && _db.isOpen) {
      try {
        ///Insert values into table
        ///ConflictAlgorithm allows to replace the data if there is any conflict with any already saved
        res = await _db.insert(tableName, values,
            conflictAlgorithm: ConflictAlgorithm.replace);
      } catch (e) {
        print("Error while inserting new element to database: $e");
      }
    }
    return res;
  }

  ///Deleting values from database function
  Future<int> delete(String tableName,
      {dynamic id, String columnId = "id"}) async {
    ///Gets database instance
    final _db = await database;
    int res = 0;
    if (_db != null && _db.isOpen) {
      try {
        ///Delete value where the "id" is same as the parameter send
        ///Name of the column can be modified if it has another name just call delete("table_name", id, columnId: "column_id_name")
        res = await _db
            .delete(tableName, where: '$columnId = ?', whereArgs: [id]);
      } catch (e) {
        print("Error while deleting element from database: $e");
      }
    }
    return res;
  }

  ///Updating values from database function
  Future<int> update(String tableName, dynamic element,
      {dynamic id, String columnId = "id"}) async {
    final _db = await database;
    int res = 0;
    if (_db != null && _db.isOpen) {
      try {
        res = await _db.update(tableName, element,
            where: '$columnId = ?', whereArgs: [id]);
      } catch (e) {
        print("Error while updating element from database: $e");
      }
    }
    return res;
  }

  ///Getting one record from database function
  Future<dynamic> getById(String tableName, dynamic id,
      {String columnId = "id"}) async {
    final _db = await database;
    dynamic res;
    if (_db != null && _db.isOpen) {
      try {
        res =
            await _db.query(tableName, where: '$columnId = ?', whereArgs: [id]);
      } catch (e) {
        print("Error while getting one element from database: $e");
      }
    }
    return res != null && res.isNotEmpty ? res.first : null;
  }

  ///Getting all records from database function
  Future<dynamic> getAll(String tableName) async {
    final _db = await database;
    dynamic res;
    if (_db != null && _db.isOpen) {
      try {
        res = await _db.query(tableName);
      } catch (e) {
        print("Error while getting all element from database: $e");
      }
    }
    return res;
  }
}
