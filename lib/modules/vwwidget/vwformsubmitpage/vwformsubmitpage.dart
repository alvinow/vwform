import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/deployedcollectionname.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwsectionformdefinition/vwsectionformdefinition.dart';
import 'package:vwform/modules/vwformpage/vwdefaultformpage.dart';
import 'package:vwform/modules/vwwidget/vwformsubmitpage/vwformsubmitrowviewer.dart';
import 'package:vwnodestoreonhive/vwnodestoreonhive/vwnodestoreonhive.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';
import 'package:vwutil/modules/util/widgetutil.dart';

class VwFormSubmitPage extends StatefulWidget {
  VwFormSubmitPage(
      {super.key,
      required this.appInstanceParam,
      required this.refreshDataOnParentFunction,
      this.defaultFormDefinitionIdList,
      this.resultCallback,
      this.lockPresetValue = false,
      this.presetValues,
      this.parentNode
      });

  final VwNode? parentNode;
  final VwAppInstanceParam appInstanceParam;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  final List<String>? defaultFormDefinitionIdList;
  final VwFormPageResult? resultCallback;
  final VwRowData? presetValues;
  final bool lockPresetValue;


  VwFormSubmitPageState createState() => VwFormSubmitPageState();
}

class VwFormSubmitPageState extends State<VwFormSubmitPage> {
  late Future myFuture;
  late String formResponseRecordId;
  late String formState;
  VwNodeRequestResponse? currentNodeRequestResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    formResponseRecordId = Uuid().v4();

