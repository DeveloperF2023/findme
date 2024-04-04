import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  const AppBarWidget({super.key, this.title= const Text("FindMe.",style: TextStyle(
      fontFamily: "DancingScript",
      fontSize: 35,
      fontWeight: FontWeight.w900,
      color: primary
  ),), this.icon=EvaIcons.messageSquare, this.color=primary, this.automaticallyImplyLeading = false,});
  final Text? title;
  final IconData? icon;
  final Color? color;
  final bool? automaticallyImplyLeading;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: automaticallyImplyLeading!,
      title: title,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(icon,color: color,))
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
