import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwfielddisplayformat/vwfielddisplayformat.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'package:matrixclient2base/modules/base/vwnumbertextinputformatter/vwnumbertextinputformatter.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwcardparameter/vwcardparameter.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:vwform/modules/vwformpage/vwdefaultformpage.dart';
import 'package:vwform/modules/vwwidget/vwcardparameternodeviewermaterial/vwcardparameternodeviewermaterial.dart';
import 'package:vwform/modules/vwwidget/vwoperatorticketpage/modules/ticketeventresponderpage/ticketeventresponderpage.dart';
import 'package:vwform/modules/vwwidget/vwoperatorticketpage/modules/vwoperatorticketpagedefinition/vwoperatorticketpagedefinition.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwToDoListOperatorTicketPage extends StatefulWidget {
  VwToDoListOperatorTicketPage(
      {required super.key,
      required this.appInstanceParam,
      required this.operatorTicketPageDefinition});
  final VwAppInstanceParam appInstanceParam;
  final VwOperatorTicketPageDefinition operatorTicketPageDefinition;

  VwToDoListOperatorTicketPageState createState() => VwToDoListOperatorTicketPageState();
}

class VwToDoListOperatorTicketPageState extends State<VwToDoListOperatorTicketPage> {
  RefreshDataOnParentFunction? rootRefreshDataOnParentFunction;
  void modifyParamFunction(VwRowData apiCallParam) {}

