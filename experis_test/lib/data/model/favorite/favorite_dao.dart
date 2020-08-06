import 'package:experis_test/data/model/favorite/favorite_contract.dart';

///TO DECLARE THE TYPE OF THE VALUES INSERTED IN EACH COLUMN
class FavoriteDao {
  String get createTableQuery => "CREATE TABLE ${FavoriteContract().tableName} ("
      "${FavoriteContract.id} INTEGER PRIMARY KEY AUTOINCREMENT ,"
      "${FavoriteContract.post} TEXT"
      ")";
}
