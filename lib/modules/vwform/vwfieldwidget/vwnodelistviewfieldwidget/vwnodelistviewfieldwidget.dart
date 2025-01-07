import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwchecklistlinknode/vwchecklistlinknode.dart';

class VwNodeListViewFieldWidget extends StatelessWidget {
  const VwNodeListViewFieldWidget({

    Key? key,
    required this.field,
    this.readOnly = false,
    required this.formField,
    this.onValueChanged,
    required this.appInstanceParam,
    this.parentRef,
    required this.getFieldvalueCurrentResponseFunction,
    required this.getCurrentFormDefinitionFunction
  })
      : super(key: key);

  final VwFieldValue field;
  final bool readOnly;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;
  final VwAppInstanceParam appInstanceParam;
  final VwLinkNode? parentRef;
  final GetCurrentFormResponseFunction getFieldvalueCurrentResponseFunction;
  final GetCurrentFormDefinitionFunction getCurrentFormDefinitionFunction;

  @override
  Widget build(BuildContext context) {
    if(field.valueLinkNodeList==null)
    {
      field.valueLinkNodeList=[];
    }

    Widget captionWidget= Container( margin: EdgeInsets.fromLTRB(0, 0, 0, 5), child:VwFieldWidget.getLabel(this.field,this.formField,DefaultTextStyle.of(context).style,this.readOnly));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          captionWidget,
          Container(height:240,child: VwCheckListLinkNode (formField: this.formField,  getFieldvalueCurrentResponseFunction: this.getFieldvalueCurrentResponseFunction,isReadOnly: true,  fieldValue: this.field, syncLinkNodeListToParentFunction:this.implementRefreshDataOnParentFunction , parentRef: this.parentRef, appInstanceParam: this.appInstanceParam,  fieldUiParam: this.formField.fieldUiParam))]);

  }

  void implementRefreshDataOnParentFunction(List<VwLinkNode> linkNodeList){

    /*
    if(field.valueLinkNodeList==null)
      {
        field.valueLinkNodeList=[];
      }*/
    //field.valueLinkNodeList!.clear();
    //field.valueLinkNodeList!.addAll(linkNodeList);
  }
}