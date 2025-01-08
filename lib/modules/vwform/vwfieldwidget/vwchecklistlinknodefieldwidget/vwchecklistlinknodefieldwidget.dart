import 'package:flutter/cupertino.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwchecklistlinknode/vwchecklistlinknode.dart';
import 'package:vwform/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';


class VwCheckListLinkNodeFieldWidget extends StatelessWidget {
  const VwCheckListLinkNodeFieldWidget(
      {Key? key,
      required this.field,
      this.readOnly = false,
      required this.formField,
      this.onValueChanged,
      required this.appInstanceParam,
      this.parentRef,
      required this.getFieldvalueCurrentResponseFunction,

      })
      : super(key: key);

  final VwFieldValue field;
  final bool readOnly;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;


  final VwAppInstanceParam appInstanceParam;
  final VwLinkNode? parentRef;
  final GetCurrentFormResponseFunction getFieldvalueCurrentResponseFunction;

  void implementRefreshDataOnParentFunction(List<VwLinkNode> linkNodeList) {
    /*
    if(field.valueLinkNodeList==null)
      {
        field.valueLinkNodeList=[];
      }*/
    //field.valueLinkNodeList!.clear();
    //field.valueLinkNodeList!.addAll(linkNodeList);
  }

  void _onNodeFieldValueChanged(bool selected,VwNode node){

    this.onValueChanged!(this.field, this.field, true);
  }

  @override
  Widget build(BuildContext context) {
    if (field.valueLinkNodeList == null) {
      field.valueLinkNodeList = [];
    }

    Widget captionWidget = Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: VwFieldWidget.getLabel(this.field, this.formField,
            DefaultTextStyle.of(context).style, this.readOnly));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      captionWidget,
      Container(
          height: 240,
          child: VwCheckListLinkNode(
            formField: this.formField,
            appInstanceParam: appInstanceParam,
              getFieldvalueCurrentResponseFunction:
                  this.getFieldvalueCurrentResponseFunction,
              fieldValue: this.field,
              syncLinkNodeListToParentFunction:
                  this.implementRefreshDataOnParentFunction,
              parentRef: this.parentRef,
              fieldUiParam: this.formField.fieldUiParam))
    ]);
  }
}
