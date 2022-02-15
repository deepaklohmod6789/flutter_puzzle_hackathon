import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/cookie_manager.dart';
import 'package:flutter_puzzle_hackathon/classes/dialogs.dart';
import 'package:flutter_puzzle_hackathon/classes/game_version.dart';
import 'package:flutter_puzzle_hackathon/classes/room_services.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/main.dart';
import 'package:flutter_puzzle_hackathon/models/room_arguments.dart';
import 'package:flutter_puzzle_hackathon/models/room_model.dart';
import 'package:flutter_puzzle_hackathon/routing/fluro_routing.dart';
import 'package:flutter_puzzle_hackathon/widgets/end_drawer.dart';
import 'package:flutter_puzzle_hackathon/widgets/leaderboard.dart';
import 'package:flutter_puzzle_hackathon/widgets/nav_bar.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';
import 'package:flutter_puzzle_hackathon/widgets/sidebar.dart';
import 'package:marquee/marquee.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isEndDrawerOpen=false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
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

  Widget old(){
    return Scaffold(
      body: Column(
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nameEditingController,
            decoration: const InputDecoration(
              hintText: "Username",
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            controller: roomIdEditingController,
            decoration: const InputDecoration(
              hintText: "Room Id",
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: (){
              CookieManager.deleteMultiplayerGameCookies();
              FluroRouting.navigateToPage(routeName: '/game', context: context);
            },
            child: const Text("Single Player"),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: (){
              if(nameEditingController.text.trim().isNotEmpty){
                currentUser.currentUserName=nameEditingController.text.trim();
                FluroRouting.navigateToPage(
                  routeName: '/room',
                  context: context,
                  arguments: RoomArguments(currentUserName: nameEditingController.text.trim()),
                );
              } else {
                Dialogs.showToast('Enter name to continue');
              }
            },
            child: const Text("Create Room"),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: ()async{
              if(nameEditingController.text.trim().isEmpty){
                Dialogs.showToast('Enter name to continue');
              } else if(roomIdEditingController.text.trim().isEmpty){
                Dialogs.showToast('Enter room id to continue');
              } else {
                currentUser.currentUserName=nameEditingController.text.trim();
                RoomModel? roomModel=await RoomServices.joinRoom(roomIdEditingController.text.trim(), nameEditingController.text.trim());
                FluroRouting.navigateToPage(
                  routeName: '/room',
                  context: context,
                  arguments: RoomArguments(
                    currentUserName: nameEditingController.text.trim(),
                    roomId: roomIdEditingController.text.trim(),
                    roomModel: roomModel,
                  ),
                );
              }
            },
            child: const Text("Join Room"),
          ),
        ],
      ),
    );
  }

  Column content(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Responsive.isMobile(context)?const SizedBox():NavBar(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: Responsive.size(context, mobile: 10, tablet: 30, desktop: 20),
              right: Responsive.size(context, mobile: 10, tablet: 50, desktop: 0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Supreme Star",
                  style: TextStyle(
                    fontSize: Responsive.size(context, mobile: 30, tablet: 60, desktop: 45),
                    color: Themes.primaryColor,
                    fontWeight: Responsive.isTablet(context)?null:FontWeight.bold,
                  ),
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no ',
                  style: TextStyle(
                    fontSize: Responsive.size(context, mobile: 17, tablet: 28, desktop: 20),
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: Responsive.isMobile(context)?10:0,),
                TextButton.icon(
                  onPressed: ()=>_key.currentState!.openEndDrawer(),
                  label: Icon(Icons.arrow_forward_ios_outlined,color: Responsive.isMobile(context)?Themes.primaryColor:Colors.white,),
                  icon: Text(
                    "play now",
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
          child: const Drawer(
            child: EndDrawer(),
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
                            text: 'There once was a boy who told this story about a boy: "',
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
                            onPressed: (){},
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
                          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ',
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
          ],
        ),
      ),
    );
  }
}
