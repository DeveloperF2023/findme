import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:social/constants.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, this.controller});
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: grey200,
        borderRadius: BorderRadius.circular(5)
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: primary),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(EvaIcons.searchOutline),
          hintText: "Search",
          hintStyle: TextStyle(color: grey500,fontSize: 18)
        ),
      ),
    );
  }
}
