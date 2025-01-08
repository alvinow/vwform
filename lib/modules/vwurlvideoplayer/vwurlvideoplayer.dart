import 'dart:io';

import 'package:flutter/material.dart';




class VwUrlVideoPlayer extends StatefulWidget {
  VwUrlVideoPlayer({
    required this.url
  });

  //final File file;
  final String url;

  VwUrlVideoPlayerState createState()=> VwUrlVideoPlayerState();
}

class VwUrlVideoPlayerState extends State<VwUrlVideoPlayer>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("Url Video Player not implemented");
  }
}