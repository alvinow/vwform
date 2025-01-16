import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icon.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwdataformattimestamp/vwdataformattimestamp.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfieldfilestorage/vwfieldfilestorage.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/modules/vwlinknoderendered/vwlinknoderendered.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/horizontalarticlefeed/horizontalarticlefeed.dart';
import 'package:vwform/modules/mediaviewerpage/mediaviewerpage.dart';
import 'package:vwform/modules/pagecoordinator/bloc/pagecoordinator_bloc.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediainstanceparam/vwmultimediaviewerinstanceparam.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediaviewer.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediaviewerparam/vwmultimediaviewerparam.dart';
import 'package:vwform/modules/vwwidget/locationwidget/vwshowlocationwidget/vwshowlocationwidget.dart';
import 'package:vwform/modules/vwwidget/materialtransparentroute/materialtransparentroute.dart';
import 'package:vwform/modules/vwwidget/rowviewermaterial/vwinstagramrowviewermaterial/vwinstagrambottommodalmenu.dart';
import 'package:vwform/modules/youtubeappdemo/youtubeappdemo.dart';
import 'package:vwutil/modules/util/profilepictureutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwInstagramRowViewerMaterial extends StatefulWidget {
  VwInstagramRowViewerMaterial(
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
      this.boxConstraints=const BoxConstraints(minWidth: 300, maxWidth: 600),
      this.nodeFeederBoxConstraints =
          const BoxConstraints(maxHeight: 360, maxWidth: 800),
      this.eventDate,
      this.commandToParentFunction
      });
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
  final DateTime? eventDate;
  final BoxConstraints? boxConstraints;
  final BoxConstraints? nodeFeederBoxConstraints;
  final CommandToParentFunction? commandToParentFunction;

  VwInstagramRowViewerMaterialState createState() =>
      VwInstagramRowViewerMaterialState();
}

