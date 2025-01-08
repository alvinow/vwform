import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icon.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwdataformattimestamp/vwdataformattimestamp.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfieldfilestorage/vwfieldfilestorage.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/pagecoordinator/bloc/pagecoordinator_bloc.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwcommentsnodepage/vwcommentsnodepage.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediainstanceparam/vwmultimediaviewerinstanceparam.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediaviewer.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediaviewerparam/vwmultimediaviewerparam.dart';
import 'package:vwform/modules/vwwidget/locationwidget/vwshowlocationwidget/vwshowlocationwidget.dart';
import 'package:vwform/modules/vwwidget/materialtransparentroute/materialtransparentroute.dart';
import 'package:vwform/modules/vwwidget/rowviewermaterial/vwinstagramrowviewermaterial/vwinstagrambottommodalmenu.dart';
import 'package:vwform/modules/youtubeappdemo/youtubeappdemo.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/profilepictureutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwQuestionArticleRowViewerMaterial extends StatefulWidget {
  VwQuestionArticleRowViewerMaterial(
      {required super.key,
      required this.appInstanceParam,
      required this.username,
      this.title,
      this.medialinktitle,
      this.imagetitle,
      this.imagecontent,
      required this.cardTapper,
      this.timestamp,
      this.htmlcontent,
      required this.articletype,
      this.urllink,
      this.location,
      required this.maincategory,
      required this.releaseStatus,
      this.showAccountInfo = true,
      this.subTitle,
      this.caption,
      this.rowNode,
      this.isInitiatorQuestion = true,
      this.commandToParentFunction});

  final InkWell cardTapper;
  final VwAppInstanceParam appInstanceParam;
  final String username;
  final VwDataFormatTimestamp? timestamp;
  final String? title;
  final String? subTitle;
  final String? caption;
  final String? medialinktitle;
  final VwFieldFileStorage? imagetitle;
  final VwFieldFileStorage? imagecontent;
  final String? htmlcontent;
  final String articletype;
  final String? urllink;
  final String maincategory;
  final String releaseStatus;
  final bool showAccountInfo;
  final VwRowData? location;
  final VwNode? rowNode;
  final bool isInitiatorQuestion;
  final CommandToParentFunction? commandToParentFunction;

  VwQuestionArticleRowViewerMaterialState createState() =>
      VwQuestionArticleRowViewerMaterialState();
}

