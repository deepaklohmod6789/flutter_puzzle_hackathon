import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/leaderboard_services.dart';
import 'package:flutter_puzzle_hackathon/models/leaderboard_model.dart';
import 'package:flutter_puzzle_hackathon/widgets/leaderboard_card.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  bool loading=true;
  List<LeaderBoardModel> leaderBoardModels=[];
  static const List<double> angles=[0,-16/360,11/360,-7/360,21/360];

  @override
  void initState() {
    getLeaderBoard();
    super.initState();
  }

  void getLeaderBoard()async{
    leaderBoardModels=await LeaderboardServices.getLeaderBoard();
    setState(() {
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading? const Center(child: CircularProgressIndicator(),):LayoutBuilder(
      builder: (context,constraints){
        return Responsive.isDesktop(context)?SizedBox(
          height: Responsive.isDesktop(context)?constraints.biggest.height*0.7:constraints.biggest.width*0.75,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(leaderBoardModels.length, (index){
              return Dismissible(
                key: UniqueKey(),
                confirmDismiss: (direction)async{
                  if(leaderBoardModels.length>1){
                    setState(() {
                      leaderBoardModels.removeAt(index);
                    });
                    return true;
                  }
                  return false;
                },
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(angles[index%angles.length]),
                  child: LeaderBoardCard(leaderBoardModel: leaderBoardModels[index],),
                ),
              );
            }),
          ),
        ):Responsive.isTablet(context)?ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: leaderBoardModels.length,
          padding: const EdgeInsets.all(30),
          separatorBuilder: (context,index)=>const SizedBox(width: 30,),
          itemBuilder: (context,index)=>LeaderBoardCard(leaderBoardModel: leaderBoardModels[index]),
        ):ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: leaderBoardModels.length,
          padding: const EdgeInsets.all(10),
          separatorBuilder: (context,index)=>const SizedBox(width: 10,),
          itemBuilder: (context,index)=>LeaderBoardCard(leaderBoardModel: leaderBoardModels[index]),
        );
      },
    );
  }
}
