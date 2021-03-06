import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_puzzle_hackathon/models/game_arguments.dart';
import 'package:flutter_puzzle_hackathon/pages/game.dart';
import 'package:flutter_puzzle_hackathon/pages/homepage.dart';

class FluroRouting {
  static final router = FluroRouter();
  static final Handler _homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) => const HomePage(),
  );
  static final Handler _gameHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params){
      final Object? args = context!.arguments;
      GameArguments? gameArguments=args as GameArguments?;
      if(gameArguments==null){
        gameArguments=GameArguments.fromCookies();
      } else {
        if(kIsWeb){
          GameArguments.saveToCookies(gameArguments);
        }
      }
      return MyGame(gameArguments: gameArguments,);
    },
  );

  static void setupRouter() {
    router.define('/home', handler: _homeHandler,);
    router.define('/game', handler: _gameHandler,);
    router.notFoundHandler = _homeHandler;
  }
  static void navigateToPage({required String routeName,required BuildContext context, Object? arguments}) {
    router.navigateTo(context, routeName, transition: TransitionType.none,routeSettings: RouteSettings(arguments: arguments));
  }
  static void pushAndClearStackToPage({required String routeName,required BuildContext context}) {
    router.navigateTo(context, routeName, clearStack: true,transition: TransitionType.none);
  }
}