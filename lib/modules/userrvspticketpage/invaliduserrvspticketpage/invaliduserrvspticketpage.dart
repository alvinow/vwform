import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvalidUserRvspTicketPage extends StatelessWidget{
  InvalidUserRvspTicketPage({required this.ticketCode});

  String ticketCode;
  @override
  Widget build(BuildContext context) {

    return Row(children: [Icon(Icons.not_interested, color: Colors.blue, ), Text("Maaf, No Tiket "+this.ticketCode+"tidak valid")]);

  }
}