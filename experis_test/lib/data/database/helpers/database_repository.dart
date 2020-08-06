import 'package:experis_test/data/database/database.dart';
import 'package:experis_test/data/database/helpers/Repository.dart';

abstract class DatabaseRepository<T> implements Repository {
  ///Method to get name of the table
  String getTableName();

  ///When executing an select all query and cast every result into the respective object
  List<T> fromList(List<Map> queries);

  ///Cast data coming from local database
  T fromMap(Map map);

  ///To save data into the database
  Map<String, dynamic> toMap(T element);

  ///Insert new data into database
  @override
  Future<int> insert(dynamic element) =>
      DatabaseHelper.db.insert(getTableName(), toMap(element));

  @override
  Future<T> getById(String id, {String columnId = "id"}) async => fromMap(
      await DatabaseHelper.db.getById(getTableName(), id, columnId: columnId));

  ///Delete registered data into database
  @override
  Future<int> delete({String id, String columnId = "id"}) =>
      DatabaseHelper.db.delete(getTableName(), id: id, columnId: columnId);

  ///Update registered data into database
  @override
  Future<int> update(dynamic element, {String id, String columnId = "id"}) =>
      DatabaseHelper.db.update(getTableName(), toMap(element),
          id: id != null ? id : element.id, columnId: columnId);

  ///Get all registered data into database
  @override
  Future<List> getAll() async =>
      fromList(await DatabaseHelper.db.getAll(getTableName()));

  ///Insert list of data into database
  @override
  Future<int> insertList(List elements) async {
    int rows = 0;
    elements.forEach((element) async {
      rows += await DatabaseHelper.db.insert(getTableName(), toMap(element));
    });

    return rows;
  }
}
