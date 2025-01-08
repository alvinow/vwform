import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformvalidationresponse.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediainstanceparam/vwmultimediaviewerinstanceparam.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediaviewer.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediaviewerparam/vwmultimediaviewerparam.dart';
import 'package:vwform/modules/vwwidget/materialtransparentroute/materialtransparentroute.dart';
import 'package:vwform/modules/vwwidget/vwnodesubmitpage/selectformdefinition.dart';
import 'package:vwform/modules/vwwidget/vwnodesubmitpage/vwformeditorpage.dart';
import 'package:vwutil/modules/util/colurutil.dart';
import 'package:vwutil/modules/util/nodeutil.dart';

typedef VwNodeSelectedNodeFormDefinitionChanged = void Function(
    {required VwNode selectedFormDefinitionNode});

class VwNodeEditorPage extends StatefulWidget {
  VwNodeEditorPage(
      {required this.node,
      this.formValidationResponse,
      required this.nodeEditorFormDefinitionNode,
      required this.appInstanceParam,
      this.hideFormRowDataEditor = false,
      this.hideNodeEditor = false,
      this.onNodeSelectedNodeFormDefinitionChanged,
      this.selectedFormDefinitionNode,
      this.presetValues,
      this.formWidth = 650,
      this.backgroundColour
      }){
    if(this.backgroundColour==null)
      {
        backgroundColour= ColorUtil.parseColor("ffefebf7");
      }
  }
  final VwNode node;
  final VwFormValidationResponse? formValidationResponse;
  final VwNode nodeEditorFormDefinitionNode;
  final VwAppInstanceParam appInstanceParam;
  final bool hideNodeEditor;
  final bool hideFormRowDataEditor;
  final VwNode? selectedFormDefinitionNode;
  final VwNodeSelectedNodeFormDefinitionChanged?
      onNodeSelectedNodeFormDefinitionChanged;
  final VwRowData? presetValues;
  final double formWidth;
  Color? backgroundColour;
  VwNodeEditorPageState createState() => VwNodeEditorPageState();
}

class VwNodeEditorPageState extends State<VwNodeEditorPage> {
  late VwRowData nodeRowData;
  late List<VwNode> defaultFormDefinitionNodeList;
  VwNode? selectedFormDefinitionNode;

  void initiationNodeContentRowData() {
    if (this.widget.node.nodeType == VwNode.ntnRowData &&
        this.widget.node.content.rowData == null) {
      this.widget.node.content.rowData =
          VwRowData(recordId: this.widget.node.recordId);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.selectedFormDefinitionNode = this.widget.selectedFormDefinitionNode;
    this.initiationNodeContentRowData();
    this.initiationDefaultFormDefinition();

    nodeRowData = VwRowData(recordId: widget.node.recordId);

    NodeUtil.nodeToRowData(
        nodeSource: widget.node, rowDataDestination: nodeRowData);
  }

  Widget getEditContentRowDataIcon() {
    Widget returnValue = Icon(Icons.list_alt);
    try {
      if (this.widget.formValidationResponse != null &&
          this.widget.formValidationResponse!.isFormResponseValid == false) {
        returnValue = Stack(
          children: [
            Icon(Icons.list_alt),
            Icon(
              Icons.stars_rounded,
              color: Colors.red,
              size: 10,
            )
          ],
        );
      }
    } catch (error) {}
    return returnValue;
  }

  Widget getFormDefinitionTitleWidget({required double sideMargin}) {
    Widget returnValue = Container();

    try {
      if (this.selectedFormDefinitionNode != null) ;
      {
        VwFormDefinition? currentFormDefinition =
            NodeUtil.extractFormDefinitionFromNode(
                this.selectedFormDefinitionNode!);

        returnValue = Container(
            decoration:  BoxDecoration(
                border: Border.all(
                    color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(8),
            color: Colors.white
            ),
            //color: Colors.white,
            margin: EdgeInsets.fromLTRB(sideMargin, 15, sideMargin, 0),
            alignment: Alignment.center,
            child: Text(
              currentFormDefinition!.formName,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ));
      }
    } catch (error) {}
    return returnValue;
  }

  Widget fileViewer(){
    return TextButton.icon(onPressed: (){

      if(this.widget.node.content.fileStorage!=null)
        {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VwMultimediaViewer(
                    multimediaViewerInstanceParam:
                    VwMultimediaViewerInstanceParam(
                        caption: this.widget.node.content.fileStorage!.clientEncodedFile!=null? this.widget.node.content.fileStorage!.clientEncodedFile!.fileInfo.fileName :null,
                        //tagFieldvalue: tagListFieldValue,
                        remoteSource: [this.widget.node.content.fileStorage!],
                        fileSource: [],
                        memorySource: []),
                    appInstanceParam: this.widget.appInstanceParam,
                    multimediaViewerParam: VwMultimediaViewerParam(
                      readOnly: true,
                      /*
                    refTagLinkNodeList: tagRefLinkNodeList,
                    fieldFileTagDefinition: this
                        .widget
                        .formField
                        .fieldUiParam
                        .fieldFileTagDefinition),*/
                    )),
              ));
          }
          }, icon: Icon(Icons.image_outlined), label: Text(
              "View File"
          ));



  }

