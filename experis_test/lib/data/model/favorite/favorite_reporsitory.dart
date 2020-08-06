import 'dart:convert';

import 'package:experis_test/data/database/helpers/database_repository.dart';
import 'package:experis_test/data/model/favorite/favorite_contract.dart';
import 'package:experis_test/data/model/favorite/favorite_model.dart';
import 'package:experis_test/data/model/post/post_model.dart';

class FavoriteRepository extends DatabaseRepository<FavoriteModel> {
  @override
  String getTableName() => FavoriteContract().tableName;

  ///When executing an select all query and cast every result into the respective object
  @override
  List<FavoriteModel> fromList(List<Map> queries) =>
      queries.map((query) => fromMap(query)).toList();

  ///Cast data coming from local database
  @override
  FavoriteModel fromMap(Map map) {
    FavoriteModel favorite = new FavoriteModel();
    favorite.id = map[FavoriteContract.id];
    favorite.post = map[FavoriteContract.post] != null
        ? PostModel.fromJson(jsonDecode(map[FavoriteContract.post]))
        : null;
    return favorite;
  }

  ///To save data into the database
  @override
  Map<String, dynamic> toMap(FavoriteModel element) => {FavoriteContract.post: jsonEncode(element.post)};
}
