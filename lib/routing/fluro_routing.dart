import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_puzzle_hackathon/models/game_arguments.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/pages/game.dart';
import 'package:flutter_puzzle_hackathon/pages/homepage.dart';
import 'package:flutter_puzzle_hackathon/pages/test_board.dart';

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

  static final Handler _testHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params){
      GameArguments g=GameArguments(
        roomModel: RoomModel(
          roomId: 'FJ6HZYmHoWBscfAbIo8A',
          puzzleSize: 3,
          noOfRounds: 3,
          gameStarted: true,
          roomOwnerId: 'eQgKuRQ9uIMkMfVcm5SQALzdDDE2',
          roomOwnerName: 'John',
          roomOwnerImage: '',
          otherPlayerId: 'gjVRofryXNQzkj1tovc1fJvqenn2',
          otherPlayerName: 'Mr. Jack',
          otherPlayerImage: '',
          roomCreatedTimeStamp: DateTime.now(),
        ),
        currentUserName: 'John',
      );
      return TestBoard(
        gameArguments: g,
      );
    }
  );

  static void setupRouter() {
    router.define('/home', handler: _homeHandler,);
    router.define('/game', handler: _gameHandler,);
    router.define('/test', handler: _testHandler,);
    router.notFoundHandler = _homeHandler;
  }
  static void navigateToPage({required String routeName,required BuildContext context, Object? arguments}) {
    router.navigateTo(context, routeName, transition: TransitionType.none,routeSettings: RouteSettings(arguments: arguments));
  }
  static void pushAndClearStackToPage({required String routeName,required BuildContext context}) {
    router.navigateTo(context, routeName, clearStack: true,transition: TransitionType.none);
  }
}