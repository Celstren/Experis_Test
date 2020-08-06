import 'package:experis_test/data/model/post/post_model.dart';

class FavoriteModel {
  int id;
  PostModel post;

  FavoriteModel({
    this.id,
    this.post,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
        id: json["id"],
        post: json["post"] != null ? PostModel.fromJson(json["post"]) : null,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": post,
    };

}