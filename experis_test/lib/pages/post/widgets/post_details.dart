import 'package:experis_test/data/model/post/post_model.dart';
import 'package:experis_test/pages/post/controller/post_page_controller.dart';
import 'package:experis_test/pages/post/controller/post_page_logic.dart';
import 'package:experis_test/utils/export/app_design.dart';
import 'package:experis_test/utils/general/app_images.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostDetails extends StatefulWidget {
  final PostModel post;

  PostDetails({Key key, this.post}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  bool isEdited = false;

  bool isLoading = false;

  @override
  void initState() {
    if (widget.post != null) {
      isEdited = true;
      titleController.text = widget.post.title;
      bodyController.text = widget.post.body;
    }
    super.initState();
  }

  Widget _buildPortraitDialog() {
    return Container(
      height: MediaQuery.of(context).size.height * .7,
      width: MediaQuery.of(context).size.width * .8,
      decoration: BoxDecoration(
        color: AppColors.PrimaryBrown,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * .375,
                  height: 160,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: AppColors.PrimaryWhite,
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: AssetImage(
                            AppImages.getAvatar((widget.post?.id ?? 0) % 14)),
                        fit: BoxFit.fitHeight),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppColors.PrimaryBlack.withOpacity(.5),
                          offset: Offset(5.0, 5.0)),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Icon(Icons.close,
                      size: 30, color: AppColors.PrimaryWhite),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.PrimaryWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: titleController,
              style: AppTextStyle.blackStyle(
                  fontSize: 14, fontFamily: AppFonts.Montserrat_SemiBold),
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(
                hintText: "Escribe un título",
                hintStyle: AppTextStyle.blackStyle(
                    fontSize: 14, fontFamily: AppFonts.Montserrat_SemiBold),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.PrimaryWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: bodyController,
                style: AppTextStyle.blackStyle(
                    fontSize: 14, fontFamily: AppFonts.Montserrat_SemiBold),
                textAlign: TextAlign.justify,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                  hintText: "Escribe el contenido del post aquí",
                  hintStyle: AppTextStyle.blackStyle(fontSize: 12),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width * .7,
            child: !isLoading
                ? Row(
                    mainAxisAlignment: isEdited
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * .3,
                        decoration: BoxDecoration(
                          color: isEdited
                              ? AppColors.PrimaryBlue
                              : AppColors.PrimaryGreen,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppColors.PrimaryBlack.withOpacity(.25),
                                offset: Offset(3.0, 3.0)),
                          ],
                        ),
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            bool success = false;
                            if (isEdited)
                              success = await PostPageLogic.updatePost(
                                  PostModel(
                                      id: widget.post.id,
                                      userId: widget.post.userId,
                                      title: titleController.value.text,
                                      body: bodyController.value.text));
                            else
                              success = await PostPageLogic.sendPost(PostModel(
                                  title: titleController.value.text,
                                  body: bodyController.value.text));
                            setState(() {
                              isLoading = false;
                            });
                            if (success) {
                              Fluttertoast.showToast(
                                  msg: "¡Datos enviados con éxito!",
                                  backgroundColor: AppColors.PrimaryGrey,
                                  textColor: AppColors.PrimaryWhite);
                              Navigator.pop(context);
                            }
                          },
                          child: Center(
                            child: Text(isEdited ? "Guardar" : "Crear",
                                style: AppTextStyle.whiteStyle(
                                    fontSize: 14,
                                    fontFamily: AppFonts.Montserrat_Bold)),
                          ),
                        ),
                      ),
                      isEdited
                          ? Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * .3,
                              decoration: BoxDecoration(
                                color: AppColors.PrimaryRed,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppColors.PrimaryBlack.withOpacity(
                                          .25),
                                      offset: Offset(3.0, 3.0)),
                                ],
                              ),
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  bool success = await PostPageLogic.deletePost(
                                      widget.post.id);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (success) {
                                    Fluttertoast.showToast(
                                        msg: "Post eliminado con éxito!",
                                        backgroundColor: AppColors.PrimaryGrey,
                                        textColor: AppColors.PrimaryWhite);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Center(
                                  child: Text("Eliminar",
                                      style: AppTextStyle.whiteStyle(
                                          fontSize: 14,
                                          fontFamily:
                                              AppFonts.Montserrat_Bold)),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )
                : Container(
                    child: Center(
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * .25,
                        decoration: BoxDecoration(
                          color: AppColors.PrimaryRed,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppColors.PrimaryBlack.withOpacity(.25),
                                offset: Offset(3.0, 3.0)),
                          ],
                        ),
                        child: Center(
                          child: Text("Cargando...",
                              style: AppTextStyle.whiteStyle(
                                  fontSize: 14,
                                  fontFamily: AppFonts.Montserrat_Bold)),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeDialog() {
    return Container(
      height: MediaQuery.of(context).size.height * .7,
      width: MediaQuery.of(context).size.width * .9,
      decoration: BoxDecoration(
        color: AppColors.PrimaryBrown,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * .2,
            height: 160,
            margin: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: AppColors.PrimaryWhite,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: AssetImage(
                      AppImages.getAvatar((widget.post?.id ?? 0) % 14)),
                  fit: BoxFit.fitHeight),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: AppColors.PrimaryBlack.withOpacity(.5),
                    offset: Offset(5.0, 5.0)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Icon(Icons.close,
                        size: 20, color: AppColors.PrimaryWhite),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.PrimaryWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: titleController,
                    style: AppTextStyle.blackStyle(
                        fontSize: 14, fontFamily: AppFonts.Montserrat_SemiBold),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration.collapsed(
                      hintText: "Escribe un título",
                      hintStyle: AppTextStyle.blackStyle(
                          fontSize: 14,
                          fontFamily: AppFonts.Montserrat_SemiBold),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.PrimaryWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: bodyController,
                      style: AppTextStyle.blackStyle(
                          fontSize: 14,
                          fontFamily: AppFonts.Montserrat_SemiBold),
                      textAlign: TextAlign.justify,
                      maxLines: null,
                      decoration: InputDecoration.collapsed(
                        hintText: "Escribe el contenido del post aquí",
                        hintStyle: AppTextStyle.blackStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width * .6,
                  child: !isLoading
                      ? Row(
                          mainAxisAlignment: isEdited
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * .25,
                              decoration: BoxDecoration(
                                color: isEdited
                                    ? AppColors.PrimaryBlue
                                    : AppColors.PrimaryGreen,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppColors.PrimaryBlack.withOpacity(
                                          .25),
                                      offset: Offset(3.0, 3.0)),
                                ],
                              ),
                              child: FlatButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  bool success = false;
                                  if (isEdited)
                                    success = await PostPageLogic.updatePost(
                                        PostModel(
                                            id: widget.post.id,
                                            userId: widget.post.userId,
                                            title: titleController.value.text,
                                            body: bodyController.value.text));
                                  else
                                    success = await PostPageLogic.sendPost(
                                        PostModel(
                                            title: titleController.value.text,
                                            body: bodyController.value.text));
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (success) {
                                    Fluttertoast.showToast(
                                        msg: "¡Datos enviados con éxito!",
                                        backgroundColor: AppColors.PrimaryGrey,
                                        textColor: AppColors.PrimaryWhite);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Center(
                                  child: Text(isEdited ? "Guardar" : "Crear",
                                      style: AppTextStyle.whiteStyle(
                                          fontSize: 14,
                                          fontFamily:
                                              AppFonts.Montserrat_Bold)),
                                ),
                              ),
                            ),
                            isEdited
                                ? Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    decoration: BoxDecoration(
                                      color: AppColors.PrimaryRed,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: AppColors.PrimaryBlack
                                                .withOpacity(.25),
                                            offset: Offset(3.0, 3.0)),
                                      ],
                                    ),
                                    child: FlatButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        bool success =
                                            await PostPageLogic.deletePost(
                                                widget.post.id);
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (success) {
                                          Fluttertoast.showToast(
                                              msg: "Post eliminado con éxito!",
                                              backgroundColor:
                                                  AppColors.PrimaryGrey,
                                              textColor:
                                                  AppColors.PrimaryWhite);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Center(
                                        child: Text("Eliminar",
                                            style: AppTextStyle.whiteStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    AppFonts.Montserrat_Bold)),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        )
                      : Container(
                          child: Center(
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * .25,
                              decoration: BoxDecoration(
                                color: AppColors.PrimaryRed,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppColors.PrimaryBlack.withOpacity(
                                          .25),
                                      offset: Offset(3.0, 3.0)),
                                ],
                              ),
                              child: Center(
                                child: Text("Cargando...",
                                    style: AppTextStyle.whiteStyle(
                                        fontSize: 14,
                                        fontFamily: AppFonts.Montserrat_Bold)),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? _buildPortraitDialog()
            : _buildLandscapeDialog(),
      ),
    );
  }
}
