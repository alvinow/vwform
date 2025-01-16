import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwformresponseuserpage.dart';

class VwCommentsNodePage extends StatefulWidget{

const VwCommentsNodePage({
  super.key,
  required this.parentarticlenodeid,
  required this.appInstanceParam
});

  final String parentarticlenodeid;
  final VwAppInstanceParam appInstanceParam;
  VwCommentsNodePageState createState()=> VwCommentsNodePageState();
}

class VwCommentsNodePageState extends State<VwCommentsNodePage>{
  late Key formUserResponseKey;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.initState();

    this.formUserResponseKey = UniqueKey();
    if (this.widget.key != null) {
      this.formUserResponseKey = this.widget.key!;
    }
  }

  bool getEnableCommentBoxBottomSide(){
    bool returnValue=false;
    try
        {
          if(this.widget.appInstanceParam.loginResponse!=null && this.widget.appInstanceParam.loginResponse!.userInfo!=null )
            {
              returnValue=true;
            }

        }
        catch(error)
    {

    }
    return returnValue;
  }

  @override
  Widget getFeedFolderNode() {

    /*
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true,),
      body:Text("test App Bar")
    );*/

    return VwFormResponseUserPage(
      mainLogoImageAsset: this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
     bottomSideMode:getEnableCommentBoxBottomSide()? NodeListView.bsmCommentBox:NodeListView.bsmDisabled,
      zeroDataCaption: "(Belum ada komentar)",
      enableAppBar: true,
      showBackArrow: true,
      enableScaffold: true,
      showUserInfoIcon: false,
      showLoginButton: false,
      mainHeaderTitleTextColor: Colors.black,
      mainHeaderBackgroundColor: Colors.white,
      enableCreateRecord: false,
      mainLogoTextCaption: "komentar",
      folderNodeId: "15b492f8-e4fb-496d-a999-a4afc39bc184",
      key: this.formUserResponseKey,
      appInstanceParam: widget.appInstanceParam,
      showReloadButton: false,
      extendedApiCallParam: VwRowData(recordId: Uuid().v4(),fields: [
        VwFieldValue(fieldName: "parentarticlenodeid",valueString: this.widget.parentarticlenodeid)
      ]),
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