import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwapicall/apivirtualnode/apivirtualnode.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwpublicquestionpage/vwquestionboxwidget.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwformresponseuserpage.dart';

class HorizontalArticleFeed extends StatefulWidget {
  HorizontalArticleFeed(
      {
        required super.key,
        required this.appInstanceParam,required this.standardArticleMaincategory,
      this.eventDateEnd,
        this.eventDateStart
      });

  final VwAppInstanceParam appInstanceParam;
  final String standardArticleMaincategory;
  final DateTime? eventDateStart;
  final DateTime? eventDateEnd;


  HorizontalArticleFeedState createState() => HorizontalArticleFeedState();
}

class HorizontalArticleFeedState extends State<HorizontalArticleFeed> {


  @override
  void initState() {
    super.initState();


  }

  Widget? getTopRowWidget() {
    return Container(
        color: Color.fromARGB(255, 240, 240, 240),
        child: VwQuestionBoxWidget(
          appInstanceParam: this.widget.appInstanceParam,
        ));
  }

  VwRowData apiCallFilterByStandardArticleMaincategory(){
    return VwRowData(recordId: Uuid().v4(),fields: [
      VwFieldValue(fieldName: "maincategory",valueString: widget.standardArticleMaincategory ),
      VwFieldValue(fieldName: "eventDateStart",valueTypeId: VwFieldValue.vatDateOnly, valueDateTime: widget.eventDateStart ),
      VwFieldValue(fieldName: "eventDateEnd",valueTypeId: VwFieldValue.vatDateOnly,valueDateTime: widget.eventDateEnd ),

    ]);
  }

  Widget getFeedFolderNode() {
    return VwFormResponseUserPage(
      rowViewerBoxContraints: BoxConstraints(maxWidth: 350,maxHeight: 250),
      scrollDirection: Axis.horizontal,
      extendedApiCallParam: this.apiCallFilterByStandardArticleMaincategory(),
      showLoginButton: false,
      showSearchIcon: false,
      zeroDataCaption: "(Belum ada artikel)",
      mainHeaderTitleTextColor: AppConfig.textColor,
      mainHeaderBackgroundColor: AppConfig.primaryColor,
      enableCreateRecord: false,
      folderNodeId: APIVirtualNode.exploreNodeFeed,
      key: this.widget.key,
      appInstanceParam: widget.appInstanceParam,
      showReloadButton: false,
      enableAppBar: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget returnValue = Container(child: Text("Error 500: Internal Error"));

    try {
      returnValue = this.getFeedFolderNode();
    } catch (error) {
      print("Error Catched on VwPublicQuestionPage: " + error.toString());
    }
    return returnValue;
  }
}
