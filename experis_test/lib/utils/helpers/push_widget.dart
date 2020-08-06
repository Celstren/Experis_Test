import 'package:flutter/material.dart';

void pushWidget(BuildContext context, Widget widget) {
  Navigator.of(context).push(
    new PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) => widget,
      transitionsBuilder: (c, anim, a2, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: Duration(milliseconds: 120),
    ),
  );
}
