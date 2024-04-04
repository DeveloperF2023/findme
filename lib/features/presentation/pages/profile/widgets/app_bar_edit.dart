import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../../constants.dart';



class AppBarEditProfileWidget extends StatelessWidget implements PreferredSizeWidget{
  const AppBarEditProfileWidget({super.key, this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      title: const Text("FindMe.",style: TextStyle(
          fontFamily: "DancingScript",
          fontSize: 35,
          fontWeight: FontWeight.w900,
          color: primary
      ),),
      actions: [
        IconButton(onPressed: onPressed, icon: Icon(EvaIcons.checkmark,color: primary,size: 30,))
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
