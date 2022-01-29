import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/pages/game.dart';
import 'package:flutter_puzzle_hackathon/pages/homepage.dart';
import 'package:flutter_puzzle_hackathon/pages/page_not_found.dart';
import 'package:flutter_puzzle_hackathon/pages/room_page.dart';

class FluroRouting {
  static final router = FluroRouter();
  static final Handler _homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) => HomePage(),
  );
  static final Handler _roomHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) => const RoomPage(),
  );
  static final Handler _gameHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) => const MyGame(),
  );

  static void setupRouter() {
    router.define('/home', handler: _homeHandler,);
    router.define('/room', handler: _roomHandler,);
    router.define('/game', handler: _gameHandler,);
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>const PageNotFound(),
    );
  }
  static void navigateToPage({required String routeName,required BuildContext context,String? username}) {
    router.navigateTo(context, routeName, transition: TransitionType.none,routeSettings: RouteSettings(arguments: username),);
  }
  static void navigateToMultiPlayerGame({required BuildContext context,required RoomModel roomModel}) {
    router.navigateTo(context, '/game', transition: TransitionType.none,routeSettings: RouteSettings(arguments: roomModel),);
  }
  static void pushAndClearStackToPage({required String routeName,required BuildContext context}) {
    router.navigateTo(context, routeName, clearStack: true,transition: TransitionType.none);
  }
}