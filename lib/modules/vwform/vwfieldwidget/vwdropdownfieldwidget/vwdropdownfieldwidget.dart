import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:vwform/modules/ios_modal_dropdown/ios_modal_dropdown.dart';
import 'package:vwform/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwutil/modules/util/vwrowdatautil.dart';



class VwDropdownFieldWidget extends StatefulWidget{
  const VwDropdownFieldWidget(
      {Key? key,
        required this.field,
        this.readOnly=false,
        required this.formField,
        this.onValueChanged})
      : super(key: key);

  final VwFieldValue field;
  final bool readOnly;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;

  _VwDropdownFieldWidgetState createState()=>_VwDropdownFieldWidgetState();
}

class _VwDropdownFieldWidgetState extends State<VwDropdownFieldWidget>{
  late List<String> choices;
  late List<int> selectedIndex;





  @override
  void initState() {
    super.initState();

    choices=VwRowDataUtil.getStringList(rowDataList: this.widget.formField.fieldUiParam.parameter!.rows, fieldName: "choiceValue");
    if(this.widget.field.valueString!=null) {
      selectedIndex = getSelectedIndex(
          choices: choices, selectedList: [this.widget.field.valueString!]);
    }
    else{
      selectedIndex=[];
    }

    if(selectedIndex.length==0)
      {
        widget.field.valueString=null;
      }

  }

  List<int> getSelectedIndex({required List<String> choices,required List<String> selectedList}){
    List<int> returnValue=[];
    for(int la=0;la<selectedList.length;la++)
    {
      String currentElement=selectedList.elementAt(la);
      int choiceIndex=choices.indexOf(currentElement);
      if(choiceIndex>=0)
      {
        returnValue.add(choiceIndex);
      }
    }

    return returnValue;
  }


  @override
  Widget build(BuildContext context) {
    Widget captionWidget= VwFieldWidget.getLabel(widget.field,this.widget.formField,DefaultTextStyle.of(context).style,widget.readOnly);
    Widget dropdownWidget= IosModalDropdown (
      isExpanded: true,
            hint: Text(
              '(Select)',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: this.choices
                .map((item) => DropdownMenuItem <String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ))
                .toList(),
            value: widget.field.valueString==null?null:widget.field.valueString,
            onChanged: (value) {
              setState(() {
                widget.field.valueString = value as String;
              });
            },
            buttonStyleData: const ButtonStyleData(
              height: 40,
              //width: 140,
            ),
            menuItemStyleData: const MenuItemStyleDataIos(
              height: 40,
            ),
          );

    Widget clearSelectionButton=Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children:[InkWell(
            onTap: (){
              widget.field.valueString=null;
              this.selectedIndex.clear();

              setState(() {

              });

            },
            child:Text("Clear selection", style: TextStyle(color:Colors.grey)))]);

    Widget optionClearSelectionButton=widget.field.valueString==null?Container(): clearSelectionButton;

    Widget returnValue=Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        captionWidget,
        SizedBox(height: 8,),
        dropdownWidget,
        optionClearSelectionButton
      ],);

    return returnValue;

  }
}