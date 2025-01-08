import 'dart:io';

import 'package:flutter/material.dart';




class VwVideoPlayer extends StatelessWidget {
  VwVideoPlayer({
    required this.file
});

  final File file;

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      //body: VideoPlayer(VideoPlayerController.networkUrl(url))
      body:  Text("Video Player Not Implemented")
    );
  }
}




