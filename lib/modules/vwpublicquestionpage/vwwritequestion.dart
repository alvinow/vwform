import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';

class VwWriteQuestion extends StatefulWidget {
  VwWriteQuestion({required this.appInstanceParam});

  _VwWriteQuestionState createState() => _VwWriteQuestionState();
  final VwAppInstanceParam appInstanceParam;
}

class _VwWriteQuestionState extends State<VwWriteQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Pertanyaan"),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(7, 12, 7, 0),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                                maxLines: 4,
                              ))),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.send),
                              label: Text("Kirim")))
                    ],
                  ),
                  color: Colors.white,
                  constraints: BoxConstraints(
                      minHeight: 200,
                      maxHeight: 200,
                      minWidth: 200,
                      maxWidth: 600),
                )
              ])
        ],
      ),
    );
  }
}
