import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/nodeexplorerdefinition/fieldexplorerdefinition.dart';
import 'package:matrixclient2base/modules/base/nodeexplorerdefinition/nodeexplorerdefinition.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwfielddisplayformat/vwfielddisplayformat.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontentutil.dart';
import 'package:vwform/modules/noderowviewer/noderowviewer.dart';
import 'package:vwform/modules/vwcardparameter/vwcardparameterutil.dart';
import 'package:vwform/modules/vwcardparameter/vwjsonfieldnamecardparameter.dart';
import 'package:vwform/modules/vwmessenger/vwusermessagemessenger.dart';

class VwHeadMessageMessengerRowViewer extends NodeRowViewer
{
  VwHeadMessageMessengerRowViewer({
    super.key,
    required super.appInstanceParam,
    required super.rowNode,
    super.highlightedText,
    super.refreshDataOnParentFunction,
    super.rowViewerBoxContraints,
    super.commandToParentFunction,

    super.localeId
});

  VwNode? getSenderRecord(){







    VwJsonFieldNameCardParameter senderCardParameter= VwJsonFieldNameCardParameter(
        functionName: VwJsonFieldNameCardParameter.fnNodeExplorer,
        nodeExplorerDefinition: NodeExplorerDefinition(
            keyName: "senderDisplayName",
            fieldExplorerList: [
              FieldExplorerDefinition(fieldName: "you", nodeType: VwNode.ntnRowData),

            ]
        )
    );



    VwFieldValue? titleFieldValue =
    VwCardParameterUtil.renderJsonFieldName(
      locale: this.appInstanceParam.baseAppConfig.generalConfig.locale,
        sourceNode: this.rowNode, parameter: senderCardParameter);

   VwNode? returnValue;
    if(titleFieldValue!=null)
    {
      returnValue=titleFieldValue.valueLinkNode!.rendered!.node;


     if(returnValue==null)
       {
         returnValue=titleFieldValue.valueLinkNode!.cache!.node;
       }

    }

    return returnValue;
  }

  String? getTitleText(){

    VwJsonFieldNameCardParameter senderCardParameter= VwJsonFieldNameCardParameter(
        functionName: VwJsonFieldNameCardParameter.fnNodeExplorer,
        nodeExplorerDefinition: NodeExplorerDefinition(
            keyName: "senderDisplayName",
            fieldExplorerList: [
              FieldExplorerDefinition(fieldName: "you", nodeType: VwNode.ntnRowData),
              FieldExplorerDefinition(fieldName: "displayname", nodeType: VwNode.ntnClassEncodedJson)
            ]
        )
    );

    VwFieldValue? titleFieldValue =
    VwCardParameterUtil.renderJsonFieldName(
        locale: this.appInstanceParam.baseAppConfig.generalConfig.locale,
        sourceNode: this.rowNode, parameter: senderCardParameter);

    String? titleText;
    if(titleFieldValue!=null)
    {
      VwFieldDisplayFormat? fieldDisplayFormat =
          senderCardParameter?.fieldDisplayFormat;

      titleText = VwCardParameterUtil.getStringFormFieldValue(
          locale: this.appInstanceParam.baseAppConfig.generalConfig.locale,
          fieldValue: titleFieldValue,
          fieldDisplayFormat: fieldDisplayFormat);
    }

    return titleText;

  }

  String? getMessageText(){

    VwJsonFieldNameCardParameter senderCardParameter= VwJsonFieldNameCardParameter(
        functionName: VwJsonFieldNameCardParameter.fnNodeExplorer,
        nodeExplorerDefinition: NodeExplorerDefinition(
            keyName: "senderDisplayName",
            fieldExplorerList: [
              FieldExplorerDefinition(fieldName: "lastmessage", nodeType: VwNode.ntnRowData),
              FieldExplorerDefinition(fieldName: "message", nodeType: VwNode.ntnRowData),

            ]
        )
    );

    VwFieldValue? titleFieldValue =
    VwCardParameterUtil.renderJsonFieldName(
        locale: this.appInstanceParam.baseAppConfig.generalConfig.locale,
        sourceNode: this.rowNode, parameter: senderCardParameter);

    String? titleText;
    if(titleFieldValue!=null)
    {
      VwFieldDisplayFormat? fieldDisplayFormat =
          senderCardParameter?.fieldDisplayFormat;

      titleText = VwCardParameterUtil.getStringFormFieldValue(
          locale: this.appInstanceParam.baseAppConfig.generalConfig.locale,
          fieldValue: titleFieldValue,
          fieldDisplayFormat: fieldDisplayFormat);
    }

    return titleText;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    String? titleText=this.getTitleText();
    String? messageText= this.getMessageText();

   Widget upperRow=Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(titleText.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),Text(this.rowNode.timestamp!.updated.toString(),style: TextStyle(fontSize: 11),)]);
    Widget lowerRow= Text(messageText.toString(),style: TextStyle(fontSize: 14),);
    Widget textContent=Expanded(child:Column(crossAxisAlignment: CrossAxisAlignment.start, children: [upperRow,lowerRow],));
    Widget usericonWidget=Icon(Icons.account_circle,size: 40,color: Colors.blueGrey, );
    Widget messageWidget=Row(mainAxisAlignment: MainAxisAlignment.start, children: [Container(margin: EdgeInsets.fromLTRB(5, 0, 5, 0), child:usericonWidget),textContent],);

    return InkWell(child: Container(key:this.key, margin: EdgeInsets.fromLTRB(0, 0, 10, 15), child:messageWidget),
    onTap: () async{

      VwNode? senderRecord=getSenderRecord();
      if(senderRecord!=null)
        {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VwUserMessageMessenger(appInstanceParam: this.appInstanceParam, senderRecord: senderRecord)),
          );

          if(this.refreshDataOnParentFunction!=null)
            {
              this.refreshDataOnParentFunction!();
            }


        }

    },
    );
  }
}