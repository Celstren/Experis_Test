import 'package:experis_test/data/model/favorite/favorite_model.dart';
import 'package:experis_test/data/model/post/post_model.dart';
import 'package:experis_test/pages/favorites/controller/favorite_page_controller.dart';
import 'package:rxdart/rxdart.dart';

class PostPageController {
  static PostPageController _instance;

  BehaviorSubject<List<PostModel>> _postsStream;
  
  Stream<List<Map<String, dynamic>>> get postsData => Rx.combineLatest2(getPostsEvents(), FavoritePageController().getFavoritesEvents(), 
  (List<PostModel> a, List<FavoriteModel> b) {
    List<Map<String, dynamic>> data = [];
    a.forEach((post) {
      data.add({
        "post": post,
        "favoriteId": b.firstWhere((element) => element.post.id == post.id, orElse: () => null)?.id,
      });
    });
    return data;
  });

  PostPageController._(){
    this._postsStream = new BehaviorSubject.seeded([]);
  }

  factory PostPageController() => _getInstance();

  static PostPageController _getInstance() {
    if (_instance == null) {
      _instance = PostPageController._();
    }
    return _instance;
  }

  /// POSTS STREAM METHODS
  Stream<List<PostModel>> getPostsEvents() => _postsStream.stream;

  List<PostModel> getPostsValue() => _postsStream.value;

  void updatePosts(List<PostModel> data) => _postsStream.add(data);
}