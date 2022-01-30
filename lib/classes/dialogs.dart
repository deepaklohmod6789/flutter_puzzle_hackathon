import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dialogs{
  static void showToast(String content) {
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      webPosition: 'center',
    );
  }
}