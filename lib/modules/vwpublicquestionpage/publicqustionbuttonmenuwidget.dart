import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/appconfig.dart';


typedef OnTapButton = void Function();

class PublicQuestionButtonMenuWidget extends StatefulWidget{

  PublicQuestionButtonMenuWidget({
   required this.caption,
   required this.onTapButton,

    this.textColor=Colors.white,
    this.primaryColor=AppConfig.primaryColor,
    this.fontSize=13
});

  final String caption;
  final OnTapButton onTapButton;
  final Color primaryColor;
  final Color textColor;
  final double fontSize;


  PublicQuestionButtonMenuWidgetState createState()=>PublicQuestionButtonMenuWidgetState();
}

class PublicQuestionButtonMenuWidgetState extends State<PublicQuestionButtonMenuWidget>{
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: widget.onTapButton,  child:Container(alignment: Alignment.center, padding: EdgeInsets.fromLTRB(5, 0, 5, 0),margin: EdgeInsets.fromLTRB(5, 0, 5, 0),  color: widget.primaryColor, child: Text(this.widget.caption,style: TextStyle(fontSize: widget.fontSize,color: widget.textColor),))) ;
   return TextButton(style: TextButton.styleFrom(backgroundColor: widget.primaryColor), onPressed: widget.onTapButton, child: Text(widget.caption,style: TextStyle(fontSize: widget.fontSize, color: widget.textColor),));
  }
}