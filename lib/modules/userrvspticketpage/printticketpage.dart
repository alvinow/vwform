import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class PrintTicketPage extends StatefulWidget{
  PrintTicketPage({
    required this.printedWidget,
    this.width=200,
    this.height=420,
    required this.outputFileName
});

  Widget printedWidget;
  double width;
  double height;
  String outputFileName;

  PrintTicketPageState createState()=>PrintTicketPageState();
}

class PrintTicketPageState extends State<PrintTicketPage>{

  @override
  Widget build(BuildContext context) {
    return Text("Error:Print ticket page not implemented");
  }
}