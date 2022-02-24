import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hackathon/classes/collection_references.dart';
import 'package:flutter_puzzle_hackathon/constants/themes.dart';
import 'package:flutter_puzzle_hackathon/widgets/responsive.dart';

class UserNameWidget extends StatefulWidget {
  final String roomId;
  final String otherPlayerId;
  final String userName;

  const UserNameWidget({
    Key? key,
    required this.roomId,
    required this.otherPlayerId,
    required this.userName,
  }) : super(key: key);

  @override
  _UserNameWidgetState createState() => _UserNameWidgetState();
}

class _UserNameWidgetState extends State<UserNameWidget> with SingleTickerProviderStateMixin{
  bool newMessage=false;
  late AnimationController _animationController;
  late Animation<Offset> positionAnimation;
  late Animation<double> scale;
  String message="";

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    positionAnimation = Tween<Offset>(begin: const Offset(0,1.5), end: const Offset(0,0)).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.fastLinearToSlowEaseIn));
    scale=CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn);
    CollectionReferences.room.doc(widget.roomId).collection('messages')
        .where('userId',isEqualTo: widget.otherPlayerId)
        .orderBy('timeStamp',descending: true)
        .limit(1)
        .snapshots().listen((QuerySnapshot snapshot){
          if(snapshot.docs.isNotEmpty){
            onNewMessage(snapshot.docs.first);
          }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onNewMessage(DocumentSnapshot snapshot){
    message=snapshot['message'];
    setState(() {
      newMessage=true;
    });
    _animationController.forward();
    Future.delayed(const Duration(seconds: 2),(){
      setState(() {
        newMessage=false;
      });
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: TextStyle(
            fontSize: newMessage?(Responsive.isMobile(context)?14:16):(Responsive.isMobile(context)?20:26),
            color: Colors.white,
          ),
          child: Text(
            widget.userName,
            textAlign: TextAlign.center,
          ),
        ),
        AnimatedOpacity(
          opacity: newMessage?1:0.0,
          duration: const Duration(milliseconds: 500),
          child: SlideTransition(
            position: positionAnimation,
            child: ScaleTransition(
              scale: scale,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Themes.primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
