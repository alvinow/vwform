import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwapicall/apivirtualnode/apivirtualnode.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwformresponseuserpage.dart';
import 'package:vwform/modules/youtubeappdemo/youtubeappdemo.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/widgetutil.dart';

typedef BackPageFunction = void Function(
    VwAppInstanceParam appInstanceParam, BuildContext buildContext);

class MediaViewerPage extends StatefulWidget {
  const MediaViewerPage(
      {super.key,
      required this.mediaLinkNode,
      required this.appInstanceParam,
      this.backPageFunction,
      this.autoplay = false,
      this.mediaPointer});

  final VwLinkNode mediaLinkNode;
  final VwAppInstanceParam appInstanceParam;
  final BackPageFunction? backPageFunction;
  final bool autoplay;
  final VwRowData? mediaPointer;

  static const String fsInstanceInitiated = ' fsInstanceInitiated';
  static const String fsNodeLoaded = ' fsNodeLoaded';
  static const String errorLoadingNode = 'errorLoadingNode';
  static const String fsLoadingNode = 'fsLoadingNode';
  static const String fsNodeNotExits = 'fsNodeNotExits';

  MediaViewerPageState createState() => MediaViewerPageState();
}

class MediaViewerPageState extends State<MediaViewerPage> {
  late Key currentMediaKey;
  VwRowData? currentMediaPointer;
  late bool enableAppBar;

