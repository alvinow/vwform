import 'package:flutter/cupertino.dart';

class VwFormCommand{
  VwFormCommand({
   required this.isClosed,
   required this.message,
   required this.image
});


  bool isClosed;
  String message;
  Widget image;
}