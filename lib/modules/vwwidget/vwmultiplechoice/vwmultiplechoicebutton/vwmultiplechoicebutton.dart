import 'package:flutter/material.dart';

typedef VwMultipleChoiceButtonCallback = void Function(int, int, String);

class VwMultipleChoiceButton extends StatelessWidget {
  const VwMultipleChoiceButton(
      {Key? key, required this.choice,
      required this.rowValue,
      this.initialIndex= -1,
      this.callback,
      this.isReadOnly= false}):super(key: key);

  final String choice;
  final int rowValue;
  final int initialIndex;
  final bool isReadOnly;
  final VwMultipleChoiceButtonCallback? callback;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: _VwInternalButtonMultipleChoiceWidget(
        stateIndex: this.initialIndex,
        choiceCaption: this.choice,
      ),
      onTap: () {
        if (this.isReadOnly == false) {
          if (this.callback != null) {
            this.callback!(this.initialIndex, this.rowValue, this.choice);
          }
        }
        //setState(() {});
      },
    );
  }
}

class _VwInternalButtonMultipleChoiceWidget extends StatelessWidget {
  const _VwInternalButtonMultipleChoiceWidget(
      {required this.stateIndex, required this.choiceCaption});

  final int stateIndex;
  final String choiceCaption;

  @override
  Widget build(BuildContext context) {
    return this.getWidgetBasedOnIndex(this.stateIndex,context);
  }

  Widget getWidgetBasedOnIndex(int index,BuildContext context) {
    Widget returnValue = Container();

    Widget button = const Icon(Icons.radio_button_off);

    if (index == 1) {
      button = const Icon(Icons.radio_button_on);
    }

    Widget caption = Container(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 84),
      child: Text(this.choiceCaption),
    );

    returnValue = Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center,  direction: Axis.horizontal, children: [button,caption]);


    return returnValue;
  }
}
