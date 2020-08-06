import 'package:experis_test/pages/favorites/controller/favorite_page_logic.dart';
import 'package:experis_test/pages/post/controller/post_page_controller.dart';
import 'package:experis_test/pages/post/controller/post_page_logic.dart';
import 'package:experis_test/pages/post/widgets/post_details.dart';
import 'package:experis_test/pages/post/widgets/post_item.dart';
import 'package:experis_test/utils/export/app_design.dart';
import 'package:experis_test/utils/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostPage extends StatefulWidget {
  PostPage({Key key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.PrimaryYellow,
    ));
    FavoritePageLogic.getAllFavorites;
    PostPageLogic.getAllPosts;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.PrimaryBrown,
        appBar: AppBar(
          backgroundColor: AppColors.PrimaryYellow,
          title: Text("Posts",
              style: AppTextStyle.whiteStyle(
                  fontSize: 20, fontFamily: AppFonts.Montserrat_Bold)),
          centerTitle: true,
          actions: <Widget>[
            Container(
              width: 60,
              child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 20),
              onPressed: () =>
                  Navigator.pushNamed(context, "/Favorites"),
              child:
                  Icon(Icons.favorite, size: 20, color: AppColors.PrimaryWhite),
            ),
            )
          ],
        ),
        body: Container(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: PostPageController().postsData,
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> postsSnapshot) {
              switch (postsSnapshot.connectionState) {
                case ConnectionState.none:
                  return Container();
                  break;
                case ConnectionState.waiting:
                  return Container(
                    child: Center(
                      child: Text("Loading..."),
                    ),
                  );
                  break;
                case ConnectionState.active:
                  if (!postsSnapshot.hasData) return Container();
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: MediaQuery.of(context).size.width * .05),
                    itemCount: postsSnapshot.data.length,
                    itemBuilder: (BuildContext context, int index) =>
                        PostItem(post: postsSnapshot.data[index]["post"], favoriteId: postsSnapshot.data[index]["favoriteId"]),
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: 20),
                  );
                  break;
                case ConnectionState.done:
                  return Container();
                  break;
              }
              return Container(
                    child: Center(
                      child: Text("Loading..."),
                    ),
                  );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showCustomDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(
              backgroundColor: Colors.transparent,
              child: PostDetails(),
            ),
          ),
          backgroundColor: AppColors.PrimaryYellow,
          child: Center(
              child: Icon(Icons.add, color: AppColors.PrimaryWhite, size: 30)),
        ),
      ),
    );
  }
}
