import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context)?7:20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: IconButton(
                onPressed: ()=>Dialogs.launchUrl('https://github.com/deepaklohmod6789/flutter_puzzle_hackathon'),
                padding: EdgeInsets.zero,
                icon: Image.asset(
                  'assets/github.png',
                  width: Responsive.isDesktop(context)?40:60,
                  height: Responsive.isDesktop(context)?40:60,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: IconButton(
                onPressed: (){},
                padding: EdgeInsets.zero,
                icon: Icon(Icons.lock,size: Responsive.isDesktop(context)?30:50,color: Themes.primaryColor,),
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: Column(
              children: [
                IconButton(
                  onPressed: (){},
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.volume_down_rounded,size:Responsive.isDesktop(context)?25:45),
                ),
                SizedBox(height: Responsive.isDesktop(context)?10:40,),
                IconButton(
                  onPressed: (){},
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.live_help_rounded,size: Responsive.isDesktop(context)?25:45),
                ),
                SizedBox(height: Responsive.isDesktop(context)?10:40,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
