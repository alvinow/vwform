import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:intl/intl.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/vwcardparameter/vwcardparameter.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:matrixclient/modules/vwformpage/vwoldformpage.dart';
import 'package:matrixclient/modules/vwwidget/noderowviewer/noderowviewer.dart';
import 'package:matrixclient/modules/vwwidget/rowviewermaterial/vwcardparametermaterial/vwcardparametermaterial.dart';
import 'package:matrixclient/modules/vwwidget/vwcardparameternodeviewermaterial/vwcardparameternodeviewermaterial.dart';
import 'package:uuid/uuid.dart';

class VwSelectFormDefinitionRowViewer extends NodeRowViewer {
  VwSelectFormDefinitionRowViewer({
    required super.rowNode,
    required super.appInstanceParam,
    super.highlightedText,
    super.refreshDataOnParentFunction,
  });



  @override
  Widget build(BuildContext context) {

    VwCardParameter cardParameter=VwCardParameter(
        titleFieldName: "formName",
        iconHexCode: "0xe2a3",
        iconHexColor: "ff3f497f",
      isShowSubtitle: false,
    );

    InkWell cardTapper=InkWell(onTap: (){
      print("Open folder page");
    },);

    return VwCardParameterNodeViewerMaterial(appInstanceParam: this.appInstanceParam, cardParameter: cardParameter, rowNode: rowNode, cardTapper: cardTapper);

  }


}