class VwQuestionArticleRowViewerMaterialState
    extends State<VwQuestionArticleRowViewerMaterial> {
  late bool isCurrentUserThumbUp;
  late bool isTitleCompacted;
  late double imageRatio;
  late double frameHeight;
  late Key formKey;

  @override
  void initState() {
    super.initState();
    this.formKey = UniqueKey();
    this.imageRatio = 1.0;
    this.frameHeight = 300;
    isTitleCompacted = true;
    isCurrentUserThumbUp = false;
  }

  VwRowData? getCurrentUserResponseRowData() {
    VwRowData? returnValue;
    try {
      return this
          .widget
          .rowNode!
          .content!
          .rowData!
          .getFieldByName("currentUserResponseNode")!
          .valueRowData;
    } catch (error) {}
    return returnValue;
  }

  String? getCurrentUserResponseId() {
    String? returnValue;
    try {
      VwRowData? rowData = this.getCurrentUserResponseRowData();
      if (rowData != null) {
        VwFieldValue? responseIdFieldValue =
            rowData!.getFieldByName("responseId");
        if (responseIdFieldValue != null &&
            responseIdFieldValue!.valueString != null) {
          returnValue = responseIdFieldValue.valueString;
        }
      }
    } catch (error) {}
    return returnValue;
  }

  Widget getTopWidget() {
    Widget returnValue = Container();
    try {
      if (this.widget.articletype == "imagebanner" &&
          this.isEditable() == false) {
      } else {
        returnValue = Container(
            alignment: Alignment.centerLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  this.widget.showAccountInfo == false
                      ? Container()
                      : Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: getUsernameWidget(size: 35)),
                  this.getEditButtonWidget()
                ]));
      }
    } catch (error) {
      print("Error catched on getTopWidget(): " + error.toString());
    }
    return returnValue;
  }

  Widget getCurrentUserThumbupWidget() {
    if (isCurrentUserThumbUp == true) {
      return InkWell(
          onTap: () {
            setState(() {
              this.isCurrentUserThumbUp = false;
            });
          },
          child: Icon(
            Icons.thumb_up,
            color: Colors.red,
          ));
    } else {
      return InkWell(
          onTap: () {
            setState(() {
              this.isCurrentUserThumbUp = true;
            });
          },
          child: Icon(Icons.thumb_up_alt_outlined, color: Colors.black));
    }
  }

  void askToLogin() {
    double boxHeight = 160;
    double boxWidth = 300;

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        useSafeArea: false,
        constraints: BoxConstraints(maxWidth: boxWidth),
        context: context,
        builder: (context) {
          return LayoutBuilder(builder: (buildContext, constraintBox) {
            double topMargin = 0;
            try {
              topMargin = (constraintBox.maxHeight - boxHeight) / 2;
            } catch (error) {}
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                  child: Container(
                margin: EdgeInsets.fromLTRB(0, topMargin, 0, 0),
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                color: Colors.white,
                //constraints: BoxConstraints(maxHeight: boxHeight ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(
                                "Silahkan Login terlebih dahulu untuk memberi respon.")),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => AppConfig.primaryColor),
                              side: MaterialStateProperty.resolveWith(
                                  (states) =>
                                      BorderSide(color: AppConfig.textColor)),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);

                              this.widget.appInstanceParam.appBloc.add(
                                  LoginPagecoordinatorEvent(
                                      timestamp: DateTime.now()));
                            },
                            icon: Icon(
                              Icons.person,
                              color: AppConfig.textColor,
                            ),
                            label: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppConfig.textColor),
                            )),
                        TextButton.icon(
                            style: ButtonStyle(
                              side: MaterialStateProperty.resolveWith(
                                  (states) => BorderSide(
                                      color: AppConfig.primaryColor)),
                              textStyle: MaterialStateProperty.resolveWith(
                                  (states) =>
                                      TextStyle(color: AppConfig.primaryColor)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.navigate_next,
                              color: AppConfig.primaryColor,
                            ),
                            label: Text(
                              "Lanjut",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppConfig.primaryColor),
                            )),
                      ],
                    )
                  ],
                ),
              )),
            );
          });
        });
  }

  Widget getInfoBar() {
    Widget returnValue = Container();
    try {
      returnValue = Container(
          child: Row(
        children: [
          Container(
            child: Row(
              children: [
                SizedBox(width: 3),
                InkWell(
                    onTap: () async {
                      if (this.widget.appInstanceParam.loginResponse != null) {
                        VwRowData? userResponseRowData =
                            this.getCurrentUserResponseRowData();

                        if (userResponseRowData == null) {
                          userResponseRowData = VwRowData(
                              collectionName: "userresponsenodeformdefinition",
                              //creatorUserId: this.widget.appInstanceParam.loginResponse!.userInfo!.user.recordId,
                              recordId: Uuid().v4(),
                              fields: [
                                VwFieldValue(
                                    fieldName: "nodeId",
                                    valueString: this.widget.rowNode!.recordId),
                                VwFieldValue(
                                    fieldName: "userId",
                                    valueString: this
                                        .widget
                                        .appInstanceParam
                                        .loginResponse!
                                        .userInfo!
                                        .user
                                        .recordId),
                                VwFieldValue(
                                    fieldName: "responseId",
                                    valueString: "like"),
                              ]);

                          this.widget.rowNode!.content.rowData!.fields!.add(
                              VwFieldValue(
                                  fieldName: "currentUserResponseNode",
                                  valueTypeId: VwFieldValue.vatValueRowData,
                                  valueRowData: userResponseRowData));
                        } else {
                          userResponseRowData
                              .getFieldByName("responseId")!
                              .valueString = "like";
                        }

                        this.widget.appInstanceParam.appBloc.sinkSyncRowData(
                            rowData: userResponseRowData,
                            appInstanceParam: this.widget.appInstanceParam);

                        setState(() {});
                      } else {
                        this.askToLogin();
                      }
                    },
                    child: this.getCurrentUserResponseId().toString() == "like"
                        ? LineIcon.thumbsUp(
                            color: Colors.blue,
                          )
                        : LineIcon.thumbsUp(
                            size: 25,
                            color: Colors.black54,
                          )),
              ],
            ),
            height: 30,
            //width: 100,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 240, 240, 240),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                bottomLeft: Radius.circular(0),
              ),
              border: Border.all(
                width: 1,
                color: Colors.black12,
                style: BorderStyle.solid,
              ),
            ),
          ),
          Container(
            child: Row(children: [
              SizedBox(width: 3),
              InkWell(
                  onTap: () {
                    if (this.widget.appInstanceParam.loginResponse != null) {
                      VwRowData? userResponseRowData =
                          this.getCurrentUserResponseRowData();

                      if (userResponseRowData == null) {
                        userResponseRowData = VwRowData(
                            collectionName: "userresponsenodeformdefinition",
                            //creatorUserId: this.widget.appInstanceParam.loginResponse!.userInfo!.user.recordId,
                            recordId: Uuid().v4(),
                            fields: [
                              VwFieldValue(
                                  fieldName: "nodeId",
                                  valueString: this.widget.rowNode!.recordId),
                              VwFieldValue(
                                  fieldName: "userId",
                                  valueString: this
                                      .widget
                                      .appInstanceParam
                                      .loginResponse!
                                      .userInfo!
                                      .user
                                      .recordId),
                              VwFieldValue(
                                  fieldName: "responseId",
                                  valueString: "dislike"),
                            ]);

                        this.widget.rowNode!.content.rowData!.fields!.add(
                            VwFieldValue(
                                fieldName: "currentUserResponseNode",
                                valueTypeId: VwFieldValue.vatValueRowData,
                                valueRowData: userResponseRowData));
                      } else {
                        userResponseRowData
                            .getFieldByName("responseId")!
                            .valueString = "dislike";
                      }

                      this.widget.appInstanceParam.appBloc.sinkSyncRowData(
                          rowData: userResponseRowData,
                          appInstanceParam: this.widget.appInstanceParam);

                      setState(() {});
                    } else {
                      this.askToLogin();
                    }
                  },
                  child: this.getCurrentUserResponseId().toString() == "dislike"
                      ? LineIcon.thumbsDown(
                          size: 25,
                          color: Colors.red,
                        )
                      : LineIcon.thumbsDown(
                          size: 25,
                          color: Colors.black54,
                        )),
              SizedBox(width: 3),
            ]),
            height: 30,
            //width: 33,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              border: Border.all(
                width: 1,
                color: Colors.black12,
                style: BorderStyle.solid,
              ),
            ),
          ),
          /*
            TextButton.icon(
                style: OutlinedButton.styleFrom(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                  ),


                  side: BorderSide(color: Colors.black26, width: 2), //<-- SEE HERE
                ),
                label:Text("Dukung Naik - 1,4 rb",style: TextStyle(color: Colors.grey),),
                onPressed: (){

            }, icon:Icon(Icons.arrow_upward,color:Colors.blue) ),*/

          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () async {
              if (this.widget.rowNode != null) {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  useSafeArea: false,
                  context: context,
                  builder: (context) => VwCommentsNodePage(
                      key: formKey,
                      parentarticlenodeid: this.widget.rowNode!.recordId,
                      appInstanceParam: widget.appInstanceParam),
                );
              }
            },
            icon: Icon(Icons.chat_bubble_outline, color: Colors.black54),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ));
    } catch (error) {}
    return returnValue;
  }

  Widget getCreatedTime() {
    TextStyle dateStyle = TextStyle(color: Colors.black54, fontSize: 13);

    Widget returnValue = Text(
      "unknown",
      style: dateStyle,
    );

    if (this.widget.timestamp != null) {
      returnValue = Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            VwDateUtil.indonesianFormatLocalTimeZone(
                this.widget.timestamp!.created),
            style: dateStyle,
          ));
    }
    return returnValue;
  }

  Widget? getLocationWidget({double size = 40}) {
    Widget? returnValue;
    try {
      if (this.widget.location != null) {
        //Size screenSize = MediaQuery.of(context).size;
        //double maxWidth = screenSize.width - 120;

        returnValue = Container(
            //constraints: BoxConstraints(maxWidth: maxWidth),
            child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialTransparentRoute(
                  builder: (context) => VwShowLocationWidget(
                        location: this.widget.location!,
                      )),
            );
          },
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            this
                .widget
                .location!
                .getFieldByName("title")!
                .valueString
                .toString(),
            style: TextStyle(fontSize: size * 0.4),
          ),
        ));
      }
    } catch (error) {}
    return returnValue;
  }

  Widget getProfilePicture({double size = 40}) {
    Widget returnValue =
        Stack(alignment: AlignmentDirectional.center, children: [
      Icon(
        Icons.circle,
        color: Colors.grey,
        size: size,
      ),
      Icon(
        Icons.person,
        size: size * 0.7,
        color: Colors.white,
      )
    ]);

    try {
      returnValue = ProfilePictureUtil.getUserProfilePictureFromNode(
         appInstanceParam: this.widget.appInstanceParam,
          size: 25, node: this.widget.rowNode!);
    } catch (error) {
      print("Error catched: " + error.toString());
    }

    return returnValue;
  }

  Widget getUsernameWidget({double size = 40}) {
    if (this.getLocationWidget() != null) {
      return Row(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
              child: getProfilePicture(size: size)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  child: Text(
                    this.widget.username,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: size * 0.4,
                        fontWeight: FontWeight.w500),
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: this.getLocationWidget(size: size)!)
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
              child: this.getProfilePicture(size: size)),
          Container(
              margin: EdgeInsets.fromLTRB(3, 3, 0, 0),
              child: Text(
                this.widget.username,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.w600),
              ))
        ],
      );
    }
  }

  Widget getImageTitleWidget({bool fullHeightImage = false}) {
    try {
      if (true) {
        try {
          //double imageRatio = 1.0;

          double maxImageRatio = 6;
          double minImageRatio = 0.166;

          try {
            imageRatio = this
                    .widget
                    .imagetitle!
                    .serverFile!
                    .elementAt(0)
                    .clientEncodedFile!
                    .fileInfo
                    .imageFileInfo!
                    .width /
                this
                    .widget
                    .imagetitle!
                    .serverFile!
                    .elementAt(0)
                    .clientEncodedFile!
                    .fileInfo
                    .imageFileInfo!
                    .height;

            if (imageRatio > maxImageRatio) {
              imageRatio = maxImageRatio;
            } else if (imageRatio < minImageRatio) {
              imageRatio = minImageRatio;
            }
          } catch (error) {
            print(
                "Error catched on Widget getImageTitleWidget({bool fullHeightImage = false}):" +
                    error.toString());
          }

          Size screenSize = MediaQuery.of(context).size;
          Orientation orientation = MediaQuery.of(context).orientation;

          if (fullHeightImage == true) {
            frameHeight = screenSize.width.toDouble() / imageRatio;
          } else {
            frameHeight = (screenSize.shortestSide * 0.75);
          }

          if (orientation == Orientation.portrait) {
            //frameHeight = screenSize.shortestSide;
            if (imageRatio != null && screenSize.shortestSide != null) {
              frameHeight =
                  screenSize.shortestSide.toDouble() / imageRatio!.toDouble();
            }
          }

          print("Frame Height=" + frameHeight.toString());
        } catch (error) {
          print(
              "Error catched on Widget getImageTitleWidget({bool fullHeightImage = false}):" +
                  error.toString());
        }
      }

      if (this.widget.imagetitle != null &&
          this.widget.imagetitle!.serverFile != null &&
          this.widget.imagetitle!.serverFile!.length > 0) {
        Widget imageTitleWidget = Container(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            Size screenSize = MediaQuery.of(context).size;
            Orientation orientation = MediaQuery.of(context).orientation;

            double smallestSide = constraints.maxWidth;

            if (constraints.maxHeight < smallestSide) {
              smallestSide = constraints.maxHeight;
            }

            frameHeight = constraints.maxWidth / imageRatio;
            /*
              if (fullHeightImage == true) {
                frameHeight = constraints.maxWidth / imageRatio;
              } else {
                frameHeight = (smallestSide * 0.75);
              }*/

            if (orientation == Orientation.portrait) {
              //frameHeight = screenSize.shortestSide;
              if (imageRatio != null && screenSize.shortestSide != null) {
                frameHeight = smallestSide / imageRatio!.toDouble();
              }
            }

            return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black12),
                    top: BorderSide(width: 1, color: Colors.black12),
                  ),
                ),
                height: frameHeight,
                child: VwMultimediaViewer(
                    key: this.widget.key,
                    usedAsWidgetComponent: true,
                    appInstanceParam: this.widget.appInstanceParam,
                    multimediaViewerParam: VwMultimediaViewerParam(),
                    multimediaViewerInstanceParam:
                        VwMultimediaViewerInstanceParam(
                            remoteSource: this.widget.imagetitle!.serverFile!,
                            fileSource: [],
                            memorySource: [])));
          }),
        );

        if (this.widget.urllink != null) {
          imageTitleWidget = InkWell(
            child: imageTitleWidget,
            onTap: () async {
              final Uri url = Uri.parse(this.widget.urllink!);

              await launchUrl(url);
            },
          );
        }

        return imageTitleWidget;
      } else {
        return Container();
      }
    } catch (error) {}
    return Container();
  }

  TextStyle getDefaultTitleTextStyle() {
    return TextStyle(fontSize: 17, color: Colors.black);
  }

  TextStyle getQuestionTextStyle() {
    return TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);
  }

  TextStyle getCommentTextStyle() {
    return TextStyle(
        fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black);
  }

  Widget getActionRowWidget() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 8, 0, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // this.getCurrentUserThumbupWidget(),
            //SizedBox(width: 25,),
            Icon(Icons.mode_comment_outlined),
            SizedBox(
              width: 25,
            ),

            InkWell(
                onTap: () async {
                  String url = AppConfig.baseUrl +
                      r"?articleId=" +
                      widget.rowNode!.recordId;

                  await Clipboard.setData(ClipboardData(text: url));

                  Fluttertoast.showToast(
                      msg: "Share Link has been copied to Clipboard",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.orange,
                      textColor: Colors.white,
                      webBgColor: "linear-gradient(to right, #FF6D0A, #FF6D0A)",
                      webPosition: "center",
                      fontSize: 16.0);
                },
                child: Icon(Icons.share))
          ],
        ));
  }

  bool isEditable() {
    bool returnValue = false;
    try {
      if (this.widget.appInstanceParam.loginResponse != null &&
          this.widget.appInstanceParam.loginResponse!.userInfo != null &&
          this
                  .widget
                  .appInstanceParam
                  .loginResponse!
                  .userInfo!
                  .user
                  .mainRoleUserGroupId ==
              AppConfig.adminticketMainRoleUserGroupId) {
        returnValue = true;
      } else {
        returnValue = this.widget.appInstanceParam.loginResponse != null &&
            this.widget.appInstanceParam.loginResponse!.userInfo != null &&
            this.widget.appInstanceParam.loginResponse!.userInfo!.user !=
                null &&
            this
                    .widget
                    .appInstanceParam
                    .loginResponse!
                    .userInfo!
                    .user
                    .username
                    .toLowerCase() ==
                this.widget.username.toLowerCase();
      }
    } catch (error) {}
    return returnValue;
  }

  Widget getEditButtonWidget() {
    Widget returnValue = Container();
    try {
      bool enableEdit = this.isEditable();

      returnValue = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
                onTap: () async {
                  //on edit  this.widget.cardTapper.onTap

                  showModalBottomSheet(
                    useRootNavigator: true,
                    context: this.context,
                    builder: (context) => VwInstagramBottomModalMenu(
                        key: UniqueKey(),
                        rowNode: widget.rowNode,
                        enableEdit: enableEdit,
                        editArticleCardTapper: this.widget.cardTapper),
                  );
                },
                child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                    child: Icon(
                      Icons.more_vert_outlined,
                      size: 24,
                      color: Colors.black87,
                    )))
          ]);
    } catch (error) {}
    return returnValue;
  }

  Widget getCaptionWidget({bool compacted = true}) {
    Widget returnValue = Container();
    try {
      String captionText =
          this.widget.title == null ? "" : this.widget.title.toString();
      bool textFullyShowed = true;
      if (compacted == true) {
        int trimlimit = captionText.length;
        if (trimlimit > 500) {
          textFullyShowed = false;
          captionText = captionText.substring(0, 500);
        } else {
          captionText = captionText.toString();
        }
      }

      /*
    TextSpan userTextSpan = TextSpan(
        text: this.widget.username.toString(),
        style: TextStyle(fontWeight: FontWeight.w600));*/
      TextSpan spaceTextSpan = TextSpan(text: " ");
      TextSpan titleTextSpan = TextSpan(text: captionText);
      TextSpan readMoreTextSpan = TextSpan(
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              setState(() {
                isTitleCompacted = false;
              });
            },
          text: "...selengkapnya",
          style: TextStyle(color: Colors.grey));

      List<TextSpan> textLines = [spaceTextSpan, titleTextSpan];

      // return Text("<username>");

      int maxLines = 1000;

      if (compacted == true && textFullyShowed == false) {
        textLines.add(readMoreTextSpan);
        maxLines = 10;
      }

      returnValue = Container(
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          alignment: Alignment.centerLeft,
          child: RichText(
            maxLines: maxLines,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.visible,
            text: TextSpan(
                //style: DefaultTextStyle.of(context).style,
                style: this.widget.isInitiatorQuestion == true
                    ? this.getQuestionTextStyle()
                    : this.getCommentTextStyle(),
                children: textLines),
          ));
    } catch (error) {
      print(
          "Error catched on Widget getCaptionWidget({bool compacted = true}): " +
              error.toString());
    }
    return returnValue;
  }

  Widget getMediaLinkTitleWidget(
      {bool? fullWidth = false,
      double sizeRatio = 1,
      String? videoId,
      double startseconds = 0,
      double endseconds = 0}) {
    double frameHeight = 300;

    try {
      if (videoId != null) {
        Size screenSize = MediaQuery.of(context).size;
        Orientation orientation = MediaQuery.of(context).orientation;

        if (fullWidth == true) {
          frameHeight = screenSize.width * 9 / 16;

          if (this.widget.commandToParentFunction != null &&
              this.widget.rowNode != null &&
              this.widget!.rowNode!.content != null &&
              this.widget!.rowNode!.content!.rowData != null) {
            return InkWell(
              onTap: () {
                this.widget.commandToParentFunction!(
                    this.widget!.rowNode!.content!.rowData!);
              },
              child: Container(
                  child: Icon(FontAwesomeIcons.youtube, color: Colors.red)),
            );
          } else {
            return SizedBox(
                height: frameHeight,
                width: screenSize.width,
                child: YoutubeAppDemo(
                    startSeconds: startseconds,
                    endSeconds: endseconds,
                    videoIds: [videoId!, videoId!]));
          }
        } else {
          frameHeight = screenSize.shortestSide * 0.75;

          if (orientation == Orientation.portrait) {
            frameHeight = screenSize.shortestSide * (9.0 / 16.0);
          }

          return LayoutBuilder(builder:
              (BuildContext buildContext, BoxConstraints boxConstraints) {
            double? height = boxConstraints.maxHeight;
            double? width = boxConstraints.maxWidth;
            double ratio = 16 / 9;
            double revRatio = 9 / 16;

            String heightString = height.toString();
            if (heightString == "Infinity") {
              height = revRatio * width;
            } else if (width.toString() == "Infinity" && height != null) {
              width = height * ratio;
            }

            height = height * sizeRatio;
            width = width * sizeRatio;

            if (this.widget.commandToParentFunction != null &&
                this.widget.rowNode != null &&
                this.widget!.rowNode!.content != null &&
                this.widget!.rowNode!.content!.rowData != null) {
              return InkWell(
                onTap: () {
                  this.widget.commandToParentFunction!(
                      this.widget!.rowNode!.content!.rowData!);
                },
                child: Container(
                    child: Icon(FontAwesomeIcons.youtube, color: Colors.red)),
              );
            } else {
              return SizedBox(
                  height: height,
                  width: width,
                  child: YoutubeAppDemo(
                      startSeconds: startseconds,
                      endSeconds: endseconds,
                      autoplay: false,
                      videoIds: [videoId!, videoId!]));
            }
          });
        }
      }
      return SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [Icon(Icons.ondemand_video), Icon(Icons.question_mark)],
        ),
      );
    } catch (error) {
      print("Error catched on getMediaLinkTitleWidget=" + error.toString());
    }

    return this.widget.caption != null && this.widget.caption!.length > 0
        ? Text(this.widget.caption!)
        : Container();
  }

  Widget getMediaTitleWidget() {
    Widget returnValue = Container();
    try {
      if (this.widget.articletype == "youtube" ||
          this.widget.articletype == "fullArticleVideo") {
        returnValue =
            this.getMediaLinkTitleWidget(videoId: this.widget.medialinktitle);
      } else if (this.widget.articletype == "videopointer") {
        String? mediaLinkTitle;
        double startseconds = 0;
        double endseconds = 0;
        try {
          VwNode? parentArticleNode = NodeUtil.getNode(
              linkNode: this
                  .widget
                  .rowNode!
                  .content!
                  .rowData!
                  .getFieldByName("parentarticlenode")!
                  .valueLinkNode!);
          mediaLinkTitle = parentArticleNode!.content.rowData!
              .getFieldByName("medialinktitle")!
              .valueString!;

          VwRowData? currentRowData =
              NodeUtil.getRowDataFromNodeContentRecordCollection(
                  this.widget.rowNode!);

          startseconds =
              currentRowData!.getFieldByName("startseconds")!.valueNumber!;
          endseconds =
              currentRowData!.getFieldByName("endseconds")!.valueNumber!;
        } catch (error) {}

        returnValue = LayoutBuilder(builder: (context, boxConstraint) {
          double sizeRatio = 1;
          if (boxConstraint.maxWidth > 1000) {
            sizeRatio = 0.7;
          } else if (boxConstraint.maxWidth > 500) {
            sizeRatio = 0.8;
          }

          return this.getMediaLinkTitleWidget(
              sizeRatio: sizeRatio,
              videoId: mediaLinkTitle,
              startseconds: startseconds,
              endseconds: endseconds);
        });
      } else if (this.widget.articletype == "imagebanner") {
        returnValue = this.getImageTitleWidget(fullHeightImage: true);
      } else {
        returnValue = this.getImageTitleWidget();
      }
    } catch (error) {
      print(
          "Error catched on Widget getMediaTitleWidget(): " + error.toString());
    }
    return returnValue;
  }

  Widget _getViewFullScreenWidget() {
    Widget returnvalue = Container();
    try {
      if (this.widget.articletype == "pdf" &&
          this.widget.imagecontent != null &&
          this.widget.imagecontent!.serverFile != null &&
          this.widget.imagecontent!.serverFile!.length > 0) {
        returnvalue = InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VwMultimediaViewer(
                      appInstanceParam: this.widget.appInstanceParam,
                      multimediaViewerParam: VwMultimediaViewerParam(),
                      multimediaViewerInstanceParam:
                          VwMultimediaViewerInstanceParam(
                              caption: this.widget.caption,
                              remoteSource:
                                  this.widget.imagecontent!.serverFile!,
                              fileSource: [],
                              memorySource: []))),
            );
          },
          child: Container(
              height: 40,
              width: this.frameHeight * this.imageRatio,
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "View",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.menu_book,
                    color: Colors.white,
                    size: 25,
                  )
                ],
              )),
        );
        /*
        returnvalue=InkWell(

          child: ,
          onTap:(){


          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VwMultimediaViewer(
                    appInstanceParam: this.widget.appInstanceParam,
                    multimediaViewerParam: VwMultimediaViewerParam(

                       ),
                    multimediaViewerInstanceParam:
                    VwMultimediaViewerInstanceParam(

                        remoteSource: this.widget.imagecontent!.serverFile! ,
                        fileSource: [],
                        memorySource: []))),
          );
        }
        )


        ;*/
      }
    } catch (error) {
      print("Error catched on Widget _getViewFullScreenWidget():" +
          error.toString());
    }

    return returnvalue;
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (this.widget.articletype == "imagebanner") {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            this.getTopWidget(),
            this.getMediaTitleWidget(),
          ],
        );
      } else {
        Widget returnValue = Container(
            key: this.widget.key,
            color: Color.fromARGB(255, 240, 240, 240),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12)),
                    constraints: BoxConstraints(minWidth: 300, maxWidth: 600),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(7, 7, 7, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              this.getTopWidget(),
                              SizedBox(height: 7),
                              this.getCaptionWidget(
                                  compacted: this.isTitleCompacted),
                              SizedBox(height: 12),
                            ],
                          ),
                        ),
                        Center(child: this.getMediaTitleWidget()),
                        _getViewFullScreenWidget(),
                        Container(
                            margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                            child: getInfoBar()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ]));

        return returnValue;
      }
    } catch (error) {
      print("Error Catched on Viewer Material=" + error.toString());
    }
    Widget cardWidget = widget.title != null && widget.title!.length > 0
        ? Text(widget.title.toString())
        : Container();

    return InkWell(
        onTap: this.widget.cardTapper.onTap,
        child: Container(key: widget.key, child: cardWidget));
  }
}
