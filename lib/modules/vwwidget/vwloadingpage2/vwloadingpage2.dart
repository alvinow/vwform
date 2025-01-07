import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/vwwidget/vwcircularprogressindicator/vwcircularprogressindicator.dart';

class VwLoadingPage2 extends StatelessWidget{

  VwLoadingPage2({required this.caption});

  final String caption;

  Widget _loadingWidget(String caption) {
    List<Widget> children = <Widget>[
      SizedBox(
        width: 60,
        height: 60,
        child: VwCircularProgressIndicator(),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(caption),
      ),
    ];

    return Scaffold (
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ));

  }

  @override
  Widget build(BuildContext context) {
   return _loadingWidget(caption);
  }
}