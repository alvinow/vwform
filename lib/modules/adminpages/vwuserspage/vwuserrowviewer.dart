import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:intl/intl.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwdataformattimestamp/vwdataformattimestamp.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfielddefinition/vwfielddefinition.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwuser/vwuser.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/deployedcollectionname.dart';
import 'package:vwform/modules/noderowviewer/noderowviewer.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwsectionformdefinition/vwsectionformdefinition.dart';
import 'package:vwform/modules/vwformpage/vwdefaultformpage.dart';


class VwUserRowViewer extends NodeRowViewer {
  VwUserRowViewer(
      {required super.rowNode,
        required super.appInstanceParam,
        super.highlightedText,super.refreshDataOnParentFunction,
      });



  @override
  Widget build(BuildContext context) {
    Widget returnValue = Text(rowNode.recordId);

    Map<String, HighlightedWord> words = {};

    if (this.highlightedText != null) {
      words = {
        this.highlightedText!: HighlightedWord(
          onTap: () {
            print("this.highlightedText");
          },
          textStyle: TextStyle(backgroundColor: Colors.yellow),
        ),
      };
    }

    var f = NumberFormat.simpleCurrency(locale: 'id_ID');

    try {
      if (rowNode.content != null &&
          rowNode.content.linkbasemodel != null &&
          rowNode.content.linkbasemodel!.rendered!=null &&

          rowNode.content.linkbasemodel!.rendered!.data!=null &&
          rowNode.content.linkbasemodel!.rendered!.className== "VwUser")

               {
        VwUser user =
        VwUser.fromJson(rowNode.content.linkbasemodel!.rendered!.data!);

        Widget captionRow=Expanded(flex:5, child:Container( child:Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            user.username,
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900),
          ),
          Text(user.displayname, overflow: TextOverflow.visible,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(user.email, overflow: TextOverflow.visible,style: TextStyle(fontSize: 14,fontStyle: FontStyle.italic)),
         // Text(DateFormat('dd-MMM-yyyy HH:mm', 'id_ID').format(user.timestamp.updated)),
        ])));

        Widget iconRow=Container(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),  child: Icon(Icons.person_sharp,color: Colors.black,size: 40,),);

        Widget row=Flexible(child:Container(padding: EdgeInsets.all(10),  child: Row(children: [iconRow,captionRow])));


        VwFormDefinition formParam=createVwFormParamFromVwUser(node:this.rowNode,user: user);

        returnValue = InkWell(
            onTap: () async{
              print("form tapped");
              //formParam.response.recordId=Uuid().v4();
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VwFormPage(
                      //readOnly: true,
                      formDefinitionFolderNodeId: this.appInstanceParam.baseAppConfig.generalConfig.formDefinitionFolderNodeId,
                      appInstanceParam: this.appInstanceParam,
                      formDefinition: formParam,
                      formResponse: VwFormDefinitionUtil.createBlankRowDataFromFormDefinition(formDefinition: formParam, ownerUserId: appInstanceParam.loginResponse!.userInfo!.user.recordId),
                      refreshDataOnParentFunction: this.refreshDataOnParentFunction,)),
              );


            },
            child: row
        );
      }
    } catch (error) {
      returnValue = Text(rowNode.recordId + ': Error=' + error.toString());
    }

    return returnValue;
  }



  VwFormDefinition createVwFormParamFromVwUser({required VwNode node, required VwUser user}){

    VwFieldValue recordIdFieldValue=VwFieldValue(fieldName: "recordId",valueString: user.recordId);
    VwFieldValue createdFieldValue=VwFieldValue(fieldName: "timestamp.created",valueString:node.timestamp!=null?DateFormat('dd-MMM-yyyy HH:mm', 'id_ID').format(node.timestamp!.created):null );
    VwFieldValue updatedFieldValue=VwFieldValue(fieldName: "timestamp.updated",valueString:node.timestamp!=null?DateFormat('dd-MMM-yyyy HH:mm', 'id_ID').format(node.timestamp!.updated):null );
    VwFieldValue usernameFieldValue=VwFieldValue(fieldName: "username",valueString: user.username);
    VwFieldValue displaynameFieldValue=VwFieldValue(fieldName: "displayname",valueString: user.displayname);
    VwFieldValue emailFieldValue = VwFieldValue(fieldName: "email",valueString: user.email);
    VwFieldValue userStatusIdFieldValue=VwFieldValue(fieldName: "userStatusId",valueString: user.userStatusId);


    VwFormField userFormField=VwFormField( fieldDefinition: VwFieldDefinition(fieldName: "recordId"), fieldUiParam: VwFieldUiParam());
    VwFormField timestampCreatedFormField=VwFormField(fieldDefinition: VwFieldDefinition(fieldName: "timestamp.created") ,fieldUiParam: VwFieldUiParam());
    VwFormField timestampUpdatedFormField=VwFormField(fieldDefinition: VwFieldDefinition(fieldName: "timestamp.updated",),  fieldUiParam: VwFieldUiParam());
    VwFormField usernameFormField=VwFormField(fieldDefinition: VwFieldDefinition(fieldName: "username",),fieldUiParam: VwFieldUiParam(caption:"Username"));
    VwFormField displaynameFormField=VwFormField(fieldDefinition: VwFieldDefinition(fieldName: "displayname",),fieldUiParam: VwFieldUiParam(caption:"Display Name"));
    VwFormField emailFormField=VwFormField(fieldDefinition: VwFieldDefinition(fieldName: "email",),fieldUiParam: VwFieldUiParam(caption:"e-mail"));
    VwFormField userStatusIdFormField=VwFormField(fieldDefinition: VwFieldDefinition(fieldName: "userStatusId",),fieldUiParam: VwFieldUiParam(caption:"User Status "));


    VwSectionFormDefinition section1=VwSectionFormDefinition(formFields: [

      usernameFormField,
      displaynameFormField,
      emailFormField,
      userStatusIdFormField
    ]);



    String formDefinitionId=Uuid().v4();
    VwFormDefinition returnValue= VwFormDefinition(recordId: formDefinitionId, formResponseSyncCollectionName: DeployedCollectionName.vwUser, timestamp: VwDataFormatTimestamp(created: DateTime.now(), updated: DateTime.now()), formName: "User",  sections: [section1]);

    return returnValue;
    //return VwFormParam(recordId: Uuid().v4(), timestamp: VwDataFormatTimestamp(created: DateTime.now(), updated: DateTime.now()), formName: "User", formResponse: formResponse, sectionFormParams: sectionFormParams)
  }
}
