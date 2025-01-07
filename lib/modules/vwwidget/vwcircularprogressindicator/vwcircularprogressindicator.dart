import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class VwCircularProgressIndicator extends StatelessWidget {
  const VwCircularProgressIndicator();
  @override
  Widget build(BuildContext context) {

    return SizedBox(
        width: 40,
        height: 40,
        child: LoadingIndicator(
            indicatorType: Indicator.circleStrokeSpin,

            /// Required, The loading type of the widget
            colors: const [Colors.blue],

            /// Optional, The color collections
            strokeWidth: 4,

            /// Optional, The stroke of the line, only applicable to widget which contains line
            backgroundColor: Colors.transparent,

            /// Optional, Background of the widget
            pathBackgroundColor: Colors.transparent

            /// Optional, the stroke backgroundColor
            ));
  }
}
