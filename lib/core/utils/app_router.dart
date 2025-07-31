import 'package:flutter/material.dart';

class AppRouter {
  static dynamic getPage<T extends Object>(
      BuildContext context, Widget widget) {
    return Navigator.push(
      context,
      CustomMaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  static dynamic pushReplace<T extends Object>(
      BuildContext context, Widget widget) {
    return Navigator.pushReplacement(
      context,
      CustomMaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }
}

class CustomMaterialPageRoute extends MaterialPageRoute<void> {
  CustomMaterialPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
  });
  @override
  @protected
  bool get hasScopedWillPopCallback {
    return false;
  }
}