class VwInstagramRowViewerMaterialState
    extends State<VwInstagramRowViewerMaterial> {
  late bool isCurrentUserThumbUp;
  late bool isTitleCompacted;
  late double imageRatio;
  late double frameHeight;
  late Key formKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.formKey = UniqueKey();
    this.imageRatio = 1.0;
    this.frameHeight = 300;
    isTitleCompacted = true;
    isCurrentUserThumbUp = false;
  }

  String? getCurrentUserResponseId() {
    String? returnValue;
    try {
      VwRowData? rowData=this.getCurrentUserResponseRowData();
      if (rowData!=null) {


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

  VwRowData? getCurrentUserResponseRowData(){
    VwRowData? returnValue;
    try
    {
      return  this
          .widget
          .rowNode!
          .content!
          .rowData!.getFieldByName("currentUserResponseNode")!.valueRowData;
    }
    catch(error)
    {

    }
    return returnValue;
  }

  void askToLogin(){

    double boxHeight=150;
    double boxWidth=300;

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        useSafeArea: false,
        constraints: BoxConstraints(maxWidth: boxWidth),
        context: context,
        builder: (context) {



          return LayoutBuilder(builder: (buildContext,constraintBox){
            double topMargin=0;
            try
            {
              topMargin= (constraintBox.maxHeight-boxHeight)/2;
            }
            catch(error)
            {

            }
            return Scaffold(
              backgroundColor: Colors.transparent,
              body:SingleChildScrollView(child: Container(
                margin: EdgeInsets.fromLTRB(0, topMargin, 0, 0),
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                color: Colors.white,
               // constraints: BoxConstraints(maxHeight: boxHeight ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [



                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [  Expanded(child:Text(
                        "Silahkan Login Terlebih Dahulu untuk memberi respon.")),],),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        TextButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith(
                                      (states) =>
                                      this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.primaryColor),
                              side: MaterialStateProperty.resolveWith(
                                      (states) => BorderSide(
                                      color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.textColor)),

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
                              color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.textColor,
                            ),
                            label: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.textColor),
                            )),
                        TextButton.icon(
                            style: ButtonStyle(
                              side: MaterialStateProperty.resolveWith(
                                      (states) => BorderSide(
                                      color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.primaryColor)),
                              textStyle: MaterialStateProperty.resolveWith(
                                      (states) =>
                                      TextStyle(color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.primaryColor)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.navigate_next,
                              color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.primaryColor,
                            ),
                            label: Text(
                              "Lanjut",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.primaryColor),
                            )),





                      ],
                    )
                  ],
                ),
              )),
            );
          }  );

        }

    );
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
                        onTap: () {
                          if (this.widget.appInstanceParam.loginResponse != null) {

                            VwRowData? userResponseRowData=this.getCurrentUserResponseRowData();

                            if(userResponseRowData==null)
                            {

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
                                        fieldName: "responseId", valueString: "like"),
                                  ]);

                              this.widget.rowNode!.content.rowData!.fields!.add(VwFieldValue(fieldName: "currentUserResponseNode",valueTypeId: VwFieldValue.vatValueRowData, valueRowData:userResponseRowData ));
                            }
                            else{
                              userResponseRowData.getFieldByName("responseId")!.valueString="like";
                            }



                            this.widget.appInstanceParam.appBloc.sinkSyncRowData(
                                rowData: userResponseRowData,
                                appInstanceParam: this.widget.appInstanceParam);

                            setState(() {

                            });



                          } else {
                            this.askToLogin();
                          }
                        },
                        child: this.getCurrentUserResponseId().toString()=="like"?LineIcon.thumbsUp (color: Colors.blue,) :LineIcon.thumbsUp(
                          size: 25,
                          color: Colors.black54,
                        )),
                    /*Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Text(
                          "Dukung",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ))*/
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
                  InkWell(onTap: () {

                    if (this.widget.appInstanceParam.loginResponse != null) {

                      VwRowData? userResponseRowData=this.getCurrentUserResponseRowData();

                      if(userResponseRowData==null)
                      {

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
                                  fieldName: "responseId", valueString: "dislike"),
                            ]);

                        this.widget.rowNode!.content.rowData!.fields!.add(VwFieldValue(fieldName: "currentUserResponseNode",valueTypeId: VwFieldValue.vatValueRowData, valueRowData:userResponseRowData ));
                      }
                      else{
                        userResponseRowData.getFieldByName("responseId")!.valueString="dislike";
                      }



                      this.widget.appInstanceParam.appBloc.sinkSyncRowData(
                          rowData: userResponseRowData,
                          appInstanceParam: this.widget.appInstanceParam);

                      setState(() {

                      });



                    } else {
                      this.askToLogin();
                    }
                  }, child:this.getCurrentUserResponseId().toString()=="dislike"?LineIcon.thumbsDown (
                    size: 25,
                    color: Colors.red,
                  ):
                  LineIcon.thumbsDown(
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
                width: 15,
              ),
              IconButton(

                onPressed: () async {
                  if (this.widget.rowNode != null) {

                    await Navigator.push(
                      context,
                      MaterialTransparentRoute(
                          builder: (context) => MediaViewerPage (
                              mediaLinkNode:VwLinkNode(rendered: VwLinkNodeRendered(renderedDate: DateTime.now(), node: widget.rowNode,), nodeId:widget.rowNode!.recordId, nodeType:VwNode.ntnRowData)  ,
                              key: formKey,
                              appInstanceParam: widget.appInstanceParam)),
                    );

                    /*
                    await Navigator.push(
                      context,
                      MaterialTransparentRoute(
                          builder: (context) => VwJanjiNodePage (
                            parentArticleNode: widget.rowNode,
                              key: formKey,
                              parentarticlenodeid: this.widget.rowNode!.recordId,
                              appInstanceParam: widget.appInstanceParam)),
                    );
*/


                  }
                },
                icon: Icon(Icons.note_alt_outlined, color: Colors.black54),

              ),

              IconButton(onPressed: ()async{

                String url=this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl+r"?articleId="+ widget.rowNode!.recordId;

                await Clipboard.setData(ClipboardData(
                    text: url ));

                Fluttertoast.showToast(
                    msg: "Share Link has been copied to Clipboard",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    webBgColor:
                    "linear-gradient(to right, #FF6D0A, #FF6D0A)",
                    webPosition: "center",
                    fontSize: 16.0);
              }, icon:  Icon(Icons.share, color: Colors.black54),),


            ],
          ));
    } catch (error) {}
    return returnValue;
  }

  Widget getTopWidget() {
    try {
      if ((this.widget.articletype == "imagebanner" ||
              this.widget.articletype == "youtubebanner") &&
          this.isEditable() == false) {
        return Container();
      } else if ((this.widget.articletype == "horizontalArticleFeed" || this.widget.articletype == "timelineHorizontalArticleFeed") &&
          this.isEditable() == false) {
        return Container();
      } else if ((this.widget.articletype == "image" ||
              this.widget.articletype == "youtube") &&
          this.isEditable() == false) {
        return Container();
      } else {
        return Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  this.widget.showAccountInfo == false
                      ? Container()
                      : Container(
                          margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: getUsernameWidget()),
                  this.getEditButtonWidget()
                ]));
      }
    } catch (error) {}
    return Container();
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

  Widget getCreatedTime({double size = 25}) {
    TextStyle dateStyle =
        TextStyle(color: Colors.black54, fontSize: size * 0.52);

    Widget returnValue = Text(
      "unknown",
      style: dateStyle,
    );

    if (this.widget.timestamp != null) {
      returnValue = Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            VwDateUtil.indonesianFormatLocalTimeZone_DateOnly(
                this.widget.timestamp!.created),
            style: dateStyle,
          ));
    }
    return returnValue;
  }

  Widget getEventTime({double size = 40}) {
    TextStyle dateStyle =
        TextStyle(color: Colors.black54, fontSize: size * 0.4);

    Widget returnValue = Container();

    if (this.widget.eventDate != null) {
      returnValue = Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            VwDateUtil.indonesianFormatLocalTimeZone_DateOnly(
                this.widget.eventDate!),
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
            style: TextStyle(fontSize: size * 0.4,color: Colors.black54),
          ),
        ));
      }
    } catch (error) {}
    return returnValue;
  }

  Widget getProfilePicture({double size = 25}){
    Widget returnValue=Stack(alignment: AlignmentDirectional.center, children: [
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

    try
    {
      if(this.widget.rowNode!.creatorUserLinkNode==null)
        {
          this.widget.rowNode!.creatorUserLinkNode=this.widget.rowNode!.content.rowData!.creatorUserLinkNode;
        }

      returnValue=ProfilePictureUtil.getUserProfilePictureFromNode(appInstanceParam: this.widget.appInstanceParam, size: size, node:this.widget.rowNode!);
    }
    catch(error)
    {
      print("Error catched: "+ error.toString());
    }

    return returnValue;
  }

  Widget getUsernameWidget({Color textColor=Colors.black, bool isShowUserIcon=false, bool isShowLocation=false, double size = 40}) {
    if (this.getLocationWidget() != null) {
      return Row(
        children: [
          isShowUserIcon==false?Container(): Container(
              margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
              child: this.getProfilePicture()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  child: Text(
                    this.widget.username,
                    style: TextStyle(
                        color:  textColor,
                        fontSize: size * 0.4,
                        fontWeight: FontWeight.w600),
                  )),
              isShowLocation?Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: this.getLocationWidget(size: size)!):Container()
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          isShowUserIcon?Container(
              margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
              child: this.getProfilePicture()):Container(),
          Container(
              margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
              child: Text(
                this.widget.username,
                style: TextStyle(
                    color:  textColor,
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.w600),
              ))
        ],
      );
    }
  }

  Widget getImageTitleWidget({bool fullHeightImage = false}) {
    return LayoutBuilder(
        builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
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
          } catch (error) {}

          // Size screenSize = MediaQuery.of(context).size;
          //Orientation orientation = MediaQuery.of(context).orientation;

          if (fullHeightImage == true) {
            frameHeight = boxConstraints.maxWidth.toDouble() / imageRatio;
          } else {
            frameHeight = boxConstraints.maxHeight;
          }

          if (frameHeight > boxConstraints.maxWidth) {
            //frameHeight = screenSize.shortestSide;
            if (imageRatio != null) {
              frameHeight = boxConstraints.maxWidth / imageRatio!.toDouble();
            }
          }

          print("Frame Height=" + frameHeight.toString());
        } catch (error) {}
      }

      if (this.widget.imagetitle != null &&
          this.widget.imagetitle!.serverFile != null &&
          this.widget.imagetitle!.serverFile!.length > 0) {
        Widget imageTitleWidget = SizedBox(
            height: frameHeight,
            child: VwMultimediaViewer(
                key: this.widget.key,
                usedAsWidgetComponent: true,
                appInstanceParam: this.widget.appInstanceParam,
                multimediaViewerParam: VwMultimediaViewerParam(),
                multimediaViewerInstanceParam: VwMultimediaViewerInstanceParam(
                    remoteSource: this.widget.imagetitle!.serverFile!,
                    fileSource: [],
                    memorySource: [])));

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
        return Stack(
          fit: StackFit.loose,
          alignment: AlignmentDirectional.center,
          children: [
            Icon(
              Icons.image,
              size: 200,
              color: Colors.grey,
            ),
            Icon(
              Icons.not_interested,
              color: Colors.black,
            )
          ],
        );
      }
    });
  }

  TextStyle getDefaultTitleTextStyle({double size = 25}) {
    return TextStyle(
        fontSize: 0.64 * size,
        color: Colors.black,
        fontWeight: FontWeight.w600);
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
            Icon(Icons.share)
          ],
        ));
  }

  bool isEditable() {
    bool returnValue = false;
    try {
      returnValue = this.widget.appInstanceParam.loginResponse != null &&
          this.widget.appInstanceParam.loginResponse!.userInfo != null &&
          this.widget.appInstanceParam.loginResponse!.userInfo!.user != null &&
          this
                  .widget
                  .appInstanceParam
                  .loginResponse!
                  .userInfo!
                  .user
                  .username
                  .toLowerCase() ==
              this.widget.username.toLowerCase();

      if (this
              .widget
              .appInstanceParam
              .loginResponse!
              .userInfo!
              .user
              .mainRoleUserGroupId ==
          this.widget.appInstanceParam.baseAppConfig.generalConfig.adminticketMainRoleUserGroupId) {
        returnValue = true;
      }
    } catch (error) {}

    return returnValue;
  }

  Widget getEditButtonWidget() {
    bool enableEdit = this.isEditable();

    /*
    if (this.widget.appInstanceParam.loginResponse != null &&
        this.widget.appInstanceParam.loginResponse!.userInfo != null &&
        this.widget.appInstanceParam.loginResponse!.userInfo!.user != null &&
        this
                .widget
                .appInstanceParam
                .loginResponse!
                .userInfo!
                .user
                .username
                .toLowerCase() ==
            this.widget.username.toLowerCase()) {
      enableEdit = true;
    }*/

    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
              onTap: () async {
                //on edit  this.widget.cardTapper.onTap

                await showModalBottomSheet(
                  context: context,
                  builder: (context) => VwInstagramBottomModalMenu(
                    appInstanceParam: this.widget.appInstanceParam,
                    key: UniqueKey(),
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
  }

  Widget getTitleWidget({bool isShowUserIcon=true, double size = 25, bool compacted = true}) {
    String captionText =
        this.widget.title == null ? "" : this.widget.title.toString();
    bool textFullyShowed = true;
    if (compacted == true) {
      int trimlimit = captionText.length;
      if (trimlimit > 50) {
        textFullyShowed = false;
        captionText = captionText.substring(0, 50);
      } else {
        captionText = captionText.toString();
      }
    }

    TextSpan userTextSpan = TextSpan(
        text: this.widget.username.toString(),
        style: TextStyle(fontWeight: FontWeight.w600));
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

    List<TextSpan> textLines = [/*userTextSpan,spaceTextSpan,*/ titleTextSpan];

    int maxLines = 1000;

    if (compacted == true && textFullyShowed == false) {
      textLines.add(readMoreTextSpan);
      maxLines = 10;
    }

    return
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isShowUserIcon? Container(margin: EdgeInsets.fromLTRB(0, 0, 5, 0), child:this.getProfilePicture()):Container(),
        Expanded(child:Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: RichText(
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            //style: DefaultTextStyle.of(context).style,
              style: this.getDefaultTitleTextStyle(size: size),
              children: textLines),
        )))
      ],
    );



  }

  Widget getMediaLinkTitleWidget({bool? fullWidth = false}) {
    double frameHeight = 300;

    try {
      if (this.widget.medialinktitle != null) {
        Size screenSize = MediaQuery.of(context).size;
        Orientation orientation = MediaQuery.of(context).orientation;

        if (fullWidth == true) {
          frameHeight = screenSize.width * 9 / 16;

        if(this.widget.commandToParentFunction!=null && this.widget.rowNode!=null && this.widget!.rowNode!.content!=null && this.widget!.rowNode!.content!.rowData!=null )
        {
          return InkWell(onTap:(){
            this.widget.commandToParentFunction!(this.widget!.rowNode!.content!.rowData!);
          },child: Container(child: LineIcon.youtube(color: Colors.red,),));
        }
          else
            {
              if( this.widget.rowNode!=null && this.widget!.rowNode!.content!=null && this.widget!.rowNode!.content!.rowData!=null )
                {
                  return SizedBox(
                      height: frameHeight,
                      width: screenSize.width,
                      child: YoutubeAppDemo(
                          playUsingMediaViewer: true,
                          appInstanceParam: widget.appInstanceParam,
                          articleNode: widget.rowNode,
                          videoIds: [
                        this.widget.medialinktitle!,
                        this.widget.medialinktitle!
                      ]));
                }
              else
                {
                  return SizedBox(
                      height: frameHeight,
                      width: screenSize.width,
                      child: YoutubeAppDemo(
                          appInstanceParam: this.widget.appInstanceParam,
                          videoIds: [
                        this.widget.medialinktitle!,
                        this.widget.medialinktitle!
                      ]));
                }

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

            if(this.widget.commandToParentFunction!=null && this.widget.rowNode!=null && this.widget!.rowNode!.content!=null && this.widget!.rowNode!.content!.rowData!=null )
            {
              return InkWell(onTap:(){
                this.widget.commandToParentFunction!(this.widget!.rowNode!.content!.rowData!);
              },child: Container(child: LineIcon.youtube(color: Colors.red,)),);


            }
            else
            {

              if( this.widget.rowNode!=null && this.widget!.rowNode!.content!=null && this.widget!.rowNode!.content!.rowData!=null )

                {
                  return SizedBox(
                      height: height,
                      width: width,
                      child: YoutubeAppDemo(
                          playUsingMediaViewer: true,
                          appInstanceParam: widget.appInstanceParam,
                          articleNode: widget.rowNode,
                          autoplay: false, videoIds: [
                        this.widget.medialinktitle!,
                        this.widget.medialinktitle!
                      ]));
                }
              else
                {
                  return SizedBox(
                      height: height,
                      width: width,
                      child: YoutubeAppDemo(
                          appInstanceParam: this.widget.appInstanceParam,
                          autoplay: false, videoIds: [
                        this.widget.medialinktitle!,
                        this.widget.medialinktitle!
                      ]));
                }

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
    if (this.widget.articletype == "youtube" ||
        this.widget.articletype == "fullArticleVideo") {
      return this.getMediaLinkTitleWidget();
    } else if (this.widget.articletype == "youtubebanner") {
      return this.getMediaLinkTitleWidget(fullWidth: true);
    } else if (this.widget.articletype == "imagebanner") {
      return this.getImageTitleWidget(fullHeightImage: true);
    } else {
      return this.getImageTitleWidget();
    }
  }

  Widget _getViewFullScreenWidget() {
    Widget returnvalue = Container();
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
                            remoteSource: this.widget.imagecontent!.serverFile!,
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

    return returnvalue;
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (this.widget.articletype == "horizontalArticleFeed") {
        try {
          String articlefeedmaincategory = this
              .widget
              .rowNode!
              .content
              .rowData!
              .getFieldByName("articlefeedmaincategory")!
              .valueString!;

          return LayoutBuilder(builder:
              (BuildContext buildContext, BoxConstraints boxConstraints) {
            BoxConstraints constraints = BoxConstraints(
                maxWidth: boxConstraints.maxWidth,
                maxHeight: this.widget.nodeFeederBoxConstraints!.maxHeight);

            return Column(
                key:widget.key,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  this.getTopWidget(),
                  Container(
                    color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.primaryColor,
                    margin: EdgeInsets.fromLTRB(10, 30, 20, 10),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(this.widget.title.toString(),
                        style: TextStyle(
                            color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  ),
                  Container(
                      constraints: constraints,
                      child: HorizontalArticleFeed(
                          key: Key(this.widget.rowNode!.recordId),
                          appInstanceParam: widget.appInstanceParam,
                          standardArticleMaincategory: articlefeedmaincategory))
                ]);
          });
        } catch (error) {}

        return Container();
      }
      else if (this.widget.articletype == "timelineHorizontalArticleFeed") {
        try {

          String articlefeedmaincategory = this
              .widget
              .rowNode!
              .content
              .rowData!
              .getFieldByName("articlefeedmaincategory")!
              .valueString!;

          return LayoutBuilder(builder:
              (BuildContext buildContext, BoxConstraints boxConstraints) {
            BoxConstraints constraints = BoxConstraints(
                maxWidth: boxConstraints.maxWidth,
                maxHeight: this.widget.nodeFeederBoxConstraints!.maxHeight);

            DateTime? eventDate;


            return Container(
                key:widget.key,
                child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  this.getTopWidget(),
                  Container(
                    color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.primaryColor,
                    margin: EdgeInsets.fromLTRB(10, 30, 20, 10),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(this.widget.title.toString(),
                        style: TextStyle(
                            color: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  ),
                  Container(
                      color: Colors.red,
                      constraints: constraints,
                      child: HorizontalArticleFeed(
                          eventDateEnd: this.widget.eventDate,
                          eventDateStart: this.widget.eventDate,
                          key: Key(this.widget.rowNode!.recordId),
                          appInstanceParam: widget.appInstanceParam,
                          standardArticleMaincategory: articlefeedmaincategory))
                ]));
          });
        } catch (error) {}

        return Container();
      }
      else if (this.widget.articletype == "imagebanner") {
        return Column(
          key:widget.key,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            this.getTopWidget(),
            this.getMediaTitleWidget(),
          ],
        );
      } else if (this.widget.articletype == "youtubebanner") {
        return Column(
          key:widget.key,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            this.getTopWidget(),
            this.getMediaTitleWidget(),
          ],
        );
      } else {

       // BoxConstraints? currentBoxConstraints=widget.boxConstraints!=null?widget.boxConstraints:const BoxConstraints( maxWidth: 450);

        BoxConstraints? currentBoxConstraints=widget.boxConstraints;

        return
          Container(
              key:widget.key,
              margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
              constraints: currentBoxConstraints,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  this.getTopWidget(),
                  this.getMediaTitleWidget(),
                  _getViewFullScreenWidget(),
                  //this.getActionRowWidget(),
                  SizedBox(
                    height: 3,
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child:this.getInfoBar(),),


                  Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: this.getTitleWidget(isShowUserIcon: false,
                          size: 21, compacted: this.isTitleCompacted)),

                  Container(
                      margin: EdgeInsets.fromLTRB(10, 4, 10, 0),
                      child:Row(
                        children: [
                          this.getEventTime(size: 30),
                          this.getLocationWidget(size: 30)==null?Container():Container(margin: EdgeInsets.fromLTRB(5, 0, 0, 0), child:Icon(Icons.location_pin,size: 16,)),
                          this.getLocationWidget(size: 30)==null?Container():this.getLocationWidget(size: 30)!
                        ],
                      )
                  ),


                  Container(
                      margin: EdgeInsets.fromLTRB(15, 4, 0, 0),
                      child:Row(
                        children: [
                          this.getProfilePicture(size: 18),
                          Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                              child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  this.getUsernameWidget(textColor: Colors.black54, size: 30),

                                ],
                              )
                          )],
                      )),


                ],
              ));

          ;
      }
    } catch (error) {
      print("Error Catched on Viewer Material=" + error.toString());
    }
    Widget cardWidget = widget.caption != null && widget.caption!.length > 0
        ? Text(widget.caption!)
        : Container();
    return InkWell(
        onTap: this.widget.cardTapper.onTap,
        child: Container(key: widget.key, child: cardWidget));
  }
}
