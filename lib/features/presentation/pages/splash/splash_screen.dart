import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social/constants.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final timer = Timer(const Duration(seconds: 7), () {
      Navigator.pushNamed(context, NavigationStrings.signIn);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: primary,
          child: const Center(child: Text("FindMe.",style: TextStyle(
              fontFamily: "DancingScript",
              fontSize: 55,
              fontWeight: FontWeight.w900,
              color: Colors.white
          ),)),
        )


    );
  }
}

