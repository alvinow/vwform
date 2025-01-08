import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/branchviewer/branchviewer.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/branchviewer/childbranch.dart';
import 'package:vwform/modules/vwwidget/vwformresponseuserpage/vwdefaultrowviewer/vwdefaultrowviewer.dart';

class SubBranchViewer extends StatefulWidget{
  SubBranchViewer({required super.key, required this.parentNode, required this.childBranch,required this.appInstanceParam,required this.summaryId,required this.localeId,this.refreshBranch,this.commandToParentFunction});

  final String localeId;
  final String summaryId;
  final VwNode parentNode;
  final ChildBranch childBranch;
  final VwAppInstanceParam appInstanceParam;
  final RefreshDataOnParentFunction? refreshBranch;
  final CommandToParentFunction? commandToParentFunction;

  SubBranchViewerState createState()=>SubBranchViewerState();
}

class SubBranchViewerState extends State<SubBranchViewer>{
  late bool currentExpandedState;
  late Key branchKey;

  Widget nodeRowViewer(
      {required VwNode renderedNode,
        required BuildContext context,
        required int index,
        Widget? topRowWidget,
        String? highlightedText,
        RefreshDataOnParentFunction? refreshDataOnParentFunction,
        CommandToParentFunction? commandToParentFunction}) {
    if (renderedNode.nodeType == VwNode.ntnTopNodeInsert) {
      if (topRowWidget != null) {
        return topRowWidget;
      } else {
        return Container();
      }
    }

    return VwDefaultRowViewer(
      key:Key(renderedNode.recordId),
      rowNode: renderedNode,
      appInstanceParam: this.widget.appInstanceParam,
      highlightedText: highlightedText,
      refreshDataOnParentFunction:
      this.implementRefreshBranch,
      commandToParentFunction: this.implementCommandToRefeshFunction,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.currentExpandedState=widget.childBranch.isInitiallyExpanded;
    this.branchKey=Key(Uuid().v4());
  }

  Widget buttonExpandBranchCurrentlyExpanded() {




    return InkWell(
      child: BranchviewerState.iconCircleDown(),
      onTap: () {
        setState(() {
          this.currentExpandedState = false;
        });
      },
    );
  }

  Widget buttonExpandBranchCurrentlyNotExpanded() {
    return InkWell(
      child: BranchviewerState.iconCircleRight(),
      onTap: () {
        setState(() {
          this.currentExpandedState = true;
        });
      },
    );
  }

  void implementCommandToRefeshFunction(VwRowData formResponse){

    if(widget.commandToParentFunction!=null)
      {
        widget.commandToParentFunction!(formResponse);
      }



  }

  void implementRefreshBranch() {
    try {
      print("Refresh:" + widget.parentNode.content!.rowData!.collectionName!);


      if (this.widget.refreshBranch != null) {
        this.widget.refreshBranch!();
      }

      setState(() {
        this.branchKey = Key(Uuid().v4());
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {

    Widget returnValue=Container();
    try {
      Widget createButton = BranchviewerState.getCreateRecordButtonChildBranch(
          childBranch:
          widget.childBranch,
          context: context,
          refreshDataOnParentFunction: this.implementRefreshBranch,
          appInstanceParam: widget.appInstanceParam);

      Widget branchWidget = NodeListView(
          key: this.branchKey,
          zeroDataCaption: "0 record",
          reloadButtonSize: 18,
          enableAppBar: false,
          isScrollable: false,
          enableScaffold: false,

          appInstanceParam: widget.appInstanceParam,
          apiCallParam: BranchviewerState.apiCallParam(
              widget.childBranch),
          nodeRowViewerFunction: nodeRowViewer);




      if(this.currentExpandedState==true)
        {
          return
            Column(
              key:widget.key,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [this.widget.childBranch.hideExpandedButton?SizedBox(width: 20,): this.buttonExpandBranchCurrentlyExpanded(),createButton],),
                branchWidget
              ],
            );
        }
      else
        {
          return
            Column(
              key:widget.key,
              children: [
                Row(children: [this.buttonExpandBranchCurrentlyNotExpanded(),createButton],),

              ],
            );


        }

    }
    catch(error)
    {

    }
    return returnValue;


  }

}