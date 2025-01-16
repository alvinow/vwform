import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwapicall/apivirtualnode/apivirtualnode.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwformresponseuserpage.dart';


class VwPublicLandingPage extends StatefulWidget{
  VwPublicLandingPage({

    required this.appInstanceParam,
    required this.rootFolderNodeId,
    this.showFooter=false,
    super.key
});

  final VwAppInstanceParam appInstanceParam;
  final String rootFolderNodeId;
  final bool showFooter;

  VwPublicLandingPageState createState()=>VwPublicLandingPageState();
}

class VwPublicLandingPageState extends State<VwPublicLandingPage>{

  late Key formUserResponseKey;

  @override
  void initState() {
    super.initState();

    this.formUserResponseKey=UniqueKey();
    if(this.widget.key!=null)
      {
        this.formUserResponseKey=this.widget.key!;
      }
  }

  Widget? getTopRowWidget()
  {
    return null;
    /*
    if(AppConfig.baseUrl=="https://baleamin.com")
      {
        return VwMobileHeaderWidget();
      }
    else{
      return null;
    }*/
  }

  Widget getFeedFolderNode(){
    return     VwFormResponseUserPage(

      //footer: this.widget.showFooter==false?null: PublicLandingPageFooter(),
      mainHeaderTitleTextColor: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.textColor,
      mainHeaderBackgroundColor: this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.primaryColor,

      topRowWidget: this.getTopRowWidget(),
      enableCreateRecord: false,
      mainLogoTextCaption: this.widget.appInstanceParam.baseAppConfig.generalConfig.appTitle,
      mainLogoMode: NodeListView.mlmText,
      mainLogoImageAsset: this.widget.appInstanceParam.baseAppConfig.generalConfig.rootLogoPath,

      folderNodeId: APIVirtualNode.exploreNodeFeed,
      key: this.formUserResponseKey,
      appInstanceParam: widget.appInstanceParam,
      showReloadButton: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.getFeedFolderNode();
  }
}