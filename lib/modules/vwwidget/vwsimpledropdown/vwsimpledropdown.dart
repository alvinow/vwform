
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

typedef VwSimpleDropdownCallback = void Function(int, String?);

class VwSimpleDropdown extends StatefulWidget {
  const VwSimpleDropdown(
      {Key? key,
      required this.choices,
      required this.caption,
      required this.initialChoice,
      this.callback})
      : super(key: key);

  final List<String> choices;
  final String caption;
  final int initialChoice;
  final VwSimpleDropdownCallback? callback;

  @override
  _VwSimpleDropdownState createState() => _VwSimpleDropdownState();
}

class _VwSimpleDropdownState extends State<VwSimpleDropdown> {
  @override
  Widget build(BuildContext context) {
    String? initialChoiceValue;

    if (this.widget.initialChoice >= 0) {
      initialChoiceValue = this.widget.choices.elementAt(this.widget.initialChoice);
    }

    return DropdownSearch <String>(
      //mode: Mode.MENU,
      //showSelectedItems: true,
      popupProps: PopupProps.menu(
        showSelectedItems: true,
        disabledItemFn: (String s) => s.startsWith('I'),

      ),

      items:  (filter, infiniteScrollProps)=> this.widget.choices,
      //showClearButton: true,
      decoratorProps: DropDownDecoratorProps (
        decoration: InputDecoration(

          labelText: this.widget.caption,
          hintText: this.widget.caption,

          labelStyle: const TextStyle(fontSize: 18, color: Colors.black45,),
        ),
      ),



      //hint: "country in menu mode",

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
      selectedItem:  initialChoiceValue,
    );
  }
}
