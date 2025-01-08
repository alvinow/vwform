import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:vwform/modules/mediaviewerpage/mediaviewerpage.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwwidget/materialtransparentroute/materialtransparentroute.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeAppDemo extends StatefulWidget {
  YoutubeAppDemo(
      {super.key,
        required this.videoIds,
        this.autoplay = false,
        this.endSeconds = 0,
        this.startSeconds = 0,
        this.playUsingMediaViewer = false,
        this.appInstanceParam,
        this.articleNode});
  final List<String> videoIds;
  final bool autoplay;
  final double startSeconds;
  final double endSeconds;
  final bool playUsingMediaViewer;
  final VwAppInstanceParam? appInstanceParam;
  final VwNode? articleNode;
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<YoutubeAppDemo> {
  YoutubePlayerController? _controller;
  late bool isOpenVideo;
  late bool isPaused;
  late int videoState; //0,1,2
  late Key currentKey;

  @override
  void initState() {
    super.initState();

    if (widget.key == null) {
      currentKey = UniqueKey();
    } else {
      this.currentKey = widget.key!;
    }
    this.isPaused = true;
    this.isOpenVideo = this.widget.autoplay;
    this.videoState = 0;

    /*
    _controller =YoutubePlayerController.fromVideoId(
      videoId:this.widget.videoIds.elementAt(0),
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true,showVideoAnnotations: false),
    );
*/

    /*
    _controller.cuePlaylist(
      list: this.widget.videoIds,
      listType: ListType.playlist,
      startSeconds: 0,
    );*/
  }

  void initYoutubeController() {
    /*
    _controller =YoutubePlayerController.fromVideoId(
      videoId: this.widget.videoIds.elementAt(0),
      autoPlay: true,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
    */

    _controller = YoutubePlayerController(
      onWebResourceError: (error) {},
      params: const YoutubePlayerParams(
        pointerEvents: PointerEvents.auto,
        showVideoAnnotations: false,
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        strictRelatedVideos: true,
        loop: false,
      ),
    );

    _controller!.setFullScreenListener(
          (isFullScreen) {
        //log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );


    _controller!.loadVideoById(
        startSeconds: this.widget.startSeconds,
        endSeconds: this.widget.endSeconds,
        videoId: this.widget.videoIds.elementAt(0));

    /*
    _controller!.cuePlaylist(
      list: this.widget.videoIds,
      listType: ListType.playlist,
      startSeconds: 0,
    );*/
  }

  @override
  Widget build(BuildContext context) {
    if (isOpenVideo == true) {
      if (videoState == 0 || this._controller == null) {
        this.videoState = 1;
        this.initYoutubeController();
      }

      Widget youtubePlayerWidget = YoutubePlayer(
        key: Key(widget.videoIds.elementAt(0)),
        enableFullScreenOnVerticalDrag: false,
        controller: _controller!,
        aspectRatio: 16 / 9,
      );


      return VisibilityDetector(
        key: this.currentKey,
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (this.isOpenVideo == true) {
            if (visiblePercentage < 60) {
              _controller!.pauseVideo();
              this.isPaused = true;
            } else {
              if (this.isPaused == true) {
                this.isPaused = false;

              }
            }
          }
        },
        child: youtubePlayerWidget,
      );
    } else {
      //ImageNetwork (fitAndroidIos: BoxFit.cover,fullScreen: true,  fitWeb: BoxFitWeb.fill, image:"https://img.youtube.com/vi/"+this.widget.videoIds.elementAt(0)+"/0.jpg",width: 1920,height: 1080,)

      String networkImage = AppConfig.baseUrl +
          r"/youtubeimage?vi=" +
          this.widget.videoIds.elementAt(0);
      return InkWell(
        onTap: () {
          if (this.widget.playUsingMediaViewer == true &&
              this.widget.appInstanceParam != null &&
              this.widget.articleNode != null) {
            Navigator.push(
              context,
              MaterialTransparentRoute(
                  builder: (context) => MediaViewerPage(
                      key: this.currentKey,
                      autoplay: true,
                      mediaLinkNode: VwLinkNode(
                        nodeType: VwNode.ntnRowData,
                        nodeId: this.widget.articleNode!.recordId,
                        /*rendered: VwLinkNodeRendered(
                              renderedDate: DateTime.now(),
                              node: widget.articleNode)*/ ),
                      appInstanceParam: widget.appInstanceParam!)),
            );
          } else {
            setState(() {
              this.isOpenVideo = true;
            });
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: FractionalOffset.center,
                        image: NetworkImage(networkImage),
                      )),
                  alignment: Alignment.center,
                )),

            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double topMargin = constraints.maxWidth * 0.03;
                  double rightMargin = constraints.maxWidth * 0.03;

                  double buttonSize = constraints.maxWidth * 0.2;

                  return Container(
                      color: Colors.black.withAlpha(99),
                      width: buttonSize,
                      height: buttonSize * 0.6,
                      child: Icon(
                        Icons.play_arrow,
                        size: buttonSize * 0.6,
                        color: Colors.white,
                      ));
                }),

            //Image.network("https://img.youtube.com/vi/"+this.widget.videoIds.elementAt(0)+"/0.jpg",scale: 0.5, ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.close();
    }

    super.dispose();
  }
}

class VideoPositionIndicator extends StatelessWidget {
  const VideoPositionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    Widget youtubeControl = StreamBuilder<YoutubeVideoState>(
      stream: controller.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inMilliseconds ?? 0;
        final duration = controller.metadata.duration.inMilliseconds;

        return LinearProgressIndicator(
          value: duration == 0 ? 0 : position / duration,
          minHeight: 1,
        );
      },
    );

    return youtubeControl;
  }
}