  Widget formEditor() {
    try {
      Widget editNodeButton = TextButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              // If the button is pressed, return green, otherwise blue

              return Colors.white;
            }),
          ),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialTransparentRoute(
                    builder: (context) => VwFormEditorPage(
                        formWidth: widget.formWidth,
                        showBackArrow: true,
                        formResponse: this.nodeRowData,
                        formDefinitionNode:
                            this.widget.nodeEditorFormDefinitionNode,
                        appInstanceParam: widget.appInstanceParam)));

            NodeUtil.updateNodeFromRowData(
                nodeDestination: this.widget.node,
                rowDataSource: this.nodeRowData);
          },
          icon: Icon(Icons.info),
          label: Text("Edit Node"));

      Widget formRowDataEditorPage = Container();
      Widget selectFormDefinitionButton = Container();

      if (widget.node.nodeType == VwNode.ntnRowData || widget.node.nodeType == VwNode.ntnClassEncodedJson) {
        Widget lformRowDataEditorPage=Container();
        if (this.selectedFormDefinitionNode != null &&
            widget.node.content.rowData != null) {
          lformRowDataEditorPage = VwFormEditorPage(
              backgroundColour: this.widget.backgroundColour,
              formWidth: widget.formWidth,
              presetValues: widget.presetValues,
              key: Key(widget.formValidationResponse == null
                  ? "null"
                  : widget.formValidationResponse!.lastTryValidated.toString()),
              formValidationResponse: widget.formValidationResponse,
              formResponse: widget.node.content.rowData!,
              formDefinitionNode: this.selectedFormDefinitionNode!,
              appInstanceParam: widget.appInstanceParam);
        } else if (this.defaultFormDefinitionNodeList.length > 0) {
          selectFormDefinitionButton = Container(
              height: 30,
              child: TextButton.icon(
                  onPressed: () async {
                    VwNode selectFormDefinitionNode = SelectFormDefinition
                        .selectRowDataCollectionNameFormDefinitionNode(
                            this.defaultFormDefinitionNodeList);

                    VwRowData selectFormDefinitionRowData =
                        VwRowData(recordId: Uuid().v4());

                    await Navigator.push(context,
                        MaterialTransparentRoute(builder: (context) {
                      return VwFormEditorPage(
                          formWidth: widget.formWidth,
                          showBackArrow: true,
                          appInstanceParam: widget.appInstanceParam,
                          formResponse: selectFormDefinitionRowData,
                          formDefinitionNode: selectFormDefinitionNode);
                    }));

                    if (selectFormDefinitionRowData
                                .getFieldByName("collectionName") !=
                            null &&
                        selectFormDefinitionRowData
                                .getFieldByName("collectionName")!
                                .valueString !=
                            null) {
                      String selecterFormDefinitionId =
                          selectFormDefinitionRowData
                              .getFieldByName("collectionName")!
                              .valueString!;
                      for (int la = 0;
                          la < this.defaultFormDefinitionNodeList.length;
                          la++) {
                        VwNode currentNode =
                            this.defaultFormDefinitionNodeList.elementAt(la);
                        if (currentNode.recordId == selecterFormDefinitionId) {
                          this.selectedFormDefinitionNode = currentNode;
                          if (this
                                  .widget
                                  .onNodeSelectedNodeFormDefinitionChanged !=
                              null) {
                            this
                                    .widget
                                    .onNodeSelectedNodeFormDefinitionChanged!(
                                selectedFormDefinitionNode:
                                    this.selectedFormDefinitionNode!);
                          }
                          break;
                        }
                      }

                      if (this.selectedFormDefinitionNode != null) {
                        setState(() {});
                      }
                    }
                  },
                  icon: Icon(Icons.question_mark),
                  label: Text("Select Form Definition")));
        }

        formRowDataEditorPage= Expanded(child: lformRowDataEditorPage);
      }
      else if(widget.node.nodeType == VwNode.ntnFileStorage)
        {
          formRowDataEditorPage=this.fileViewer();
        }

      Widget body = LayoutBuilder(builder: (context,constraint){
       Widget returnValue= Container();
       try
           {
             double sideMargin = 25;

             if (constraint.maxWidth > widget.formWidth) {
               sideMargin = 0.5 * (constraint.maxWidth - widget.formWidth);
             }

             return Container(color: widget.backgroundColour, child: Column(
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 selectFormDefinitionButton,
                 widget.hideNodeEditor == false ? editNodeButton : Container(),
                 widget.hideFormRowDataEditor == false
                     ? formRowDataEditorPage
                     : Container()
               ],
             ));
           }
           catch(error)
       {

       }
       return returnValue;

     } );



      return body;
    } catch (error) {}
    return Container();
  }

  void initiationDefaultFormDefinition() {

    bool isDefaultFormDefinitionChanged=false;

    bool isAtFirsSelectedFormDefinitionNodeIsNull=selectedFormDefinitionNode==null;


    this.defaultFormDefinitionNodeList = [];
    try {
      if ((widget.node.nodeType == VwNode.ntnRowData || widget.node.nodeType == VwNode.ntnClassEncodedJson) &&
          widget.node.content.rowData != null) {
        if (widget.node.content.rowData!.formDefinitionLinkNode != null) {
          VwNode? currentDefaultFormDefinitionNode =
              NodeUtil.extractNodeFromLinkNode(
                  widget.node.content.rowData!.formDefinitionLinkNode!);

          if (currentDefaultFormDefinitionNode != null) {
            VwFormDefinition? currentDefaultFormDefinition =
                NodeUtil.extractFormDefinitionFromNode(
                    currentDefaultFormDefinitionNode);

            if (currentDefaultFormDefinition != null) {
              this.selectedFormDefinitionNode =
                  currentDefaultFormDefinitionNode;
            }
          }
        }
      }


      if (this.selectedFormDefinitionNode == null) {
        if (widget.node.defaultFormDefinitionList != null) {
          this.defaultFormDefinitionNodeList =
              widget.node.defaultFormDefinitionList!;
        }

        if (defaultFormDefinitionNodeList.length == 1) {
          selectedFormDefinitionNode =
              this.defaultFormDefinitionNodeList!.elementAt(0);
        }
      }

      bool isAtLastSelectedFormDefinitionNodeIsNull=selectedFormDefinitionNode==null;

      if(isAtFirsSelectedFormDefinitionNodeIsNull==true && isAtLastSelectedFormDefinitionNodeIsNull==false)
        {
          isDefaultFormDefinitionChanged=true;
        }

      if(isDefaultFormDefinitionChanged==true && this.selectedFormDefinitionNode!=null)
        {
          if (widget.onNodeSelectedNodeFormDefinitionChanged != null) {
            widget.onNodeSelectedNodeFormDefinitionChanged!(selectedFormDefinitionNode:this.selectedFormDefinitionNode!);
           // setState(() {});
          }
        }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return formEditor();
  }
}