    myFuture = this._asyncLoadFormDefinitionNode();
  }

  Widget nodeRowViewer(
      {required VwNode renderedNode,
      required BuildContext context,
      required int index,
      Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
      CommandToParentFunction? commandToParentFunction}) {
    return VwFormSubmitRowViewer(
        appInstanceParam: this.widget.appInstanceParam,
        rowNode: renderedNode,
        highlightedText: highlightedText,
        refreshDataOnParentFunction: this.widget.refreshDataOnParentFunction);
  }

  Widget uploadIconButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.cloud_upload),
      tooltip: 'Uploading Data...',
      onPressed: () async {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Uploading Data...')));

        await VwNodeStoreOnHive(boxName: this.widget.appInstanceParam.baseAppConfig.generalConfig.unsyncedRecordFieldname,
        //graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
          baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
            appTitle: this.widget.appInstanceParam.baseAppConfig.generalConfig.appTitle,
          appversion: this.widget.appInstanceParam.baseAppConfig.generalConfig.appVersion,
          unsyncedRecordFieldname: this.widget.appInstanceParam.baseAppConfig.generalConfig.unsyncedRecordFieldname,
          loggedInUser: this.widget.appInstanceParam.baseAppConfig.generalConfig.loggedInUser
        )
            .syncToServer(
                loginSessionId: this
                    .widget
                    .appInstanceParam
                    .loginResponse!
                    .loginSessionId!);
      },
    );
  }

  void modifyParamFunction(VwRowData apiCallParam) {}

  VwRowData apiCallParam() {
    VwRowData returnValue = VwRowData(recordId: Uuid().v4(), fields: []);
    try {
      return VwRowData(
          timestamp: VwDateUtil.nowTimestamp(),
          recordId: Uuid().v4(),
          fields: <VwFieldValue>[
            VwFieldValue(
                fieldName: "nodeId",
                valueString:
                    "response_" + DeployedCollectionName.vwFormDefinition),
            VwFieldValue(fieldName: "depth", valueNumber: 1),
            VwFieldValue(
                fieldName: "sortObject",
                valueTypeId: VwFieldValue.vatObject,
                value: {"indexKey.sortKey":1, "displayName": 1}),
            VwFieldValue(
                fieldName: "depth1FilterObject",
                valueTypeId: VwFieldValue.vatObject,
                value: {"content.contentContext.className": "VwFormDefinition"})
          ]);
    } catch (error) {}
    return returnValue;
  }

  Future<VwNodeRequestResponse> _asyncLoadFormDefinitionNode() async {
    VwNodeRequestResponse nodeRequestResponse = VwNodeRequestResponse();
    try {
      VwRowData currentApiCallParam = VwRowData(
          timestamp: VwDateUtil.nowTimestamp(),
          recordId: Uuid().v4(),
          fields: <VwFieldValue>[
            VwFieldValue(
                fieldName: "nodeId",
                valueString:
                    "response_" + DeployedCollectionName.vwFormDefinition),
            VwFieldValue(fieldName: "depth", valueNumber: 1),
            VwFieldValue(
                fieldName: "childNodeIdLevel1List",
                valueTypeId: VwFieldValue.vatValueStringList,
                valueStringList: this.widget.defaultFormDefinitionIdList),
            VwFieldValue(
                fieldName: "sortObject",
                valueTypeId: VwFieldValue.vatObject,
                value: {"indexKey.sortKey":1, "displayName": 1}),
            VwFieldValue(
                fieldName: "depth1FilterObject",
                valueTypeId: VwFieldValue.vatObject,
                value: {"content.contentContext.className": "VwFormDefinition"})
          ]);

      nodeRequestResponse = await RemoteApi.nodeRequestApiCall(
        baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
          graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
          apiCallId: "getNodes",
          apiCallParam: currentApiCallParam,
          loginSessionId:
              this.widget.appInstanceParam.loginResponse!.loginSessionId!);
    } catch (error) {}

    return nodeRequestResponse;
  }

  void implementFormPageResult(VwRowData result) {
    if (this.widget.resultCallback != null) {
      this.widget.resultCallback!(result);
    }
  }

  void applyPresetValue(
      VwRowData formResponse, VwFormDefinition formDefinition) {
    try {
      if (widget.presetValues != null) {
        formResponse.recordId = widget.presetValues!.recordId;
        for (int la = 0; la < widget.presetValues!.fields!.length; la++) {
          VwFieldValue? presetFieldValue =
              widget.presetValues!.fields!.elementAt(la);

          VwFieldValue? newRecordFieldValue =
              formResponse.getFieldByName(presetFieldValue.fieldName);

          if (newRecordFieldValue == null) {
            if (formResponse.fields == null) {
              formResponse.fields = [];
            }
            formResponse.fields!.add(presetFieldValue);
          } else {
            newRecordFieldValue.copyFrom(presetFieldValue);
          }

          if (widget.lockPresetValue == true) {
            for (int la = 0; la < formDefinition.sections.length; la++) {
              VwSectionFormDefinition currentSection =
                  formDefinition.sections.elementAt(la);

              for (int lb = 0; lb < currentSection.formFields.length; lb++) {
                VwFormField currentFormField =
                    currentSection.formFields.elementAt(lb);

                if (currentFormField.fieldDefinition.fieldName ==
                    presetFieldValue.fieldName) {
                  currentFormField.fieldUiParam.isReadOnly = true;
                }
              }
            }
          }
        }
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.defaultFormDefinitionIdList != null &&
        this.widget.defaultFormDefinitionIdList!.length > 0) {
      return FutureBuilder(
          future: myFuture,
          builder: (context, snapshot) {
            List<VwNode> nodeList = [];
            if (snapshot.hasData) {
              if (snapshot.data!.apiCallResponse != null) {
                if (snapshot.data!.renderedNodePackage != null &&
                    snapshot.data!.renderedNodePackage!.renderedNodeList !=
                        null) {
                  nodeList =
                      snapshot.data!.renderedNodePackage!.renderedNodeList!;
                }
              }

              if (nodeList.length == 1) {
                VwNode currentFormDefinitionNode = nodeList.elementAt(0);

                VwFormDefinition formDefinition = VwFormDefinition.fromJson(
                    currentFormDefinitionNode.content.classEncodedJson!.data!);

                VwRowData formResponse =
                    VwFormDefinitionUtil.createBlankRowDataFromFormDefinition(
                        formDefinition: formDefinition,
                        ownerUserId: this
                            .widget
                            .appInstanceParam
                            .loginResponse!
                            .userInfo!
                            .user
                            .recordId);

                if(formDefinition.recordId=="nodefoldercreatorformdefinition")
                  {
                    if(widget.parentNode!=null)
                      {

                        if(formResponse.fields==null)
                          {
                            formResponse.fields=[];
                          }
                        if(formResponse.getFieldByName("parentFolder")==null)
                          {
                            formResponse.fields!.add(VwFieldValue(fieldName: "parentFolder"));
                          }

                        formResponse.getFieldByName("parentFolder")!.valueLinkNode=VwLinkNode(nodeId: widget.parentNode!.recordId, nodeType: VwNode.ntnFolder);

                      }
                  }

                this.applyPresetValue(formResponse, formDefinition);
                formResponse.recordId = this.formResponseRecordId;

                return VwFormPage(
                  enableScaffold: true,
                  key: Key(formResponse.recordId),
                  appInstanceParam: this.widget.appInstanceParam,
                  formDefinitionFolderNodeId:
                      this.widget.appInstanceParam.baseAppConfig.generalConfig.formDefinitionFolderNodeId,
                  isMultipageSections: true,
                  formDefinition: formDefinition,
                  formResponse: formResponse,
                  resultCallback: this.implementFormPageResult,
                  refreshDataOnParentFunction:
                      this.widget.refreshDataOnParentFunction,
                );
              } else {
                Widget nodeListView = NodeListView(
                  mainLogoImageAsset: this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
                  enableScaffold: true,
                  appInstanceParam: this.widget.appInstanceParam,
                  fieldValue: VwFieldValue(
                      fieldName: "<invalid_field_name>",
                      valueTypeId: VwFieldValue.vatValueLinkNodeList,
                      valueLinkNodeList:
                          NodeUtil.createLinkNodeListFormNodeList(
                              nodeList: nodeList)),
                  nodeFetchMode: NodeListView.nfmParent,
                  apiCallId: "getNodes",
                  mainLogoMode: NodeListView.mlmText,
                  mainLogoTextCaption: "Form",
                  showBackArrow: true,
                  nodeRowViewerFunction: nodeRowViewer,
                  apiCallParam: this.apiCallParam(),
                );

                return nodeListView;
              }
            } else if (snapshot.hasError) {
              //error loading
              Fluttertoast.showToast(
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

            return WidgetUtil.loadingWidget("Loading from server...");
          });
    }

    return NodeListView(
      mainLogoImageAsset: this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
      enableScaffold: true,
      appInstanceParam: this.widget.appInstanceParam,
      apiCallId: "getNodes",
      mainLogoMode: NodeListView.mlmText,
      mainLogoTextCaption: "(Pilih Form)",
      showBackArrow: true,
      nodeRowViewerFunction: nodeRowViewer,
      apiCallParam: this.apiCallParam(),
    );
  }
}
