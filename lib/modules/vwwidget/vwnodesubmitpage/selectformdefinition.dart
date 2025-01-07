import 'package:matrixclient/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfielddefinition/vwfielddefinition.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'package:matrixclient/modules/base/vwqueryresult/vwqueryresult.dart';
import 'package:matrixclient/modules/deployedcollectionname.dart';
import 'package:matrixclient/modules/util/vwdateutil.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwsectionformdefinition/vwsectionformdefinition.dart';
import 'dart:convert';

class SelectFormDefinition{
  static VwQueryResult formDefinitionNodeChoiceList(List<VwNode> formDefinitionNodeList )  {
    VwQueryResult returnValue=  VwQueryResult(
        rows: [
          ]);

    for(int la=0;la<formDefinitionNodeList.length;la++)
      {
       VwNode currentNode= formDefinitionNodeList.elementAt(la);
       VwRowData currentRowData= new VwRowData(
            creatorUserId: "root",
            timestamp: VwDateUtil.nowTimestamp(),
            recordId: "637e6560-dab9-4846-be78-ac0096c6e05e",
            fields: [
              new VwFieldValue(
                  fieldName: "choiceValue", valueString: currentNode.recordId
              )
            ]
        );

       returnValue.rows.add(currentRowData);
      }

    return returnValue;
  }

  static VwFormDefinition selectRowDataCollectionNameFormDefinition(List<VwNode> formDefinitionNodeList  ){


    VwFormField formField1=VwFormField(fieldDefinition: VwFieldDefinition(fieldName: "collectionName"), fieldUiParam: VwFieldUiParam(
      parameter: SelectFormDefinition.formDefinitionNodeChoiceList(formDefinitionNodeList ),
        uiTypeId: VwFieldUiParam.uitDropdown
    ));

    VwSectionFormDefinition section1= VwSectionFormDefinition(
      formFields: [formField1]
    );

        return VwFormDefinition(recordId: "selectrowdatacollectionnameformdefinition", timestamp: VwDateUtil.nowTimestamp() , formName: "Select RowData Collection Name", sections: [section1], formResponseSyncCollectionName: "<invalid_sync_collection_name>");
  }

  static VwNode selectRowDataCollectionNameFormDefinitionNode(List<VwNode> formDefinitionNodeList ){

    VwFormDefinition formDefinition= SelectFormDefinition.selectRowDataCollectionNameFormDefinition(formDefinitionNodeList);

    String formDefinitionString=json.encode(formDefinition.toJson());
    
    return VwNode(recordId: formDefinition.recordId, ownerUserId: "root", displayName: formDefinition.formName, nodeType: VwNode.ntnClassEncodedJson, content: VwNodeContent(classEncodedJson: VwClassEncodedJson(  className: DeployedCollectionName.vwFormDefinition, instanceId: formDefinition.recordId, data:json.decode(formDefinitionString) )));

  }
}