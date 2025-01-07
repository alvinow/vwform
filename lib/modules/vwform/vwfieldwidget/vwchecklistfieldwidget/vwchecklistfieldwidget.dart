import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:vwform/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwutil/modules/util/vwrowdatautil.dart';


class VwChecklistFieldWidget extends StatefulWidget {
  const VwChecklistFieldWidget(
      {required Key key,
      required this.field,
      this.readOnly = false,
      required this.formField,
      this.onValueChanged})
      : super(key: key);

  final VwFieldValue field;
  final bool readOnly;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;

  _VwChecklistFieldWidgetState createState() => _VwChecklistFieldWidgetState();
}

class _VwChecklistFieldWidgetState extends State<VwChecklistFieldWidget> {
  late List<String> choices;
  late List<int> selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.widget.field.valueStringList == null) {
      this.widget.field.valueStringList = [];
    }
    choices = VwRowDataUtil.getStringList(
        rowDataList: this.widget.formField.fieldUiParam.parameter!.rows,
        fieldName: "choiceValue");
    if (this.widget.field.valueStringList != null) {
      selectedIndex = getSelectedIndex(
          choices: choices, selectedList: this.widget.field.valueStringList!);
    }
  }

  List<int> getSelectedIndex(
      {required List<String> choices, required List<String> selectedList}) {
    List<int> returnValue = [];
    for (int la = 0; la < selectedList.length; la++) {
      String currentElement = selectedList.elementAt(la);
      int choiceIndex = choices.indexOf(currentElement);
      if (choiceIndex >= 0) {
        returnValue.add(choiceIndex);
      }
    }

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    Widget captionWidget = VwFieldWidget.getLabel(
        widget.field,
        this.widget.formField,
        DefaultTextStyle.of(context).style,
        widget.readOnly);
    Widget checklistWidget = GroupButton(
      key: this.widget.key,
      isRadio: false,
      buttonBuilder: (selected, object, context) {
        Widget iconSelected = Icon(Icons.check_box_sharp,
            color: Theme.of(context).colorScheme.primary);
        Widget iconUnselected = Icon(Icons.check_box_outline_blank_sharp,
            color: Theme.of(context).textTheme.bodyMedium?.color);
        Widget icon = selected == true ? iconSelected : iconUnselected;
        return Container(
          key: Key(object.toString()),
            margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
            child: Row(children: [
              icon,
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Text(
                object.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ))
            ]));
      },
      controller: GroupButtonController(
        selectedIndexes: selectedIndex,
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
        if (this.widget.readOnly == false) {
          if (selected == true) {
            int currentIndexOnSelected =
                this.widget.field.valueStringList!.indexOf(val);
            if (currentIndexOnSelected < 0) {
              this.widget.field.valueStringList!.add(val.toString());
            }
          } else {
            while (this.widget.field.valueStringList!.indexOf(val) >= 0) {
              this.widget.field.valueStringList!.remove(val.toString());
            }
          }

          if (this.widget.field.valueStringList != null) {
            selectedIndex = getSelectedIndex(
                choices: choices, selectedList: this.widget.field.valueStringList!);
          }
          debugPrint('Button: $val index: $i $selected');
        }
      },
      buttons: choices,
    );



    Widget returnValue = Column(
      key: this.widget.key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        captionWidget,
        SizedBox(
          height: 8,
        ),
        IgnorePointer(ignoring: widget.readOnly, child: checklistWidget,)

      ],
    );

    return returnValue;
  }
}
