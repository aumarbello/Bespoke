import 'package:flutter/material.dart';

class CustomRoute extends MaterialPageRoute {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) {
      return child;
    }

    final offset = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(animation);

    return SlideTransition(
      child: child,
      position: offset,
    );
  }
}

class CustomPageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (route.settings.isInitialRoute) {
      return child;
    }

    //Slide in from the right and out to the right
    final offset = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(animation);

    //Slide up
//    final offset = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
//        .animate(animation);

    return SlideTransition(
      child: child,
      position: offset,
    );
  }
}
