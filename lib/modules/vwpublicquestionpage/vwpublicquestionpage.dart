import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwapicall/apivirtualnode/apivirtualnode.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwpublicquestionpage/vwquestionboxwidget.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwformresponseuserpage.dart';

class VwPublicQuestionPage extends StatefulWidget {
  VwPublicQuestionPage(
      {required this.appInstanceParam, this.showFooter = false, super.key});

  final VwAppInstanceParam appInstanceParam;

  final bool showFooter;

  VwPublicQuestionPageState createState() => VwPublicQuestionPageState();
}

class VwPublicQuestionPageState extends State<VwPublicQuestionPage> {
  late Key formUserResponseKey;

  @override
  void initState() {
    super.initState();

    this.formUserResponseKey = UniqueKey();
    if (this.widget.key != null) {
      this.formUserResponseKey = this.widget.key!;
    }
  }

  Widget? getTopRowWidget() {
    return Container(
        color: Color.fromARGB(255, 240, 240, 240),
        child: VwQuestionBoxWidget(
          appInstanceParam: this.widget.appInstanceParam,
        ));
  }

  Widget getFeedFolderNode() {
    return VwFormResponseUserPage(

      toolbarHeight: 90,
      toolbarPadding: 22,
      showSearchIcon: false,
      zeroDataCaption: "(Belum ada pertanyaan)",
      //enableQuestionBoxTopRow: true,
      boxTopRowWidgetMode: NodeListView.btrQuestionBox,
      //footer:this.widget.showFooter == false ? null : PublicLandingPageFooter(),
      mainHeaderTitleTextColor: AppConfig.textColor,
      mainHeaderBackgroundColor: AppConfig.primaryColor,
      //topRowWidget: this.getTopRowWidget(),
      enableCreateRecord: false,
      mainLogoMode: NodeListView.mlmLogo,
      mainLogoImageAsset: AppConfig.rootLogoPath,
      mainLogoTextCaption: AppConfig.appTitle,
      folderNodeId: "15b492f8-e4fb-496d-a999-a4afc39bc184",
      key: this.formUserResponseKey,
      appInstanceParam: widget.appInstanceParam,
      showReloadButton: false,
      enableAppBar: true,
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
