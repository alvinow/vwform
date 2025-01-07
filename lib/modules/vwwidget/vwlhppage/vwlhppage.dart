import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/vwdateutil.dart';
import 'package:matrixclient/modules/vwwidget/chartnodelistview/chartnodeviewer.dart';
import 'package:matrixclient/modules/vwwidget/nodelistview/nodelistview.dart';
import 'package:matrixclient/modules/vwwidget/vwformresponseuserpage/vwformresponseuserpage.dart';
import 'package:uuid/uuid.dart';

class VwLhpPage extends StatefulWidget{
  VwLhpPage({
    super.key,
    required this.appInstanceParam,
    this.isRootFolder=true,
  });



  final VwAppInstanceParam appInstanceParam;
  final bool isRootFolder;



  VwLhpPageState createState()=>VwLhpPageState();
}

class VwLhpPageState extends State<VwLhpPage>{

  @override
  Widget build(BuildContext context) {

    return VwFormResponseUserPage(formResponseIdList: ["lhpformdefinition"], mainLogoTextCaption: "LHP", key: widget.key, isRootFolder: true, folderNodeId: "response_lhpformdefinition", appInstanceParam: widget.appInstanceParam);

  }
}