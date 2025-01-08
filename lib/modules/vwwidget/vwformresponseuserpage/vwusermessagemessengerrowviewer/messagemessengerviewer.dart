import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


class MessageMessengerViewer extends StatefulWidget {
  MessageMessengerViewer(
      {required this.nodeId,
      required this.textMessage,
      required this.dateTime,
      this.localeId = "id_ID",
      this.backgroundColor = Colors.blueGrey,
      this.textColor = Colors.white,
      this.dateTimeColor = Colors.white70,
      this.rowMainAxisAlignment = MainAxisAlignment.start});

  final String nodeId;
  final String textMessage;
  final DateTime dateTime;
  final String localeId;
  final Color backgroundColor;
  final Color textColor;
  final Color dateTimeColor;
  final MainAxisAlignment rowMainAxisAlignment;

  MessageMessengerViewerState createState() => MessageMessengerViewerState();
}

class MessageMessengerViewerState extends State<MessageMessengerViewer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        key: Key(this.widget.nodeId),
        builder: (context, constraint) {
          Widget dateWidget = Text(
            DateFormat.yMMMd(this.widget.localeId)
                    .format(this.widget.dateTime)
                    .toString() +
                " - " +
                DateFormat.Hms(this.widget.localeId)
                    .format(this.widget.dateTime)
                    .toString(),
            style: TextStyle(fontSize: 11, color: Colors.white70),
          );

          Text textMessageWidget = Text(
            this.widget.textMessage.toString(),
            textAlign: widget.rowMainAxisAlignment == MainAxisAlignment.end
                ? TextAlign.end
                : TextAlign.start,
            style: TextStyle(fontSize: 14, color: Colors.white),
          );

          Widget messageWidget = Row(
              mainAxisAlignment: this.widget.rowMainAxisAlignment,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: this.widget.backgroundColor,
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.fromLTRB(0, 2, 10, 2),
                    constraints:
                        BoxConstraints(maxWidth: constraint.maxWidth * 0.85),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: textMessageWidget),
                          Column(
                            children: [
                              Text(" "),
                              Container(
                                  margin: EdgeInsets.fromLTRB(8, 8, 0, 0),
                                  child: dateWidget)
                            ],
                          )
                        ]))
              ]);

          Widget messageWidget2 = Container(
            alignment: widget.rowMainAxisAlignment == MainAxisAlignment.end
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: this.widget.backgroundColor,
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Wrap(
                                alignment: WrapAlignment.start,
                                children: [textMessageWidget])),
                        dateWidget
                      ],
                    ))
              ],
            ),
          );

          return messageWidget2;
        });
  }
}
