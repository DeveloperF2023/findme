import 'package:flutter/material.dart';
import 'package:social/constants.dart';

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({super.key, this.text, this.onTapListener, this.color, this.height = 35, this.width = 190, this.textColor=Colors.white});
  final String? text;
  final VoidCallback? onTapListener;
  final Color? color;
  final double? height;
  final double? width;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapListener,
      child: Container(
        height: height,
        width: width,
        decoration:BoxDecoration(
            color: color!,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Text(text!,style: TextStyle(
              fontFamily: "Roboto",
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w500
          ),),
        ),
      ),
    );
  }
}
