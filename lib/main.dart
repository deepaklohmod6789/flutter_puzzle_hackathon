import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle_hackathon/classes/auth_services.dart';
import 'package:flutter_puzzle_hackathon/classes/cookie_manager.dart';
import 'package:flutter_puzzle_hackathon/models/user_model.dart';
import 'package:flutter_puzzle_hackathon/routing/fluro_routing.dart';

late UserModel currentUser;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  FluroRouting.setupRouter();
  await Firebase.initializeApp();

  final AuthServices authServices=AuthServices();
  User? user= authServices.getCurrentUser();
  user ??= await authServices.signIn();
  String userName=CookieManager.getCookie('currentUserName');
  userName==""?'John':userName;
  currentUser=UserModel(userId: user!.uid, currentUserName: userName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      onGenerateRoute: FluroRouting.router.generator,
    );
  }
}