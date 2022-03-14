import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/classes/game_version.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/main.dart';
import 'package:flutter_puzzle_hackathon/pages/waiting_room.dart';
import 'package:flutter_puzzle_hackathon/widgets/end_drawer.dart';
import 'package:flutter_puzzle_hackathon/widgets/leaderboard.dart';
import 'package:flutter_puzzle_hackathon/widgets/nav_bar.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';
import 'package:flutter_puzzle_hackathon/widgets/sidebar.dart';
import 'package:marquee/marquee.dart';
import 'package:universal_html/html.dart' as html;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isEndDrawerOpen=false;
  ValueNotifier<bool> showHomeContent=ValueNotifier(true);
  ValueNotifier<bool> showWaitingRoom=ValueNotifier(false);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String roomId='';
  late TextEditingController nameEditingController;
  late TextEditingController roomIdEditingController;
  static const String home="It's time to put your brain to work and burst the most creative slide puzzle you can think of. You take on the role of John, who aims to solve the puzzle in ascending order starting from 1 and in the fewest number of moves and time in order to top the leaderboard. And why not challenge and defeat a friend in multiplayer mode? Remember, you're a burster, not a newbie, and you were born to rule the board. Now simply just go and play your way out of the riddle by bursting yourself out.";
  static const String about="Team Exordium intends to compete in hackathons and create projects that stand out from the crowd. Puzzle Buster is another result of this motivation, and it was created for 'Flutter Puzzle Hack 2022' by Jatin Gupta and Deepak Lohmod. Were you wowed by our efforts? So, what's stopping you from staring our project on github and supporting it? Feel free to contact us if you are interested in working together or need assistance.";

  @override
  void initState() {
    final loader = html.document.getElementsByClassName('preloader');
    if(loader.isNotEmpty) {
      loader.first.remove();
    }
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

  Column content(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Responsive.isMobile(context)?const SizedBox():NavBar(scaffoldKey: _key,showHomeContent: showHomeContent,),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: Responsive.size(context, mobile: 10, tablet: 30, desktop: 20),
              right: Responsive.size(context, mobile: 10, tablet: 50, desktop: 0),
            ),
            child: ValueListenableBuilder<bool>(
              valueListenable: showHomeContent,
              builder: (context,bool value,child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      value?"Supreme Star":"About Us",
                      style: TextStyle(
                        fontSize: Responsive.size(context, mobile: 30, tablet: 60, desktop: 45),
                        color: Themes.primaryColor,
                        fontWeight: Responsive.isTablet(context)?null:FontWeight.bold,
                      ),
                    ),
                    Text(
                      value?home:about,
                      style: TextStyle(
                        fontSize: Responsive.size(context, mobile: 17, tablet: 28, desktop: 20),
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: Responsive.isMobile(context)?10:0,),
                    TextButton.icon(
                      onPressed: (){
                        if(value){
                          _key.currentState!.openEndDrawer();
                        } else {
                          Dialogs.launchUrl('https://www.linkedin.com/in/xonedesigner/');
                        }
                      },
                      label: Icon(Icons.arrow_forward_ios_outlined,color: Responsive.isMobile(context)?Themes.primaryColor:Colors.white,),
                      icon: Text(
                        value?"play now":"contact us",
                        style: TextStyle(color: Responsive.isMobile(context)?Themes.primaryColor:Colors.white,fontSize: Responsive.isDesktop(context)?16:24),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Responsive.isMobile(context)?Colors.white:Themes.primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.size(context, mobile: 15, tablet: 25, desktop: 30),
                          vertical: Responsive.size(context, mobile: 10, tablet: 25, desktop: 20),
                        ),
                      ),
                    ),
                    Responsive.isDesktop(context)?Text(
                      "Version "+GameVersion.getCurrentVersion(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xb5ffffff),
                      ),
                      textAlign: TextAlign.left,
                    ):const SizedBox(),
                  ],
                );
              }
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black,
      endDrawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.transparent,
      onEndDrawerChanged: (bool isOpened){
        if(!Responsive.isMobile(context)){
          setState(() {
            isEndDrawerOpen=isOpened;
          });
        }
      },
      endDrawer: SizedBox(
        width: Responsive.size(
          context,
          mobile: double.infinity,
          tablet: MediaQuery.of(context).size.width*0.6,
          desktop: MediaQuery.of(context).size.width*0.25,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Themes.bgColor,),
          child: Drawer(
            child: EndDrawer(
              onResult: (String roomId){
                this.roomId=roomId;
                showWaitingRoom.value=true;
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Responsive.isMobile(context)?const SizedBox():const SideBar(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: Responsive.size(context, mobile: 28, tablet: 30, desktop: 20),
                          color: Colors.black,
                          child: Marquee(
                            blankSpace: 5,
                            text: 'This project was created in Flutter for "Flutter Puzzle Hack 2022" and is the most imaginative yet solvable slide puzzle you can conceive. Please feel free to look at the code on our github and utilise it to help you develop your skills.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.size(context, mobile: 16, tablet: 20, desktop: 13),
                            ),
                          ),
                        ),
                        Responsive.isMobile(context)?AppBar(
                          automaticallyImplyLeading: false,
                          backgroundColor: Colors.white,
                          actions: const [SizedBox()],
                          centerTitle: true,
                          leading: IconButton(
                            onPressed: ()=>_key.currentState!.openEndDrawer(),
                            icon: const Icon(Icons.more_vert_rounded,size: 30,color: Colors.black,),
                          ),
                          title: const Text(
                            "Puzzle Buster",
                            style: TextStyle(
                              fontFamily: 'BigSpace',
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                        ):Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:20.0),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'PUZZLE BUSTER',
                                style: TextStyle(
                                  fontSize: 150,
                                  fontFamily: 'BigSpace',
                                  letterSpacing: 5,
                                  decorationStyle: TextDecorationStyle.wavy,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeCap = StrokeCap.round
                                    ..strokeJoin = StrokeJoin.round
                                    ..strokeWidth = 2.5
                                    ..color = Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Responsive.isDesktop(context)?0:10,),
                        Expanded(
                          child: Responsive(
                            mobile: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.black54,
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.fromLTRB(10,0,10,8),
                                    child: content(),
                                  ),
                                ),
                                const Expanded(
                                  flex: 4,
                                  child: LeaderBoard(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:10,bottom:10),
                                  child: Text(
                                    "Version "+GameVersion.getCurrentVersion(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xb5ffffff),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            tablet: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: content(),
                                ),
                                const Expanded(
                                  flex: 3,
                                  child: LeaderBoard(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(30,20,0,30),
                                  child: Text(
                                    "Version "+GameVersion.getCurrentVersion(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Color(0xb5ffffff),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            desktop: Row(
                              children: [
                                Expanded(
                                  flex: Responsive.isDesktop(context)?1:3,
                                  child: content(),
                                ),
                                Expanded(
                                  flex: Responsive.isDesktop(context)?1:2,
                                  child: const LeaderBoard(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            isEndDrawerOpen?Container(
              width: Responsive.isDesktop(context)?MediaQuery.of(context).size.width*0.75:MediaQuery.of(context).size.width*0.4,
              height: double.infinity,
              color: const Color(0xe0000000),
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: Responsive.isDesktop(context)?4:7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        const Spacer(),
                        Responsive.isDesktop(context)?const SizedBox():const Spacer(),
                        const Text(
                          'How to play?',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 35,
                            color: Themes.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: Responsive.isDesktop(context)?30:10,),
                        const Text(
                          'You can play this as a single player or multiplayer game, but the goal is to solve the puzzle by tapping on the tiles surrounding the empty tile and arranging the tiles in ascending order beginning with 1 and ending with the empty tile. When you finish a round in single mode, your score is saved to the leaderboard, whereas in multiplayer mode, the next round begins if you have selected more than one round. You can also change the number of tiles on the board and the number of rounds.',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 18,
                            color: Color(0x73ffffff),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Spacer(),
                        Text(
                          'Version  '+GameVersion.getCurrentVersion(),
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            color: Color(0x5cffffff),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
            ):const SizedBox(),
            ValueListenableBuilder(
              valueListenable: showWaitingRoom,
              builder: (context,bool value,child){
                return value?WaitingRoom(
                  roomId: roomId,
                  onClose: (){
                    showWaitingRoom.value=false;
                  },
                ):const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
