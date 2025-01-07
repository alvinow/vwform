import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoRkRiOneline extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    TextStyle redStyle=TextStyle(color: Colors.red,fontWeight: FontWeight.w600);
    TextStyle blackStyle=TextStyle(color: Colors.black,fontWeight: FontWeight.w500);
    double fontSize=18;
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: fontSize ,color:Colors.black),
        children: <TextSpan>[
          TextSpan(text: "R",style: redStyle),
          TextSpan(text: "uang",style: blackStyle),
          TextSpan(text: "K",style: redStyle),
          TextSpan(text: "olaborasi ",style: blackStyle),
          TextSpan(text: "R",style: redStyle),
          TextSpan(text: "uang",style: blackStyle),
          TextSpan(text: "I",style: redStyle),
          TextSpan(text: "novasi",style: blackStyle),


        ],
      ),
    );
  }
}