  late String currentLoadStatus;
  VwNode? currentMediaNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.currentMediaNode = NodeUtil.getNode(linkNode: widget.mediaLinkNode);
    this.generateMediaKey();
    this.enableAppBar = true;
    this.currentLoadStatus = MediaViewerPage.fsInstanceInitiated;
    this.currentMediaPointer = widget.mediaPointer;
  }

  void defaultImplementBackFunction(
      VwAppInstanceParam appInstanceParam, BuildContext buildContext) {
    Navigator.pop(buildContext);
  }

  VwRowData? getArticleRowData() {
    VwRowData? returnValue;
    try {
      if (this.currentMediaNode != null &&
          this.currentMediaNode!.content != null &&
          this.currentMediaNode!.content!.rowData != null)
        returnValue = this.currentMediaNode!.content!.rowData!;
    } catch (error) {}
    return returnValue;
  }

  void generateMediaKey() {
    this.currentMediaKey = UniqueKey();
  }

  Widget getYoutubeWidget({VwRowData? videoPointer}) {
    Widget returnValue = Container();
    try {
      String videoId = this
          .getArticleRowData()!
          .getFieldByName("medialinktitle")!
          .valueString!;
      returnValue = YoutubeAppDemo(
        appInstanceParam: this.widget.appInstanceParam,
          autoplay: widget.autoplay, key: currentMediaKey, videoIds: [videoId]);
      if (videoPointer != null) {
        try {
          double startSeconds =
              videoPointer.getFieldByName("startseconds")!.valueNumber!;
          double endSeconds =
              videoPointer.getFieldByName("endseconds")!.valueNumber!;

          returnValue = YoutubeAppDemo(
              appInstanceParam: this.widget.appInstanceParam,
              key: currentMediaKey,
              startSeconds: startSeconds,
              endSeconds: endSeconds,
              autoplay: true,
              videoIds: [videoId]);
        } catch (error) {}
      }
    } catch (error) {}
    return returnValue;
  }

  bool getEnableCommentBoxBottomSide() {
    bool returnValue = false;
    try {
      if (this.widget.appInstanceParam.loginResponse != null &&
          this.widget.appInstanceParam.loginResponse!.userInfo != null) {
        returnValue = true;
      }
    } catch (error) {}
    return returnValue;
  }

  void implementCommandToParentFunction(VwRowData callParameter) {
    generateMediaKey();
    this.currentMediaPointer = callParameter;
    setState(() {});
  }

  Widget getFeedFolderNode() {
    /*
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true,),
      body:Text("test App Bar")
    );*/

    return VwFormResponseUserPage(
      showPrintButton: false,,
      mainLogoImageAsset: this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
      commandToParentFunction: this.implementCommandToParentFunction,
      parentArticleNode: NodeUtil.getNode(linkNode: widget.mediaLinkNode),
      boxTopRowWidgetMode: NodeListView.btrDisabled,
      bottomSideMode: getEnableCommentBoxBottomSide()
          ? NodeListView.bsmVideoPointerBox
          : NodeListView.bsmDisabled,
      zeroDataCaption: "(Belum Ada Janji)",
      enableAppBar: true,
      showBackArrow: false,
      enableScaffold: true,
      showUserInfoIcon: false,
      showLoginButton: false,
      toolbarHeight: 35,
      toolbarPadding: 3,
      rowUpperPadding: 35,
      mainHeaderTitleTextColor: Colors.black,
      mainHeaderBackgroundColor: Colors.white,
      enableCreateRecord: false,
      mainLogoTextCaption: "Janji",
      folderNodeId: "15b492f8-e4fb-496d-a999-a4afc39bc184",
      key: this.widget.key,
      appInstanceParam: widget.appInstanceParam,
      showReloadButton: false,
      extendedApiCallParam: VwRowData(recordId: Uuid().v4(), fields: [
        VwFieldValue(
            fieldName: "parentarticlenodeid",
            valueString: this.widget.mediaLinkNode.nodeId)
      ]),
    );
  }

  String getLoginSessionId() {
    String returnValue = this.widget.appInstanceParam.baseAppConfig.generalConfig.loginSessionGuestUserId;
    try {
      returnValue = widget.appInstanceParam.loginResponse!.loginSessionId!;
    } catch (error) {}

    return returnValue;
  }

  Future<VwNode?> _asyncLoadNode() async {
    VwNode? returnValue;
    this.currentLoadStatus = MediaViewerPage.fsLoadingNode;
    try {
      returnValue = this.currentMediaNode;
      if (returnValue == null) {
        VwRowData apiCallParam = VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
            fieldName: "nodeId",
            valueString: APIVirtualNode.exploreQuestionFeed,
          ),
          VwFieldValue(
              fieldName: "parentarticlenodeid",
              valueString: widget.mediaLinkNode.nodeId),
        ]);

        VwNodeRequestResponse nodeRequestResponse =
            await RemoteApi.nodeRequestApiCall(
              baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
               graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
                apiCallId: "getNodes",
                apiCallParam: apiCallParam,
                loginSessionId: this.getLoginSessionId());

        if (nodeRequestResponse.httpResponse != null &&
            nodeRequestResponse.httpResponse!.statusCode == 200) {
          if (nodeRequestResponse.renderedNodePackage != null &&
              nodeRequestResponse.renderedNodePackage!.parentArticleNode !=
                  null) {
            this.currentMediaNode =
                nodeRequestResponse.renderedNodePackage!.parentArticleNode!;
            returnValue = this.currentMediaNode;

            try {
              if (returnValue!.recordId != this.widget.mediaLinkNode.nodeId) {
                for (int la = 0;
                    la <
                        nodeRequestResponse
                            .renderedNodePackage!.renderedNodeList!.length;
                    la++) {
                  VwNode currentNode = nodeRequestResponse
                      .renderedNodePackage!.renderedNodeList!
                      .elementAt(la);

                  if (currentNode.recordId ==
                      this.widget.mediaLinkNode.nodeId) {
                    this.currentMediaPointer = currentNode.content.rowData;
                    break;
                  }
                }
              }
            } catch (error) {}

            this.currentLoadStatus = MediaViewerPage.fsNodeLoaded;
          } else {
            this.currentLoadStatus = MediaViewerPage.fsNodeNotExits;
          }
        } else {
          this.currentLoadStatus = MediaViewerPage.errorLoadingNode;
        }
      } else {
        this.currentLoadStatus = MediaViewerPage.fsNodeLoaded;
      }
    } catch (error) {}

    return returnValue;
  }

  Widget _reloadFormWithScaffold(String caption) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(child: this._reloadForm(caption)));
  }

  Widget _reloadForm(String caption) {
    Widget body = InkWell(
        onTap: () {
          setState(() {
            this.currentLoadStatus = MediaViewerPage.fsLoadingNode;
          });
        },
        child: Container(
            color: Colors.blue,
            child: Icon(Icons.refresh, color: Colors.white, size: 60)));

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        body,
        Container(margin: EdgeInsets.all(10), child: Text(caption))
      ],
    );
  }

  Widget _builReloadForm(String caption) {
    return this._reloadFormWithScaffold(caption);
  }

  Widget buildMediaViewer() {
    return LayoutBuilder(builder: (buildContext, boxConstraint) {
      bool isPortrait = true;

      double ratio = boxConstraint.maxWidth / boxConstraint.maxHeight;

      if (ratio > 1.2) {
        isPortrait = false;
      }

      String title =
          this.getArticleRowData()!.getFieldByName("title")!.valueString!;
      if(this.currentMediaPointer!=null)
        {
          try {
            title =
            this.currentMediaPointer!.getFieldByName("title")!.valueString!;
          }
          catch(error)
      {

      }
        }

      if (isPortrait) {
        //this.enableAppBar=true;

        double youtubeHeight = boxConstraint.maxWidth / (16 / 9);
        double youtubeWidth = boxConstraint.maxWidth;
        double ratio = youtubeHeight / boxConstraint.maxHeight;
        if (ratio > 0.6) {
          youtubeWidth = youtubeWidth / 2;
        }

        return Scaffold(
            key: this.widget.key,
            appBar: this.enableAppBar == true
                ? PreferredSize(
                    preferredSize: Size.fromHeight(50.0),
                    child: AppBar(
                      backgroundColor: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.primaryColor,
                      title: Text(
                        title,
                        style: TextStyle(color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.textColor),
                      ),
                      leading: InkWell(
                        onTap: () {
                          if (widget.backPageFunction != null) {
                            widget.backPageFunction!(
                                widget.appInstanceParam, context);
                          } else {
                            this.defaultImplementBackFunction(
                                widget.appInstanceParam, context);
                          }
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.textColor,
                        ),
                      ),
                    ))
                : null,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(maxWidth: youtubeWidth),
                    child: this
                        .getYoutubeWidget(videoPointer: currentMediaPointer)),
                Expanded(
                  child: Container(
                    child: getFeedFolderNode(),
                  ),
                )
              ],
            ));
      } else {
        double youtubeMaxWidth =
            (boxConstraint.maxHeight * (16 / 9)) - (35 * 16 / 9);

        double youtubeMaxHeighth = boxConstraint.maxHeight;

        if (ratio < 2.4) {
          youtubeMaxWidth = (1 - (0.45 * (2.4 - ratio))) * youtubeMaxWidth;
        }

        return Scaffold(
            key: this.widget.key,
            appBar: this.enableAppBar == true
                ? PreferredSize(
                    preferredSize: Size.fromHeight(35.0),
                    child: AppBar(
                      backgroundColor: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.primaryColor,
                      title: Text(
                        title,
                        style: TextStyle(color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.textColor),
                      ),
                      leading: InkWell(
                        onTap: () {
                          if (widget.backPageFunction != null) {
                            widget.backPageFunction!(
                                widget.appInstanceParam, context);
                          } else {
                            this.defaultImplementBackFunction(
                                widget.appInstanceParam, context);
                          }
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.textColor,
                        ),
                      ),
                    ))
                : null,
            body: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    LayoutBuilder(builder: (buildContext, boxConstraintColumn) {
                      return Container(
                          alignment: Alignment.topCenter,
                          constraints:
                              BoxConstraints(maxWidth: youtubeMaxWidth),
                          child: this.getYoutubeWidget(
                              videoPointer: currentMediaPointer));
                    })
                  ],
                ),
                Expanded(child: getFeedFolderNode())
              ],
            ));
      }
    });
  }

  Widget _buildLoadingWidget(String caption) {
    return WidgetUtil.loadingWidget(caption);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VwNode?>(
        key: this.widget.key,
        future: this._asyncLoadNode(),
        builder: (context, snapshot) {
          if (snapshot.hasData == true) {
            if (this.currentLoadStatus == MediaViewerPage.fsNodeLoaded) {
              return this.buildMediaViewer();
            } else if (this.currentLoadStatus ==
                MediaViewerPage.errorLoadingNode) {
              return this
                  ._builReloadForm("Error : Can't connect to server");
            } else {
              return _buildLoadingWidget("Loading from server...");
            }
          } else {
            return _buildLoadingWidget("Loading from server...");
          }
        });
  }
}
