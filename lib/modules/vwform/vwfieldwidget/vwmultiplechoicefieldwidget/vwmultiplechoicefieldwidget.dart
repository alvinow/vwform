import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/util/vwrowdatautil.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';


class VwMultipleChoiceFieldWidget extends StatefulWidget{
  const VwMultipleChoiceFieldWidget(
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

  _VwMultipleChoiceFieldWidgetState createState()=>_VwMultipleChoiceFieldWidgetState();
}

class _VwMultipleChoiceFieldWidgetState extends State<VwMultipleChoiceFieldWidget>{
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
    Widget checklistWidget= GroupButton (

      isRadio: true,
      buttonBuilder: (selected, object, context){




        Widget iconSelected=Icon(Icons.check_circle,color: Theme.of(context).colorScheme.primary);
        Widget iconUnselected=Icon(Icons.circle_outlined,color:Theme.of(context).textTheme.bodyMedium?.color );
        Widget icon=selected==true?iconSelected:iconUnselected;
        return Container(margin:EdgeInsets.fromLTRB(0, 7, 0, 7), child:Row(children:[icon,SizedBox(width:5), Expanded(child:Text(object.toString(),overflow: TextOverflow.ellipsis,maxLines: 5,))]));




      },
      controller: GroupButtonController (
        selectedIndex: selectedIndex.length>0?selectedIndex[0]:null,
        onDisablePressed: (i) => debugPrint('Disable Button #$i pressed'),
      ),
      options: GroupButtonOptions(
        groupingType: GroupingType.column,
        direction: Axis.vertical,
        selectedShadow: const [],
        unselectedShadow: const [],
        unselectedBorderColor: Colors.green,
        unselectedTextStyle: const TextStyle(
          color: Colors.green,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      onSelected: (val, i, selected) {
        if(selected) {
          this.widget.field.valueString = val;
          selectedIndex = getSelectedIndex(
              choices: choices, selectedList: [this.widget.field.valueString!]);
          setState(() {

          });
        }
      },
      buttons:  choices,
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
        child:Text("Clear Selection", style: TextStyle(color:Colors.grey)))]);

    Widget optionClearSelectionButton=widget.field.valueString==null?Container(): clearSelectionButton;

    Widget returnValue=Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        captionWidget,
        SizedBox(height: 8,),
        checklistWidget,
        optionClearSelectionButton
      ],);

    return returnValue;

  }
}