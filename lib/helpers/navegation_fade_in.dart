import 'package:flutter/cupertino.dart';

Route fadeInTransition(BuildContext context, Widget page) {
  return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          page,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
            child: child,
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)));
      });
}

Route fadeInTransition2(BuildContext context, Widget page) {
  return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          page,
      transitionDuration: const Duration(milliseconds: 2000),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
            child: child,
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)));
      });
}
