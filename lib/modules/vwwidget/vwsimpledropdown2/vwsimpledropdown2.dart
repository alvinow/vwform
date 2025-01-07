import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/vwwidget/vwsimpledropdown/vwsimpledropdown.dart';

class VwSimpleDropdown2 extends StatefulWidget {
  const VwSimpleDropdown2(
      {Key? key,
      required this.choices,
      this.caption,
      required this.initialChoice,
      this.callback,
      this.buttonWidth=170,
        this.hint,
        this.isEnabledExpanded=false
      })
      : super(key: key);

  final List<String> choices;
  final String? caption;
  final int initialChoice;
  final VwSimpleDropdownCallback? callback;
  final double buttonWidth;
  final String? hint;
  final bool isEnabledExpanded;

  static String hintDefault="(Select)";

  @override
  _VwSimpleDropdown2State createState() => _VwSimpleDropdown2State();
}

class _VwSimpleDropdown2State extends State<VwSimpleDropdown2> {
  @override
  Widget build(BuildContext context) {
    String? initialChoiceValue;

    if (this.widget.initialChoice >= 0) {
      initialChoiceValue =
          this.widget.choices.elementAt(this.widget.initialChoice);
    }

    final List<String> items = [
      'Item1',
      'Item2',
      'Item3',
      'Item4',
      'Item5',
      'Item6',
      'Item7',
      'Item8',
    ];
    String? selectedValue;


    Widget returnValue=DropdownButton2(
      isExpanded: this.widget.isEnabledExpanded,
      //buttonWidth: this.widget.buttonWidth,
      hint: Text(this.widget.hint==null? VwSimpleDropdown2.hintDefault:this.widget.hint!,style: TextStyle(fontSize: 16,color:Colors.grey),),
      items: this.widget.choices
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
      value: initialChoiceValue,
      onChanged: (stringValue) {
        int selectedIndex = -1;

        if (stringValue != null) {
          for (int la = 0; la < this.widget.choices.length; la++) {
            String currentValue = this.widget.choices.elementAt(la);
            if (currentValue == stringValue) {
              selectedIndex = la;
              break;
            }
          }
        }

        if (this.widget.callback != null) {
          this.widget.callback!(selectedIndex, stringValue);
        }
      },
    );

    if(this.widget.isEnabledExpanded==false) {
      returnValue =
          SizedBox(width: this.widget.buttonWidth, child: returnValue);
    }

    return returnValue;


  }
}
