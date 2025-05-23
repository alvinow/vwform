import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwformresponseuserpage.dart';

class VwLhpPage extends StatefulWidget {
  VwLhpPage({
    super.key,
    required this.appInstanceParam,
    this.isRootFolder = true,
  });

  final VwAppInstanceParam appInstanceParam;
  final bool isRootFolder;

  VwLhpPageState createState() => VwLhpPageState();
}

class VwLhpPageState extends State<VwLhpPage> {
  @override
  Widget build(BuildContext context) {
    return VwFormResponseUserPage(
        mainLogoImageAsset: this
            .widget
            .appInstanceParam
            .baseAppConfig
            .generalConfig
            .mainLogoPath,
        formResponseIdList: ["lhpformdefinition"],
        mainLogoTextCaption: "LHP",
        key: widget.key,
        isRootFolder: true,
        showPrintButton: true,
        folderNodeId: "response_lhpformdefinition",
        appInstanceParam: widget.appInstanceParam);
  }
}
