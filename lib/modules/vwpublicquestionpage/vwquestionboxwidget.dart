import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icon.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/pagecoordinator/bloc/pagecoordinator_bloc.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwformpage/vwdefaultformpage.dart';
import 'package:vwutil/modules/util/profilepictureutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

typedef PageReloadFunction = void Function();

class VwQuestionBoxWidget extends StatefulWidget {
  VwQuestionBoxWidget(
      {super.key, required this.appInstanceParam, this.pageReloadFunction});

  final PageReloadFunction? pageReloadFunction;

  _VwQuestionBoxWidgetState createState() => _VwQuestionBoxWidgetState();
  final VwAppInstanceParam appInstanceParam;
}

class _VwQuestionBoxWidgetState extends State<VwQuestionBoxWidget> {
  late Key questiontBoxKey;
  late Key formQuestionKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.questiontBoxKey = UniqueKey();
    this.formQuestionKey = UniqueKey();
  }



  Future<void> startQuestionSequence() async {
    if (this.widget.appInstanceParam.loginResponse != null &&
        this.widget.appInstanceParam.loginResponse!.loginSessionId != null) {
      this.openQuestionForm();
    } else {
      this
          .widget
          .appInstanceParam
          .appBloc
          .add(LoginPagecoordinatorEvent(timestamp: DateTime.now()));
    }
  }

  Future<void> openQuestionForm() async {
    Widget questionForm = VwFormPage(
        key: formQuestionKey,
        syncCaption: "Kirim",
        formName: "Surat",
        enableTitle: false,
        loadFormDefinitionFormServer: true,
        formResponse: VwRowData(recordId: Uuid().v4()),
        formDefinition: VwFormDefinition(
            loadDetailFromServer: false,
            formResponseSyncCollectionName:
                "submitquestionarticleformdefinition",
            sections: [],
            timestamp: VwDateUtil.nowTimestamp(),
            formName: "Surat",
            recordId: "submitquestionarticleformdefinition"),
        appInstanceParam: widget.appInstanceParam,
        formDefinitionFolderNodeId: "submitquestionarticleformdefinition");

    /*
    await Navigator.push(
      context,
      MaterialTransparentRoute(
          builder: (context) =>  questionForm),
    );*/

    await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) => questionForm);

    /*
    await Navigator.push(
      context,
      MaterialTransparentRoute(
          builder: (context) => Container(
              color: Colors.black38,
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: questionForm))),
    ); */

    if (this.widget.pageReloadFunction != null) {
      this.widget.pageReloadFunction!();
    }

    /*
    Navigator.push(
      context,
      MaterialTransparentRoute(
          builder: (context) => Container(
              color: Colors.black38,
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: VwWriteQuestion(appInstanceParam: this.widget.appInstanceParam,)))),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: this.widget.key,
        decoration: BoxDecoration(
            //color: Colors.green,

            /*
          border: Border.all(
            width: 1,
            color: Colors.black12,
            style: BorderStyle.solid,
          ),*/
            ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                color: Colors.white,
                constraints: BoxConstraints(minWidth: 200, maxWidth: 600),
                child: Row(children: [
                  SizedBox(
                    width: 12,
                  ),
                  ProfilePictureUtil.getUserProfilePictureOfLoggedInUser(appInstanceParam: this.widget.appInstanceParam),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      await startQuestionSequence();
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                      height: 30,
                      //width:200,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        border: Border.all(
                          width: 1,
                          color: Colors.black12,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  )),
                ])),
            Container(
                padding: EdgeInsets.fromLTRB(70, 0, 0, 10),
                color: Colors.white,
                constraints: BoxConstraints(minWidth: 200, maxWidth: 600),
                child: Row(children: [
                  TextButton.icon(
                    onPressed: () async {
                      await startQuestionSequence();
                    },
                    icon:
                        Icon(Icons.mail_outline_rounded, color: Colors.black87),
                    label: Text(
                      "Kirim Surat",
                      style: TextStyle(color: Colors.black87),
                    ),
                  )
                ])),
            SizedBox(
              height: 20,
            ),
          ],
        ));
    ;
  }
}
