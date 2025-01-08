import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/noderowviewer/noderowviewer.dart';
import 'package:vwform/modules/vwcardparameter/vwcardparameter.dart';
import 'package:vwform/modules/vwwidget/vwcardparameternodeviewermaterial/vwcardparameternodeviewermaterial.dart';

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
