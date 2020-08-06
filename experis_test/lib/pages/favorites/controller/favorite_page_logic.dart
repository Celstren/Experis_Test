import 'package:experis_test/data/model/favorite/favorite_reporsitory.dart';
import 'package:experis_test/pages/favorites/controller/favorite_page_controller.dart';

class FavoritePageLogic {
  static void get getAllFavorites async => FavoritePageController().updateFavorites(await FavoriteRepository().getAll());
}