import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrixclient2base/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'package:matrixclient2base/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwcardparameter/vwcardparameter.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:vwform/modules/vwformpage/vwdefaultformpage.dart';
import 'package:vwform/modules/vwwidget/vwcardparameternodeviewermaterial/vwcardparameternodeviewermaterial.dart';
import 'package:vwform/modules/vwwidget/vwoperatorticketpage/modules/vwoperatorticketpagedefinition/vwoperatorticketpagedefinition.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';
import 'package:vwutil/modules/util/widgetutil.dart';

class TicketEventResponderPage extends StatefulWidget {
  TicketEventResponderPage({required this.ticketId, required this.appInstanceParam, required this.refreshDataOnParentFunction});

  String ticketId;
  RefreshDataOnParentFunction? refreshDataOnParentFunction;
  final VwAppInstanceParam appInstanceParam;
  TicketEventResponderPageState createState() =>
      TicketEventResponderPageState();
}

class TicketEventResponderPageState extends State<TicketEventResponderPage> {

  VwNode? ticketEventResponseNode;

  @override
  void initState(){

  }

  Future<VwNodeRequestResponse> loadTicketResponseData() async {
    VwNodeRequestResponse returnValue = VwNodeRequestResponse();

    try {

      VwRowData apiCallParam=VwRowData(
          timestamp: VwDateUtil.nowTimestamp(),
          recordId: Uuid().v4(),
          fields: <VwFieldValue>[
            VwFieldValue(
                fieldName: "nodeId",
                valueString: VwOperatorTicketPageDefinition.respondByTicketIdEventDefinitionNodeId ),
            VwFieldValue(fieldName: "depth", valueNumber: 1),
            VwFieldValue(
                fieldName: "ticketId",
              valueString: widget.ticketId
            ),
          ]);

      returnValue = await RemoteApi.nodeRequestApiCall (
          baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
          graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,

          apiCallId: "getNodes",
          apiCallParam: apiCallParam, loginSessionId: this.widget.appInstanceParam.loginResponse!.loginSessionId!);



    } catch (error) {
      print("Error catched on loadTicketResponseData()="+error.toString());
    }

    return returnValue;
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


    if(renderedNode.nodeType == VwNode.ntnRowData)
    {
      VwRowData? ticketEventDefinition=renderedNode.content.rowData;
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

            VwRowData? formResponse=ticketResponseFormDefinition.initialFormResponse;

            if(formResponse==null) {
              formResponse =
                  VwFormDefinitionUtil.createBlankRowDataFromFormDefinition(
                      formDefinition: ticketResponseFormDefinition,
                      ownerUserId: widget.appInstanceParam.loginResponse!
                          .userInfo!.user.recordId);
            }

            if(formResponse!=null) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VwFormPage(
                          appInstanceParam: this.widget.appInstanceParam,
                          formDefinitionFolderNodeId:
                              this.widget.appInstanceParam.baseAppConfig.generalConfig.formDefinitionFolderNodeId,

                          isMultipageSections: true,
                          formDefinition: ticketResponseFormDefinition!,
                          formResponse: formResponse!,
                          refreshDataOnParentFunction:
                          this.widget.refreshDataOnParentFunction,
                        )),
              );
              Navigator.pop(context);
            }

          }
        },
      );

      return VwCardParameterNodeViewerMaterial (
        appInstanceParam: this.widget.appInstanceParam,
          cardParameter: cardParameter,
          rowNode: renderedNode,
          cardTapper: cardTapper);
    }

    return Container();
  }

  NodeListView buildEventDefinitionNodeList(
      {required List<VwLinkNode> ticketEventDefinitionLinkNodeList, RefreshDataOnParentFunction? refreshDataOnParentFunction}) {
    return NodeListView(
        mainLogoImageAsset: this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
        nodeFetchMode: NodeListView.nfmParent,
        showSearchIcon: false,
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
        nodeRowViewerFunction: this.eventDefinitionNodeRowViewer
    );
  }



  static List<VwLinkNode> getEventDefinitionLinkNodeList(VwNode ticketResponderNode ){

    List<VwNodeContent>? attachments = ticketResponderNode.content.rowData!.attachments;

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
    }

    return ticketEventDefinitionLinkNodeList;
  }

  @override
  Widget build(BuildContext context) {



    return FutureBuilder<VwNodeRequestResponse>(
        future: loadTicketResponseData(),


        builder: (context, snapshot){

          if(snapshot.hasData)
            {
              if(snapshot.data!.httpResponse!=null && snapshot.data!.httpResponse!.statusCode==200)
                {
                  if (snapshot.data!.apiCallResponse != null) {
                    if (snapshot.data!.renderedNodePackage != null &&
                        snapshot.data!.renderedNodePackage!.renderedNodeList !=
                            null) {

                      List<VwNode> nodeList=snapshot.data!.renderedNodePackage!.renderedNodeList!;
                      if(nodeList.length>0) {
                        this.ticketEventResponseNode = nodeList.elementAt(0);


                        List<VwNodeContent>? attachments = this.ticketEventResponseNode!.content.rowData!.attachments;

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
                        }

                        return this.buildEventDefinitionNodeList(
                            ticketEventDefinitionLinkNodeList:
                            ticketEventDefinitionLinkNodeList,
                            refreshDataOnParentFunction: this.widget.refreshDataOnParentFunction

                        );


                      }

                    }
                  }

                }
              else{
                Fluttertoast .showToast(
                    msg: "Error: Tidak terhubung dengan server",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    webBgColor: "linear-gradient(to right, #5dbb63, #5dbb63)",
                    webPosition: "center",
                    fontSize: 16.0);
                Navigator.pop(context);

              }
            }

            return WidgetUtil.loadingWidget("Memuat data dari Server...");





        });
  }
}
