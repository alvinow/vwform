import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class VwExpanderWidget extends StatelessWidget{

  VwExpanderWidget({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          // your image goes here which will take as much height as possible.
          child: ZoomOverlay(
            modalBarrierColor:
            Colors .black12, // Optional
            minScale: 0.5, // Optional
            maxScale: 3.0, // Optional
            animationCurve: Curves
                .fastOutSlowIn, // Defaults to fastOutSlowIn which mimics IOS instagram behavior
            animationDuration: Duration(
                milliseconds:
                300), // Defaults to 100 Milliseconds. Recommended duration is 300 milliseconds for Curves.fastOutSlowIn
            twoTouchOnly: true, // Defaults to false
            onScaleStart:
                () {}, // optional VoidCallback
            onScaleStop:
                () {}, // optional VoidCallback
            child: this.child,
          ),
        ),
      ],
    );
  }
}