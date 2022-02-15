import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/main.dart';

class EndDrawer extends StatefulWidget {
  const EndDrawer({Key? key}) : super(key: key);

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  late ScrollController _scrollController;
  late TextEditingController nameEditingController;
  late TextEditingController roomIdEditingController;

  @override
  void initState() {
    _scrollController=ScrollController();
    nameEditingController=TextEditingController();
    roomIdEditingController=TextEditingController();
    nameEditingController.text=currentUser.currentUserName;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    nameEditingController.dispose();
    roomIdEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scrollbar(
        isAlwaysShown: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const[
                  Icon(Icons.lock,color: Themes.primaryColor,),
                  SizedBox(width: 20,),
                  Text(
                    "Puzzle Buster",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'BigSpace',
                      decorationStyle: TextDecorationStyle.wavy,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              const Text(
                "Enter your basic details",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Enter your basic details Enter your username',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Raleway',
                  color: Color(0x75ffffff),
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30,),
              SizedBox(
                height: 25,
                child: TextField(
                  controller: nameEditingController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: "Enter your username",
                    hintStyle: const TextStyle(
                      fontFamily: 'Raleway',
                      color: Color(0x38ffffff),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.only(bottom: 5),
                      onPressed: (){},
                      icon: const Icon(Icons.arrow_forward,color: Themes.primaryColor,),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 17,),
              const Text(
                'Choose Avatar',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 13,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 60,
                child: ListView.separated(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context,index)=>const SizedBox(width: 7,),
                  itemBuilder: (context,index){
                    return Container(
                      height: double.infinity,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1639628735078-ed2f038a193e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzB8fGNoYXJhY3RlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 17,),
              const Text(
                'Select game mode',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 13,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10,),
              TextButton(
                onPressed: (){},
                child: const Text(
                  'Single Player',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14,
                    color: Color(0x8affffff),
                  ),
                  textAlign: TextAlign.left,
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: const Color(0xff1d1d1d),
                  minimumSize: const Size(double.infinity,45),
                ),
              ),
              const SizedBox(height: 5,),
              TextButton(
                onPressed: (){},
                child: const Text(
                  'Multi Player',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14,
                    color: Color(0x8affffff),
                  ),
                  textAlign: TextAlign.left,
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: const Color(0xff1d1d1d),
                  minimumSize: const Size(double.infinity,45),
                ),
              ),
              const SizedBox(height: 17,),
              const Text(
                'Would you like to',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 13,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10,),
              TextButton(
                onPressed: (){},
                child: const Text(
                  'Join Room',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 14,
                    color: Color(0x8affffff),
                  ),
                  textAlign: TextAlign.left,
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: const Color(0xff1d1d1d),
                  minimumSize: const Size(double.infinity,45),
                ),
              ),
              const SizedBox(height: 5,),
              TextButton(
                onPressed: (){},
                child: const Text(
                  'Create Room',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 13,
                    color: Color(0x8affffff),
                  ),
                  textAlign: TextAlign.left,
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: const Color(0xff1d1d1d),
                  minimumSize: const Size(double.infinity,45),
                ),
              ),
              const SizedBox(height: 25,),
              Container(
                padding: const EdgeInsets.symmetric(vertical:10,horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xff1d1d1d),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "sfdagsg6757vdvfsvfgseg",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    IconButton(
                      onPressed: (){},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.copy,color: Themes.primaryColor,size: 21,),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              TextButton(
                onPressed: (){},
                child: const CustomPaint(
                  painter: StartPlayingPainter(),
                  size: Size(double.infinity,45),
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: Colors.transparent,
                  minimumSize: const Size(double.infinity,45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StartPlayingPainter extends CustomPainter {
  static const double iconSize=20;
  const StartPlayingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const pointMode = ui.PointMode.polygon;
    const textStyle = TextStyle(
      fontFamily: 'Raleway',
      fontSize: 15,
      color: Color(0xc2ffffff),
    );
    const textSpan = TextSpan(
      text: 'Start Playing',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    const xCenter = 0.0;
    final yCenter = (size.height-textPainter.height) / 2;
    final textOffset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, textOffset);

    const icon = Icons.arrow_forward;
    TextPainter iconPainter = TextPainter(textDirection: TextDirection.ltr);
    iconPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        color: Themes.primaryColor,
        fontSize: iconSize,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
    );
    iconPainter.layout();
    iconPainter.paint(canvas, Offset(size.width-iconSize, (size.height-iconPainter.height)/2));
    final points = [
      Offset(textPainter.width+10, size.height/2),
      Offset(size.width-(iconPainter.width/2), size.height/2),
    ];
    final paint = Paint()
      ..color = Themes.primaryColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}