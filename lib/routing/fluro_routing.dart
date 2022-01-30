import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/pages/homepage.dart';
import 'package:flutter_puzzle_hackathon/pages/page_not_found.dart';

class FluroRouting {
  static final router = FluroRouter();
  static final Handler _homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) => HomePage(),
  );

  static void setupRouter() {
    router.define('/home', handler: _homeHandler,);
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>const PageNotFound(),
    );
  }
  static void navigateToPage({required String routeName,required BuildContext context}) {
    router.navigateTo(context, routeName, transition: TransitionType.none);
  }
  static void pushAndClearStackToPage({required String routeName,required BuildContext context}) {
    router.navigateTo(context, routeName, clearStack: true,transition: TransitionType.none);
  }
}