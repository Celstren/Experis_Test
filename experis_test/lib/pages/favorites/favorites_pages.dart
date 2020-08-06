import 'package:experis_test/data/model/favorite/favorite_model.dart';
import 'package:experis_test/pages/favorites/controller/favorite_page_controller.dart';
import 'package:experis_test/pages/post/widgets/post_details.dart';
import 'package:experis_test/pages/post/widgets/post_item.dart';
import 'package:experis_test/utils/export/app_design.dart';
import 'package:experis_test/utils/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.PrimaryYellow,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.PrimaryBrown,
        appBar: AppBar(
          backgroundColor: AppColors.PrimaryYellow,
          title: Text("Favoritos",
              style: AppTextStyle.whiteStyle(
                  fontSize: 20, fontFamily: AppFonts.Montserrat_Bold)),
          centerTitle: true,
        ),
        body: Container(
          child: StreamBuilder<List<FavoriteModel>>(
            stream: FavoritePageController().getFavoritesEvents(),
            builder: (BuildContext context,
                AsyncSnapshot<List<FavoriteModel>> favoritesSnapshot) {
              switch (favoritesSnapshot.connectionState) {
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
                  if (!favoritesSnapshot.hasData) return Container();
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: MediaQuery.of(context).size.width * .05),
                    itemCount: favoritesSnapshot.data.length,
                    itemBuilder: (BuildContext context, int index) =>
                        PostItem(post: favoritesSnapshot.data[index].post, favoriteId: favoritesSnapshot.data[index].id),
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
