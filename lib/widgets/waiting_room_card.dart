import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/models/waiting_room_user.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';

class WaitingRoomCard extends StatelessWidget {
  final WaitingRoomUser waitingRoomUser;
  const WaitingRoomCard({Key? key,required this.waitingRoomUser}) : super(key: key);

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
                aspectRatio: 0.845,
                child: waitingRoomUser.userImage==""?Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: const Color(0xffc6c6c6),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3d000000),
                        offset: Offset(1, 10),
                        blurRadius: 56,
                      ),
                    ],
                  ),
                  child: const Text(
                    "?",
                    style: TextStyle(fontSize: 50),
                  ),
                ):Image.network(
                  waitingRoomUser.userImage,
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
                waitingRoomUser.userName==""?"anonymous":waitingRoomUser.userName,
                style: TextStyle(
                  fontSize: Responsive.size(context, mobile: 15, tablet: 22, desktop: 14),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
