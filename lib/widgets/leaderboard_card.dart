import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/models/leaderboard_model.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';

class LeaderBoardCard extends StatelessWidget {
  final LeaderBoardModel leaderBoardModel;
  const LeaderBoardCard({Key? key,required this.leaderBoardModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.762,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              offset: Offset(1, 3),
              blurRadius: 10,
              spreadRadius: 10,
              color: Colors.black26,
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  leaderBoardModel.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                leaderBoardModel.username,
                style: TextStyle(
                  fontSize: Responsive.isMobile(context)?15:null,
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  leaderBoardModel.timeInSeconds.toString(),
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context)?19:28,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  leaderBoardModel.rank.toString(),
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context)?19:28,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  leaderBoardModel.score.toString(),
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context)?19:28,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
