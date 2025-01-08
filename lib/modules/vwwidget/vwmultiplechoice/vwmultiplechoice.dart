import 'package:flutter/cupertino.dart';
import 'package:vwform/modules/vwwidget/vwmultiplechoice/vwmultiplechoicebutton/vwmultiplechoicebutton.dart';


class VwMultipleChoice extends StatefulWidget {
  const VwMultipleChoice(
      {Key? key, required this.choices, this.initialChoice= -1, this.callback,this.isReadOnly=false}):super(key: key);

  final List<String> choices;
  final int initialChoice;
  final bool isReadOnly;
  final VwMultipleChoiceButtonCallback  ? callback;

  @override
  _VwMultipleChoiceState createState() => _VwMultipleChoiceState();
}



class _VwMultipleChoiceState extends State<VwMultipleChoice> {
  int currentIndex = -1;

  @override
  void initState() {
    super.initState();
    this.currentIndex = this.widget.initialChoice;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttonList = <Widget>[];

    for (int la = 0; la < this.widget.choices.length; la++) {
      String currentChoice = this.widget.choices.elementAt(la);

      int initialState = 0;
      if (la == currentIndex) {
        initialState = 1;
      }

      Widget newChoiceButton = Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child:VwMultipleChoiceButton(
        
        choice: currentChoice,
        rowValue: la,
        initialIndex: initialState,
        callback: this._implementCallbackVwMultipleChoiceButton,
        isReadOnly: this.widget.isReadOnly,
      ));
      buttonList.add(newChoiceButton);
    }

    return Column(
      //direction: Axis.vertical,
      //spacing: 10.0,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: buttonList,
    );
  }



  void _implementCallbackVwMultipleChoiceButton(
      int currentState, int rowValue, String choice) {
    this.currentIndex = rowValue;

    if (this.widget.callback != null) {
      this.widget.callback!(currentState, rowValue, choice);
    } else {
      setState(() {});
    }

    // print("Index "+index.toString()+" activeState="+isActiveState.toString()+" value="+value.toString());
  }
}
