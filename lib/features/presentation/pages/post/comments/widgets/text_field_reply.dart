import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../../../constants.dart';

class FormContainerReply extends StatelessWidget {
  const FormContainerReply({super.key, this.controller, this.onSaved, this.validator, this.onFieldSubmitted, this.hintText, this.onTap, this.maxLines,this.suffixIcon, this.fillColor});
  final TextEditingController? controller;
  final String? hintText;
  final FormFieldSetter<String>? onSaved;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final Function()? onTap;
  final int? maxLines;
  final Widget? suffixIcon;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      cursorColor: primary,
      onSaved: onSaved,
      validator: validator,
      maxLines: maxLines,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
          hintText:hintText,
          hintStyle: TextStyle(
              fontFamily: "Roboto",
              color: grey500, fontSize: 14),
          prefixIcon: const Icon(EvaIcons.smilingFace,size: 20,),
          prefixIconColor: grey400,
          fillColor: fillColor,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)),
          contentPadding: const EdgeInsets.only(top: 20, left: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide:
            BorderSide(width: 1.5, color: grey400!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide:
            BorderSide(width: 1.5, color: grey500!),
          ),
          suffixIcon: suffixIcon
      ),
    );
  }
}
