import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';


class FirstScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3),()=>Navigator.pushAndRemoveUntil
      (
      context,
      MaterialPageRoute(
          builder: (context)=> const LogIn(title: 'login',
          )
      ),(Route<dynamic> route) => false, ));
    super.initState();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/kyan.png',width: 150,),
          SizedBox(height: 8,),
          Text('Safe Attendace',  style: GoogleFonts.josefinSans(
            textStyle: const TextStyle(
              color: Color(0xff164276),
              fontWeight: FontWeight.w900,
              fontSize: 34,
            ),
          ))
        ],
      ),));


}
