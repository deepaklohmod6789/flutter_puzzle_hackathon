import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/cookie_manager.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/routing/fluro_routing.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';

class NavBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ValueNotifier<bool> showHomeContent;
  late final ButtonStyle buttonStyle;

  NavBar({Key? key,required this.scaffoldKey,required this.showHomeContent}) : super(key: key){
    buttonStyle=TextButton.styleFrom().copyWith(
      foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return Themes.primaryColor;
        }
        if (states.contains(MaterialState.pressed)) {
          return Colors.blue;
        }
        return Colors.black;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: Color(0x29000000),
            offset: Offset(7, 0),
            blurRadius: 61,
          ),
        ],
      ),
      width: Responsive.isDesktop(context)?double.infinity:MediaQuery.of(context).size.width*0.77,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: ()=>showHomeContent.value=true,
            style: buttonStyle,
            child: Text(
              'home',
              style: TextStyle(fontSize: Responsive.isDesktop(context)?16:22,fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: (){
              CookieManager.deleteMultiplayerGameCookies();
              FluroRouting.navigateToPage(routeName: '/game', context: context);
            },
            child: Text(
              'single player',
              style: TextStyle(fontSize: Responsive.isDesktop(context)?16:22,fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: ()=>scaffoldKey.currentState!.openEndDrawer(),
            child: Text(
              'multiplayer',
              style: TextStyle(fontSize: Responsive.isDesktop(context)?16:22,fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            style: buttonStyle,
            onPressed: ()=>showHomeContent.value=false,
            child: Text(
              'about us',
              style: TextStyle(fontSize: Responsive.isDesktop(context)?16:22,fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
