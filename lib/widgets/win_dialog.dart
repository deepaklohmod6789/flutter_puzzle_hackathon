import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/routing/fluro_routing.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';

class WinDialog extends StatelessWidget {
  final String seconds;
  final int score;
  final int moves;
  final String image;
  final String username;
  final String content;

  const WinDialog({
    Key? key,
    required this.seconds,
    required this.score,
    required this.moves,
    required this.image,
    required this.username,
    required this.content,
  }) : super(key: key);

  List<Widget> children(BuildContext context){
    return [
      Expanded(
        flex: 4,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: const Color(0xff4d4d4d),width: 10),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      Expanded(
        flex: 7,
        child: Padding(
          padding: EdgeInsets.all(Responsive.isMobile(context)?5:15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "WINNER",
                style: TextStyle(
                  color: Themes.primaryColor,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    seconds,
                    style: TextStyle(
                      fontSize: Responsive.size(context, mobile: 28, tablet: 40, desktop: 30),
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    moves.toString(),
                    style: TextStyle(
                      fontSize: Responsive.size(context, mobile: 28, tablet: 40, desktop: 30),
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    score.toString(),
                    style: TextStyle(
                      fontSize: Responsive.size(context, mobile: 28, tablet: 40, desktop: 30),
                      letterSpacing: 3,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                username,
                style: TextStyle(
                  fontSize: Responsive.isMobile(context)?25:37,
                  color: Themes.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white54,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: Responsive.size(context, mobile: size.height*0.67, tablet: size.height*0.27, desktop: size.width*0.25),
          width: Responsive.size(context, mobile: size.width*0.7, tablet: size.width*0.8, desktop: size.width*0.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Themes.lightColor,
          ),
          padding: EdgeInsets.all(Responsive.isMobile(context)?5:15),
          margin: const EdgeInsets.only(top: 10,right: 10),
          child: Responsive.isMobile(context)?Column(
            children: children(context),
          ):Row(
            children: children(context),
          ),
        ),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
            FluroRouting.pushAndClearStackToPage(routeName: '/home', context: context);
          },
          child: const Icon(Icons.close,color: Colors.black,),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
          ),
        ),
      ],
    );
  }
}
