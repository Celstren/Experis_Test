import 'dart:convert';

import 'package:experis_test/data/model/favorite/favorite_model.dart';
import 'package:experis_test/data/model/favorite/favorite_reporsitory.dart';
import 'package:experis_test/data/model/post/post_model.dart';
import 'package:experis_test/pages/favorites/controller/favorite_page_logic.dart';
import 'package:experis_test/pages/post/widgets/post_details.dart';
import 'package:experis_test/utils/export/app_design.dart';
import 'package:experis_test/utils/general/app_images.dart';
import 'package:experis_test/utils/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final PostModel post;
  final int favoriteId;

  const PostItem({Key key, this.post, this.favoriteId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCustomDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          backgroundColor: Colors.transparent,
          child: PostDetails(post: post),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        height: 160,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * .9,
                height: 120,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .375 + 10,
                    right: 10,
                    top: 10,
                    bottom: 10),
                decoration: BoxDecoration(
                  color: post.id % 2 == 0
                      ? AppColors.PrimaryBlue
                      : AppColors.PrimaryOrange,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppColors.PrimaryBlack.withOpacity(.5),
                        offset: Offset(5.0, 5.0)),
                  ],
                ),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              post?.title ?? "",
                              style: AppTextStyle.whiteStyle(
                                  fontSize: 14,
                                  fontFamily: AppFonts.Montserrat_SemiBold),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (favoriteId != null) FavoriteRepository().delete(id: favoriteId.toString());
                              else FavoriteRepository().insert(FavoriteModel(post: post));
                              FavoritePageLogic.getAllFavorites;
                            },
                            child: Icon(
                            favoriteId != null ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.PrimaryWhite,
                            size: 25,
                          ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        post?.body ?? "",
                        style: AppTextStyle.whiteStyle(
                            fontSize: 12,
                            fontFamily: AppFonts.Montserrat_Italic),
                        textAlign: TextAlign.justify,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: MediaQuery.of(context).size.width * .375,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.PrimaryWhite,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: AssetImage(AppImages.getAvatar(post.id % 14)),
                      fit: BoxFit.fitHeight),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppColors.PrimaryBlack.withOpacity(.5),
                        offset: Offset(5.0, 5.0)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
