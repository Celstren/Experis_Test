import 'package:experis_test/data/model/favorite/favorite_model.dart';
import 'package:rxdart/rxdart.dart';

class FavoritePageController {
  static FavoritePageController _instance;

  BehaviorSubject<List<FavoriteModel>> _favoritesStream;

  FavoritePageController._(){
    this._favoritesStream = new BehaviorSubject.seeded([]);
  }

  factory FavoritePageController() => _getInstance();

  static FavoritePageController _getInstance() {
    if (_instance == null) {
      _instance = FavoritePageController._();
    }
    return _instance;
  }

  /// POSTS STREAM METHODS
  Stream<List<FavoriteModel>> getFavoritesEvents() => _favoritesStream.stream;

  List<FavoriteModel> getFavoritesValue() => _favoritesStream.value;

  void updateFavorites(List<FavoriteModel> data) => _favoritesStream.add(data);
}