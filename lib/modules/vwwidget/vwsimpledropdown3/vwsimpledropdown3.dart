import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwqueryresult/vwqueryresult.dart';


typedef VwSimpleDropdown3Callback = void Function({required int selectedIndex, String? keyValue, String? displayValue, VwRowData? rowData });

class VwSimpleDropdown3 extends StatefulWidget {
  const VwSimpleDropdown3(
      {Key? key,
      required this.choices,

      this.hint="Pilih...",
      this.initialChoiceKeyValue,
      this.keyFieldName="key",
      this.displayFieldName="display",
      this.callback})
      : super(key: key);

  final VwQueryResult choices;
  final String hint;

  final String? initialChoiceKeyValue;
  final String keyFieldName;
  final String displayFieldName;
  final VwSimpleDropdown3Callback? callback;

  @override
  _VwSimpleDropdown3State createState() => _VwSimpleDropdown3State();
}

class _VwSimpleDropdown3State extends State<VwSimpleDropdown3> {
  late List<String> choicesStringList;

  @override
  void initState() {
    super.initState();

    choicesStringList = _buildChoices();


  }

   bool checkIsExsist({required String text, required List<String> textList}){
    for(int la=0;la<textList.length;la++)
      {
        String currentElement=textList.elementAt(la);
        if(currentElement==text)
          {
            return true;
          }
      }
    return false;
  }

  List<String> _buildChoices() {
    List<String> returnValue = <String>[];

    for (int la = 0; la < this.widget.choices.rows.length; la++) {
      VwRowData currentElement = this.widget.choices.rows.elementAt(la);

      VwFieldValue? displayFieldValue =
          currentElement.getFieldByName(this.widget.displayFieldName);



      if (displayFieldValue != null&& displayFieldValue.valueString!=null  ) {
        returnValue.add(displayFieldValue.valueString!);
      }
    }

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    String? initialValue;

    List<VwRowData> matchList=[];
    if(this.widget.initialChoiceKeyValue!=null) {
      matchList = this.widget.choices.searchValueOnField(
          fieldName: this.widget.keyFieldName,
          value: this.widget.initialChoiceKeyValue!);
    }
    if(matchList.length>0)
      {
        VwRowData currentElement=matchList.elementAt(0);
        VwFieldValue? currentFieldValue=currentElement.getFieldByName(widget.displayFieldName);
        if(currentFieldValue!=null) {
          initialValue = currentFieldValue.valueString;
        }
      }

    return DropdownButton2 (
      //buttonWidth: 170,
      isExpanded: true,
      hint: Text(this.widget.hint),
      items: this.choicesStringList
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 16,
            //fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ))
          .toList(),
      value: initialValue,
      onChanged: (displayValueString) {
        int selectedIndex = -1;

        if (displayValueString != null && displayValueString.length > 0) {
          selectedIndex = choicesStringList.indexOf(displayValueString);
        }

        if (this.widget.callback != null && selectedIndex >= 0) {
          List<VwRowData> matchList = this.widget.choices.searchValueOnField(
              fieldName: widget.displayFieldName, value: displayValueString!);

          if (matchList.length > 0) {
            VwRowData selectedRowData = matchList.elementAt(0);
            if (selectedRowData.fields != null &&
                selectedRowData.fields!.length > 0) {
              VwFieldValue keyFieldvalue = selectedRowData.fields!.elementAt(0);
              if (keyFieldvalue.valueString != null &&
                  keyFieldvalue.valueString!.length > 0) {
                widget.callback!(selectedIndex:selectedIndex,keyValue:keyFieldvalue.valueString,rowData: selectedRowData);
              }
            }
          }
        }
      },
    );
  }
}
