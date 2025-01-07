import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidgetutil.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwwidget/vwcardparameternodeviewermaterial/vwcardparameternodeviewermaterial.dart';
import 'package:matrixclient/modules/vwwidget/vwselectnoderecordpage/vwselectnoderecordpage.dart';

class VwDropDownLinkNodeFieldWidget extends StatefulWidget {
  const VwDropDownLinkNodeFieldWidget(
      {super.key,
        required this.field,
        this.readOnly = false,
        required this.formField,
        this.onValueChanged,
        required this.appInstanceParam,
        this.showChoiceButton = true,
        required this.getFieldvalueCurrentResponseFunction});

  final VwFieldValue field;
  final bool readOnly;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;
  final VwAppInstanceParam appInstanceParam;
  final bool showChoiceButton;
  final GetCurrentFormResponseFunction getFieldvalueCurrentResponseFunction;

  VwDropdownLinkNodeFieldWidgetState createState() =>
      VwDropdownLinkNodeFieldWidgetState();
}

class VwDropdownLinkNodeFieldWidgetState
    extends State<VwDropDownLinkNodeFieldWidget> {
  void implementRefreshDataOnParentFunction() {
    print("refresh data from isi form");
    setState(() {});
  }


  String? getNodeContextId(){
    String? returnValue;
    try
    {
      /*
      if(this.widget.getFieldvalueCurrentResponseFunction().formDefinitionId=="vwticket")
        {
        VwFieldValue? ticketEventDefinitionFieldValue=  this.widget.getFieldvalueCurrentResponseFunction().getFieldByName("ticketEventDefinition");

        if(ticketEventDefinitionFieldValue!=null &&  ticketEventDefinitionFieldValue.valueLinkNode!=null)

          if(ticketEventDefinitionFieldValue!.valueLinkNode!.nodeId=="0706dc53-63a0-48b1-ba76-93efc3a6bcb5")
            {
              returnValue="8d15f933-b054-4ead-83d7-9b812183e36b";
            }
          else if(ticketEventDefinitionFieldValue!.valueLinkNode!.nodeId=="fe7f851c-e1ef-47f2-9f41-4b4b1e84ac80")
            {
              returnValue="a72012ca-c47f-452c-b640-2d6a07ee7022";
            }

        }
      else if(this.widget.getFieldvalueCurrentResponseFunction().formDefinitionId=="rekomendasisubtemuanlhpformdefinition")
      {
       VwRowData? currentRowData= this.widget.getFieldvalueCurrentResponseFunction();

       VwFieldValue? subtemuanlhpFieldValue=currentRowData!.getFieldByName!("subtemuanlhp");

       if(subtemuanlhpFieldValue!=null)
         {
           returnValue=subtemuanlhpFieldValue.valueLinkNode!.nodeId!;
         }

      }
*/
    }
    catch(error)
    {

    }

    return returnValue;
  }

  String? getTicketAccessMethodParameter1(){
    String? returnValue;
    try
        {
        for(int la=0 ;la<this.widget.appInstanceParam.loginResponse!.userInfo!.roleInfoList!.length;la++)
          {
            VwRowData currentRowData=this.widget.appInstanceParam.loginResponse!.userInfo!.roleInfoList!.elementAt(la);

            if(currentRowData.collectionName=="vwticketusergroup")
              {
                returnValue=currentRowData.getFieldByName("ticketAccessMethodParameter1")!.valueString.toString();
                break;

              }
          }

        }
        catch(error)
    {

    }

    return returnValue;

  }

  Map<String,dynamic>? contextNodeFilter(){
    Map<String,dynamic>? returnValue;
    try
    {
      /*
      if(this.widget.getFieldvalueCurrentResponseFunction().formDefinitionId=="vwticket")
      {
        VwFieldValue? ticketEventDefinitionFieldValue=  this.widget.getFieldvalueCurrentResponseFunction().getFieldByName("ticketEventDefinition");





        if(ticketEventDefinitionFieldValue!=null &&  ticketEventDefinitionFieldValue.valueLinkNode!=null)

          if(ticketEventDefinitionFieldValue!.valueLinkNode!.nodeId=="0706dc53-63a0-48b1-ba76-93efc3a6bcb5")
          {
            returnValue={
              "content.rowData.fields": {
                r"$all": [
                  {
                    r"$elemMatch": { "fieldName": "jenisTransaksiInduk", "valueString": { r"$in": ["spby"] } }
                  },
                  {
                    r"$elemMatch": { "fieldName": "NIP_PPK", "valueString": { r"$in": [this.getTicketAccessMethodParameter1()] } }
                  },
                ]
              }

            };
          }
          else if(ticketEventDefinitionFieldValue!.valueLinkNode!.nodeId=="fe7f851c-e1ef-47f2-9f41-4b4b1e84ac80")
          {
            returnValue={
              "content.rowData.fields": {
                r"$all": [
                  {
                    r"$elemMatch": { "fieldName": "jenisTransaksiInduk", "valueString": { r"$in": ["spp"] } }
                  },
                  {
                    r"$elemMatch": { "fieldName": "NIP_PPK", "valueString": { r"$in": [this.getTicketAccessMethodParameter1()] } }
                  },
                ]
              }

            };
          }

      }
*/

    }
    catch(error)
    {

    }


    return returnValue;

  }


  void _implementFieldValueChanged(VwLinkNode? linkNode){

    if(this.widget.onValueChanged!=null)
      {
        this.widget.onValueChanged!(this.widget.field,this.widget.field,true);
      }

  }

  Widget buildFieldDisplay() {
    Widget returnValue=Text("(Error : Error occured when displaying value)");
    try {
      Widget captionWidget = VwFieldWidget.getLabel(
          widget.field,
          this.widget.formField,
          DefaultTextStyle
              .of(context)
              .style,
          widget.readOnly);

      String emptyText = "(kosong)";

      String recordIdValue = widget.field.valueLinkNode != null
          ? "recordId: " + widget.field.valueLinkNode!.nodeId
          : emptyText;

      String collectionNameValue = widget.field.valueLinkNode != null &&
          widget.field.valueLinkNode!.contentContext != null &&
          widget.field.valueLinkNode!.contentContext!.collectionName != null
          ? widget.field.valueLinkNode!.contentContext!.collectionName!
          : emptyText;

      String titleFieldName = widget.formField.fieldUiParam
          .collectionListViewDefinition!.cardParameter.titleFieldName;

      String titleSubFieldName = widget.formField.fieldUiParam
          .collectionListViewDefinition!.cardParameter.titleSubFieldName
          .toString();

      String? title = recordIdValue;

      if (this.widget.field.valueLinkNode != null &&  NodeUtil.extractNodeFromLinkNode(this.widget.field.valueLinkNode!)!=null) {
        String? titleFieldValue;
        VwNode? currentNode =
        NodeUtil.extractNodeFromLinkNode(this.widget.field.valueLinkNode!);

        titleFieldValue = NodeUtil
            .getValueStringFromContentRecordCollectionWithEnabledSubFieldName(
            currentNode!, titleFieldName, titleSubFieldName);



        if (titleFieldValue != null) {
          title = titleFieldValue;
        }
      }

      //String? constrainLinkBaseModelCollectionName=widget.formField.fieldDefinition.fieldConstraint.collectionName;

      Widget? valueWidget;

      InkWell cardTapper = InkWell(onTap: () {});
      Widget clearSelectionWidget = Container();


      if (widget.showChoiceButton == true &&
          widget.readOnly == false &&
          widget.formField.fieldUiParam.isReadOnly == false) {
        clearSelectionWidget =
        this.widget.field.valueLinkNode != null ? InkWell(
            onTap: () {
              this.widget.field.valueLinkNode = null;
              this.implementRefreshDataOnParentFunction();
            },
            child: Container(margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Kosongkan Piihan",
                        style: TextStyle(color: Colors.grey),),
                    ]))

        ) : Container();
        cardTapper = InkWell(onTap: () {
          List<VwLinkNode>? candidateRecords = [];
          if (this.widget.formField.fieldUiParam.uiTypeId ==
              VwFieldUiParam.uitDropdownLinkNodeByLocalFieldSource &&
              widget.formField.fieldUiParam.localFieldRef != null) {
            VwRowData formResponse =
            widget.getFieldvalueCurrentResponseFunction();

            VwFieldValue? refInternalFieldValue =
            VwFieldWidgetUtil.getInternalOfFielValueFromRowData(
                source: formResponse,
                localFieldRef: widget.formField.fieldUiParam.localFieldRef!);

            if (refInternalFieldValue != null) {
              if (refInternalFieldValue.valueTypeId ==
                  VwFieldValue.vatValueLinkNodeList &&
                  refInternalFieldValue.valueLinkNodeList != null &&
                  refInternalFieldValue.valueLinkNodeList!.length > 0) {
                candidateRecords = refInternalFieldValue.valueLinkNodeList;
              } else if (refInternalFieldValue.valueTypeId ==
                  VwFieldValue.vatValueLinkNode &&
                  refInternalFieldValue.valueLinkNode != null) {
                candidateRecords.add(refInternalFieldValue.valueLinkNode!);
              }
            }
          } else
          if (widget.formField.fieldUiParam.collectionListViewDefinition !=
              null &&
              widget.formField.fieldUiParam.collectionListViewDefinition!
                  .staticRefLinkNodeList !=
                  null) {
            candidateRecords = widget.formField.fieldUiParam
                .collectionListViewDefinition!.staticRefLinkNodeList!;
          }




          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VwSelectNodeRecordPage(
                      parentFormResponse: this.widget.getFieldvalueCurrentResponseFunction==null?null:this.widget.getFieldvalueCurrentResponseFunction(),
                      getNodeContextId: this.getNodeContextId(),
                      contextNodeFilter: this.contextNodeFilter(),
                      onChanged: this._implementFieldValueChanged,
                      field: widget.field,
                      candidateRecords: candidateRecords,
                      formField: widget.formField,
                      appInstanceParam: widget.appInstanceParam,
                      refreshDataOnParentFunction:
                      this.implementRefreshDataOnParentFunction,
                    )),
          );
        });
      }
      VwNode? rowNode = widget.field.valueLinkNode != null
          ? NodeUtil.getNode(linkNode: widget.field.valueLinkNode!)
          : null;

      if (widget.formField.fieldUiParam.collectionListViewDefinition != null &&
          widget.formField.fieldUiParam.collectionListViewDefinition!
              .cardParameter !=
              null &&
          rowNode != null) {
        if (rowNode != null) {
          valueWidget = VwCardParameterNodeViewerMaterial(
              appInstanceParam: this.widget.appInstanceParam,
              cardParameter: widget.formField.fieldUiParam
                  .collectionListViewDefinition!.cardParameter,
              rowNode: rowNode,
              cardTapper: cardTapper);
        }
      }
      Widget selectButtonWidget =
      widget.formField.fieldUiParam.isReadOnly == false
          ? Icon(
        Icons.keyboard_arrow_down,
        size: 40,
        color: Colors.black,
      )
          : Container();

      if (valueWidget == null) {
        valueWidget = InkWell(
          child: Container(
              padding: EdgeInsets.all(3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                      child: Text(title,
                          style: TextStyle(fontSize: 18, color: Colors.grey))),
                  title == emptyText
                      ? Container()
                      : Text(
                    collectionNameValue,
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              )),
          onTap: cardTapper.onTap,
        );
      }


      returnValue =
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 6), child: captionWidget),
        Container(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: valueWidget),
                widget.showChoiceButton == true
                    ? selectButtonWidget
                    : Container()
              ]),

            ])),
        clearSelectionWidget
      ]);
    }
    catch(error)
    {
      print("error catched when displaying Value");
    }
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return buildFieldDisplay();
  }
}
