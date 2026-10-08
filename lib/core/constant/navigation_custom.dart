import 'dart:io';

import 'package:flutter/cupertino.dart';

PageRoute<T> getPageRoute<T>({required Widget page}) {
  if (Platform.isIOS) {
    return CupertinoPageRoute(builder: (_) => page);
  }
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(
          Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut)),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

Future<T?> pushPage<T>(BuildContext context, Widget page) {
  return Navigator.of(context).push<T>(getPageRoute(page: page));
}

/// Push replacement
Future<T?> pushReplacementPage<T>(BuildContext context, Widget page) {
  return Navigator.of(context).pushReplacement<T, T>(getPageRoute(page: page));
}

/// Push and remove until (clears all backstack)
Future<T?> pushAndRemoveAll<T>(BuildContext context, Widget page) {
  return Navigator.of(context).pushAndRemoveUntil<T>(getPageRoute(page: page), (Route<dynamic> route) => false);
}
