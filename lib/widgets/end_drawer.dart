import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/main.dart';

class EndDrawer extends StatefulWidget {
  const EndDrawer({Key? key}) : super(key: key);

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  late TextEditingController nameEditingController;
  late TextEditingController roomIdEditingController;

  @override
  void initState() {
    nameEditingController=TextEditingController();
    roomIdEditingController=TextEditingController();
    nameEditingController.text=currentUser.currentUserName;
    super.initState();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    roomIdEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Themes.bgColor,),
      child: Drawer(
        child: Column(
          children: [
            Row(
              children: const[
                Icon(Icons.rocket_launch,color: Themes.primaryColor,),
                Text(
                  "Puzzle Buster",
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontFamily: 'BigSpace',
                    decorationStyle: TextDecorationStyle.wavy,
                  ),
                )
              ],
            ),
            const Text(
              "Enter your basic details",
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              ),
            ),
            const Text(
              'Enter your basic details Enter your username',
              style: TextStyle(
                fontFamily: 'Raleway',
                color: Color(0x75ffffff),
              ),
              textAlign: TextAlign.left,
            ),
            TextField(
              controller: nameEditingController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                hintText: "Enter your username",
                hintStyle: TextStyle(
                  fontFamily: 'Raleway',
                  color: Color(0x38ffffff),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