  VwRowData apiCallParamInitiator() {
    VwRowData returnValue = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId",
              valueString: VwOperatorTicketPageDefinition
                  .getPossibleTicketInitiatorNodeId),
          VwFieldValue(fieldName: "depth", valueNumber: 1),
        ]);

    returnValue.fields!.add(
      VwFieldValue(
          fieldName: "depth1FilterObject",
          valueTypeId: VwFieldValue.vatObject,
          value: {
            "content.contentContext.collectionName": "vwticketeventdefinition"
          }),
    );

    return returnValue;
  }

  NodeListView buildNodeListViewInitiator(BuildContext context) {
    NodeListView returnValue = NodeListView(
      appInstanceParam: this.widget.appInstanceParam,
      key: widget.key,
      apiCallId: "getNodes",
      nodeFetchMode: NodeListView.nfmServer,
      showBackArrow: true,
      mainLogoMode: NodeListView.mlmText,
      mainLogoTextCaption: "(Create new ticket, please select one)",
      showSearchIcon: false,
      showUserInfoIcon: false,
      showNotificationIcon: false,
      nodeRowViewerFunction: this.implementNodeRowViewerInitiator,
      apiCallParam: this.apiCallParamInitiator(),
    );

    return returnValue;
  }

  Widget implementNodeRowViewerInitiator(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
        CommandToParentFunction? commandToParentFunction
      }) {
    InkWell cardTapper = InkWell(
      onTap: () async {
        try {
          VwFormDefinition? initFormDefinition;
          VwRowData? initFormResponse;

          for (int la = 0;
              la < renderedNode.content.rowData!.attachments!.length;
              la++) {
            VwNodeContent currentAttachment =
                renderedNode.content.rowData!.attachments!.elementAt(la);

            if (currentAttachment.tag != null &&
                currentAttachment.classEncodedJson != null &&
                currentAttachment.classEncodedJson!.data != null) {
              if (currentAttachment.tag ==
                  VwOperatorTicketPageDefinition.tagInitTicketFormDefinition) {
                initFormDefinition = VwFormDefinition .fromJson(
                    currentAttachment.classEncodedJson!.data!);
              } else if (currentAttachment.tag ==
                  VwOperatorTicketPageDefinition.tagInitTicketFormResponse) {
                initFormResponse = VwRowData.fromJson(
                    currentAttachment.classEncodedJson!.data!);
              }
            }
          }

          if (initFormResponse != null && initFormDefinition != null) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VwFormPage(
                        formDefinitionFolderNodeId:
                            AppConfig.formDefinitionFolderNodeId,
                        appInstanceParam: this.widget.appInstanceParam,
                        isMultipageSections: true,
                        formDefinition: initFormDefinition!,
                        formResponse: initFormResponse!,
                        refreshDataOnParentFunction:
                            refreshDataOnParentFunction,
                      )),
            );
            Navigator.pop(context);
          }
        } catch (error) {
          print("Error catched on implementNodeRowViewerInitiator on Tap Row Init Ticket Row"+error.toString());
        }
      },
    );

    return VwCardParameterNodeViewerMaterial(
      appInstanceParam: this.widget.appInstanceParam,
        cardParameter: widget
            .operatorTicketPageDefinition.possibleInitiatorRowCardParameter,
        rowNode: renderedNode,
        cardTapper: cardTapper);
  }

  Widget? implementNodeRowViewerResponder(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction}) {}

  Widget _getFloatingActionButtonInitiator(
      {required BuildContext context,
      required VwAppInstanceParam appInstanceParam,
      SyncNodeToParentFunction? syncNodeToParentFunction,
      RefreshDataOnParentFunction? refreshDataOnParentFunction}) {
    FloatingActionButton returnValue = FloatingActionButton(
        backgroundColor: Colors.blue.withOpacity(0.5),
        key: UniqueKey(),
        heroTag: Uuid().v4(),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => buildNodeListViewInitiator(context)),
          );
        });

    return returnValue;
  }

  Widget ticketNodeRowViewer(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
        CommandToParentFunction? commandToParentFunction
      }) {
    this.rootRefreshDataOnParentFunction = refreshDataOnParentFunction;
    VwCardParameter cardParameter = VwCardParameter(
        titleFieldName: "name",
        titleSubFieldName: "transaksiIndukId",
        subTitleFieldName: "name",
        subtitleSubFieldName: "uraian",
        descriptionFieldName: "name",
        descriptionSubFieldName: "totnilmask",
        descriptionPrefix: "Rp",
        descriptionDisplayFormat: VwFieldDisplayFormat(
            fieldFormat: VwFieldDisplayFormat.vsfNumeric,
            numberTextInputFormatter:
                VwNumberTextInputFormatter(decimalDigits: 0)),
        isShowSubtitle: true,
        iconHexCode: "0xf085d",
        cardStyle: VwCardParameter.csTwoColumnWithDescription);

    /*
    List<VwNodeContent>? attachments = renderedNode.content.rowData!.attachments;

    List<VwLinkNode> ticketEventDefinitionLinkNodeList = [];

    if (attachments != null) {
      List<VwNodeContent> ticketEventDefinitionTaggedAttachments =
          NodeUtil.extractAttachmentsByTag(
              nodeType: VwNode.ntnClassEncodedJson,
              attachments: attachments,
              tag: VwOperatorTicketPageDefinition.tagTicketEventDefinition);

      for (int la = 0;
          la < ticketEventDefinitionTaggedAttachments.length;
          la++) {
        try {
          VwNodeContent currentNodeContent =
              ticketEventDefinitionTaggedAttachments.elementAt(la);

          VwClassEncodedJson? currentRowDataClassEncodedJson =
              NodeUtil.extractClassEncodedJsonFromContent(
                  nodeContent: currentNodeContent);

          if (currentRowDataClassEncodedJson != null &&
              currentRowDataClassEncodedJson.data != null) {
            if (currentRowDataClassEncodedJson.className == 'VwLinkNode') {
              VwLinkNode currentLinkNode =
                  VwLinkNode.fromJson(currentRowDataClassEncodedJson.data!);

              ticketEventDefinitionLinkNodeList.add(currentLinkNode);
            }
          }
        } catch (error) {}
      }
    }*/

    InkWell cardTapper = InkWell(onTap: () {
      print("Ticket Response " + renderedNode.recordId + " is selected");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TicketEventResponderPage(
                ticketId: renderedNode.recordId,
                appInstanceParam: widget.appInstanceParam,
                refreshDataOnParentFunction: refreshDataOnParentFunction)),
      );
    });

    return VwCardParameterNodeViewerMaterial(
      appInstanceParam: this.widget.appInstanceParam,
        key: Key(renderedNode.recordId),
        cardParameter: cardParameter,
        rowNode: renderedNode,
        cardTapper: cardTapper);
  }

  Widget eventDefinitionNodeRowViewer(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
        CommandToParentFunction? commandToParentFunction
      }) {
    VwCardParameter cardParameter = new VwCardParameter(
      titleFieldName: "name",
      cardStyle: VwCardParameter.csOneColumn,
      isShowDate: false,
      isShowSubtitle: false,
    );

    //VwFieldValue? fieldValue= renderedNode.content.linkRowCollection!.rendered!.getFieldByName("ticketEventFormDefinition");

    //VwFormDefinition formDefinition= VwFormDefinition.fromJson(fieldValue!.valueLinkNode!.cache!.content.linkbasemodel!.rendered!.data);

    if (renderedNode.nodeType == VwNode.ntnRowData) {
      VwRowData? ticketEventDefinition = renderedNode.content.rowData;
      List<VwNodeContent> nodeContentTicketEventResponseFormDefinitionList =
          NodeUtil.extractAttachmentsByTag(
              attachments: ticketEventDefinition!.attachments!,
              nodeType: VwNode.ntnClassEncodedJson,
              tag: VwOperatorTicketPageDefinition
                  .tagTicketEventResponseFormDefinition);

      VwFormDefinition? ticketResponseFormDefinition;
      if (nodeContentTicketEventResponseFormDefinitionList != null &&
          nodeContentTicketEventResponseFormDefinitionList.length > 0) {
        VwNodeContent nodeContent =
            nodeContentTicketEventResponseFormDefinitionList!.elementAt(0);

        ticketResponseFormDefinition =
            NodeUtil.extractFormDefinitionFromContent(nodeContent: nodeContent);
      }

      InkWell cardTapper = InkWell(
        onTap: () async {
          print("ticketEventDefinition " +
              renderedNode.recordId +
              " is selected");

          print("form tapped");
          //formParam.response.recordId = Uuid().v4();

          if (ticketResponseFormDefinition != null) {
            VwRowData formResponse =
                VwFormDefinitionUtil.createBlankRowDataFromFormDefinition(
                    formDefinition: ticketResponseFormDefinition,
                    ownerUserId: widget.appInstanceParam.loginResponse!
                        .userInfo!.user.recordId);
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VwFormPage(
                        appInstanceParam: this.widget.appInstanceParam,
                        formDefinitionFolderNodeId:
                            AppConfig.formDefinitionFolderNodeId,
                        isMultipageSections: true,
                        formDefinition: ticketResponseFormDefinition!,
                        formResponse: formResponse,
                        refreshDataOnParentFunction:
                            this.rootRefreshDataOnParentFunction,
                      )),
            );
            Navigator.pop(context);
          }
        },
      );

      return VwCardParameterNodeViewerMaterial(
        appInstanceParam: this.widget.appInstanceParam,
          cardParameter: cardParameter,
          rowNode: renderedNode,
          cardTapper: cardTapper);
    } else if (renderedNode.nodeType == VwNode.ntnLinkRowCollection) {
      VwRowData? ticketEventDefinition =
          NodeUtil.extractLinkRowCollection(renderedNode.content);

      List<VwNodeContent> nodeContentTicketEventResponseFormDefinitionList =
          NodeUtil.extractAttachmentsByTag(
              attachments: ticketEventDefinition!.attachments!,
              nodeType: VwNode.ntnLinkBaseModelCollection,
              tag: VwOperatorTicketPageDefinition
                  .tagTicketEventResponseFormDefinition);

      VwFormDefinition? ticketResponseFormDefinition;
      if (nodeContentTicketEventResponseFormDefinitionList != null &&
          nodeContentTicketEventResponseFormDefinitionList.length > 0) {
        VwNodeContent nodeContent =
            nodeContentTicketEventResponseFormDefinitionList!.elementAt(0);

        ticketResponseFormDefinition =
            NodeUtil.extractFormDefinitionFromContent(nodeContent: nodeContent);
      }

      InkWell cardTapper = InkWell(
        onTap: () async {
          print("ticketEventDefinition " +
              renderedNode.recordId +
              " is selected");

          print("form tapped");
          //formParam.response.recordId = Uuid().v4();

          if (ticketResponseFormDefinition != null) {
            VwRowData formResponse =
                VwFormDefinitionUtil.createBlankRowDataFromFormDefinition(
                    formDefinition: ticketResponseFormDefinition,
                    ownerUserId: widget.appInstanceParam.loginResponse!
                        .userInfo!.user.recordId);
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VwFormPage(
                        formDefinitionFolderNodeId:
                            AppConfig.formDefinitionFolderNodeId,
                        appInstanceParam: this.widget.appInstanceParam,
                        isMultipageSections: true,
                        formDefinition: ticketResponseFormDefinition!,
                        formResponse: formResponse,
                        refreshDataOnParentFunction:
                            this.rootRefreshDataOnParentFunction,
                      )),
            );
            Navigator.pop(context);
          }
        },
      );

      return VwCardParameterNodeViewerMaterial(
        appInstanceParam: this.widget.appInstanceParam,
          cardParameter: cardParameter,
          rowNode: renderedNode,
          cardTapper: cardTapper);
    }
    return Container();
  }

  void implementRefreshDataOnParentFunction() {
    print("refresh data from isi form");
    setState(() {
      //this.stateKey=Key(Uuid().v4().toString());
    });
  }

  NodeListView buildEventDefinitionNodeList(
      {required List<VwLinkNode> ticketEventDefinitionLinkNodeList,
      RefreshDataOnParentFunction? refreshDataOnParentFunction}) {
    return NodeListView(
        nodeFetchMode: NodeListView.nfmParent,
        showSearchIcon: true,
        mainLogoMode: NodeListView.mlmText,
        mainLogoTextCaption: "(Select)",

        showBackArrow: true,
        fieldValue: VwFieldValue(
            fieldName: "data",
            valueTypeId: VwFieldValue.vatValueLinkNodeList,
            valueLinkNodeList: ticketEventDefinitionLinkNodeList),
        appInstanceParam: this.widget.appInstanceParam,
        apiCallParam: VwRowData(
            recordId: Uuid().v4(), timestamp: VwDateUtil.nowTimestamp()),
        nodeRowViewerFunction: this.eventDefinitionNodeRowViewer);
  }

  VwRowData apiCallParam() {
    final String nodeId = VwOperatorTicketPageDefinition
        .getPossibleResponderEventResponseTicketNodeId;
    //final String? collectionName=this.formField.fieldDefinition.fieldConstraint.collectionName;

    VwRowData apiCallParam = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: Uuid().v4(),
        fields: <VwFieldValue>[
          VwFieldValue(fieldName: "nodeId", valueString: nodeId),
          VwFieldValue(fieldName: "depth", valueNumber: 1),
        ]);

    List<String> collectionNameList = [VwOperatorTicketPageDefinition.vwTicket];

    Map<String, dynamic> collectionNameListFilter = {
      "\$in": collectionNameList
    };

    apiCallParam.fields!.add(
      VwFieldValue(
          fieldName: "depth1FilterObject",
          valueTypeId: VwFieldValue.vatObject,
          value: {
            "content.contentContext.collectionName": collectionNameListFilter
          }),
    );
    //apiCallParam.fields!.add(VwFieldValue(fieldName: "depth1FilterObject",valueTypeId: VwFieldValue.vatObject,value: {"content.contentContext.collectionName":collectionName}));

    return apiCallParam;
  }

  NodeListView buildNodeListViewResponder(BuildContext context) {
    return NodeListView(
      mainHeaderBackgroundColor: const Color.fromARGB(255,200, 200, 200),
      mainHeaderTitleTextColor: Colors.black,
      appInstanceParam: this.widget.appInstanceParam,
      apiCallId: "getNodes",
      showUserInfoIcon: true,
      showSearchIcon: false,
      mainLogoMode: NodeListView.mlmText,
      mainLogoTextCaption: "To Do List",
      showBackArrow: false,
      nodeFetchMode: NodeListView.nfmServer,
      nodeRowViewerFunction: ticketNodeRowViewer,
      apiCallParam: this.apiCallParam(),
      showReloadButton: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: this.buildNodeListViewResponder(context),
        key: widget.key,
        floatingActionButton: this._getFloatingActionButtonInitiator(
            context: context, appInstanceParam: widget.appInstanceParam));
  }
}
