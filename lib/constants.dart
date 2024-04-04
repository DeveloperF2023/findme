import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

const Color primary = Color(0xff2471A3);
const Color backgroundColor = Colors.white;
const Color black87 = Colors.black87;
Color? secondaryColor = Colors.grey[600];
Color? grey400 = Colors.grey[400];
Color? grey500 = Colors.grey[500];
Color? grey200 = Colors.grey[200];

Widget sizeVertical(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sizeHorizontal(double width) {
  return SizedBox(
    width: width,
  );
}

class NavigationStrings {
  static const String editProfile = "editProfilePage";
  static const String editPost = "editPostPage";
  static const String uploadPost = "uploadPostPage";
  static const String commentPage = "commentPage";
  static const String singlePost = "singlePostPage";
  static const String post = "postPage";
  static const signIn = "signInPage";
  static const signUp = "signUpPage";
  static const main = "mainPage";
  static const postDetail = "postDetailPage";
}

class FirebaseConstants {
  static const String users = "users";
  static const String posts = "posts";
  static const String comments = "comments";
  static const String replay = "replay";
}
 FToast ftoast = FToast();
void toast({required String message, required IconData icon, required Color color}) {
  ftoast.showToast(
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 5),
    child: Row(
      children: [
        Icon(icon,size: 20,color: color,),
        sizeHorizontal(10),
        Text(message,style: const TextStyle(
          fontFamily: "Roboto",
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: Colors.black
        ),)
      ],
    )
  );
}
