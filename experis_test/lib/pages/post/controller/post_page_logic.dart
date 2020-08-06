import 'package:experis_test/data/model/post/post_model.dart';
import 'package:experis_test/pages/post/controller/post_page_controller.dart';
import 'package:experis_test/services/post_service/post_service.dart';
import 'package:experis_test/utils/export/app_design.dart';
import 'package:experis_test/utils/helpers/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostPageLogic {
  static void get getAllPosts async => PostPageController().updatePosts(await PostService.requestAllPosts);

  static Future<bool> sendPost(PostModel post) async {
    if (!validatePost(post)) return false;
    bool success = await PostService.sendPost(post);
    if (!success) return false;
    List<PostModel> current = PostPageController().getPostsValue() ?? [];
    int id = current.isNotEmpty ? current.last.id + 1 : 0;
    post.id = id;
    post.userId = 1;
    current.add(post);
    PostPageController().updatePosts(current);
    return success;
  }

  static Future<bool> updatePost(PostModel post) async {
    if (!validatePost(post)) return false;
    bool success = await PostService.updatePost(id: post.id, post: post);
    if (!success) return false;
    List<PostModel> current = PostPageController().getPostsValue() ?? [];
    current.forEach((element) {
      if (element.id == post.id) {
        element.title = post.title;
        element.body = post.body;
      }
    });
    PostPageController().updatePosts(current);
    return success;
  }

  static Future<bool> deletePost(int id) async {
    bool success = await PostService.deletePost(id);
    if (!success) return false;
    List<PostModel> current = PostPageController().getPostsValue() ?? [];
    current.removeWhere((element) => element.id == id);
    PostPageController().updatePosts(current);
    return success;
  }

  static bool validatePost(PostModel post) {
    if (!Validators.validString(post.title)) {
      Fluttertoast.showToast(
                      msg: "Título ingresado inválido",
                      backgroundColor: AppColors.PrimaryGrey,
                      textColor: AppColors.PrimaryWhite);
      return false;
    } else if (!Validators.validString(post.body)) {
      Fluttertoast.showToast(
                      msg: "Descripción ingresada inválida",
                      backgroundColor: AppColors.PrimaryGrey,
                      textColor: AppColors.PrimaryWhite);
      return false;
    }
    return true;
  }
}