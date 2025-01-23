import 'dart:async';
import 'dart:convert';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwapicall/synctokenblock/synctokenblock.dart';
import 'package:matrixclient2base/modules/base/vwapicall/vwapicallresponse/vwapicallresponse.dart';
import 'package:matrixclient2base/modules/base/vwbasemodel/vwbasemodel.dart';
import 'package:matrixclient2base/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwfilestorage/vwfilestorage.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/modules/vwlinknoderendered/vwlinknoderendered.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'package:matrixclient2base/modules/base/vwnoderequestresponse/vwnoderequestresponse.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwdatasourcedefinition/vwdatasourcedefinition.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformfieldvalidationresponse/vwformfieldvalidationresponse.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformfieldvalidationresponsecomponent/vwformfieldvalidationresponsecomponent.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformvalidationresponse.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwsectionformdefinition/vwsectionformdefinition.dart';
import 'package:vwform/modules/vwnodeupsyncresult/vwnodeupsyncresult.dart';
import 'package:vwform/modules/vwnodeupsyncresultpackage/vwnodeupsyncresultpackage.dart';
import 'package:vwform/modules/vwwidget/materialtransparentroute/materialtransparentroute.dart';
import 'package:vwform/modules/vwwidget/vwcircularprogressindicator/vwcircularprogressindicator.dart';
import 'package:vwform/modules/vwwidget/vwconfirmdialog/vwconfirmdialog.dart';
import 'package:vwform/modules/vwwidget/vwnodeinfoform/vwnodeinfoform.dart';
import 'package:vwnodestoreonhive/vwnodestoreonhive/vwnodestoreonhive.dart';
import 'package:vwutil/modules/util/formutil.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';
import 'package:vwutil/modules/util/vwrowdatautil.dart';
import 'package:vwutil/modules/util/widgetutil.dart';

typedef VwFormPageSave = void Function(
    VwFormDefinition, VwFieldValue, VwRowData, bool);

typedef VwFormPageResult = void Function(
    VwRowData );

class VwFormPage extends StatefulWidget{

  VwFormPage(
      {super.key,
        required this.formResponse,
        required this.formDefinition,
        this.initState = VwFormPage.fsDataLoaded,
        required this.appInstanceParam,
        this.refreshDataOnParentFunction,
        required this.formDefinitionFolderNodeId,
        this.isShowAppBar = true,
        this.isMultipageSections = false,
        this.syncNodeToParentFunction,
        this.enablePopContextAfterSucessfullySaved = true,
        this.isShowSaveButton = true,
        this.showUserInfoIcon = false,
        this.showDeleteIcon = false,
        this.disableScrollView = false,
        this.loadFormDefinitionFormServer = false,
        this.enableTitle = true,
        this.syncCaption = "Save",
        this.prevCaption = "Previous",
        this.nextCaption = "Next",
        this.enableUpdateInputFormResponse = false,
        this.formName,
        this.enableScaffold = true,
        this.backgroundColor = const Color.fromARGB(255, 209, 240, 255),
        this.borderColor = Colors.lightBlueAccent,
        this.resultCallback,
        this.formValidationResponse,
        this.isShowFormName=true
      });
  final VwAppInstanceParam appInstanceParam;
  VwRowData formResponse;
  final bool isShowAppBar;
  final VwFormDefinition formDefinition;
  final SyncNodeToParentFunction? syncNodeToParentFunction;
  final bool showUserInfoIcon;
  final bool showDeleteIcon;
  final bool? disableScrollView;
  final bool loadFormDefinitionFormServer;
  final bool enableUpdateInputFormResponse;
  final String? formName;
  final bool isShowFormName;

  final String
  initState; //0:data loaded,  1: async loading by formResponseId, 2: async saving by formResponseId
  final bool isMultipageSections;
  final String formDefinitionFolderNodeId;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  final bool enablePopContextAfterSucessfullySaved;
  final bool isShowSaveButton;
  final bool enableTitle;
  final String syncCaption;
  final String nextCaption;
  final String prevCaption;
  final bool enableScaffold;
  final Color backgroundColor;
  final Color borderColor;
  final VwFormPageResult? resultCallback;
  final VwFormValidationResponse? formValidationResponse;




  static const String fsDataLoaded = 'fsDataLoaded';
  static const String errorLoadingForm = 'errorLoadingForm';
  static const String fsLoadingForm = 'fsLoadingForm';

  VwDefaultFormPageState createState()=> VwDefaultFormPageState();
}

class VwDefaultFormPageState extends State<VwFormPage> with SingleTickerProviderStateMixin
{
  late StreamController<String> _refreshController;
  late Key myFormKeyPortrait;
  late Key myFormKeyLandscape;
  late Key fieldKey;
  //late VwRowData currentFormResponse;
  late Animation<double> _animation;
  late AnimationController _animationController;
  late String currentState;
  late bool doUpsync;
  late bool needValidateBeforeMovingNextSection;
  late VwFormValidationResponse formValidationResponse;
  late int currentSection;
  String? toastMessage;
  Color? toastBgColor;
  late bool doClosePage;
  ScrollController _scrollController = ScrollController();
  late bool commentLoaded;
  late bool formResponseLoaded;
  late bool formDefinitionLoaded;
  late VwFormDefinition currentFormDefinition;
  VwNode? currentFormDefinitionNode;
  late String successMessage;
  late VwRowData initialValue;

  Widget inProgressButton = Row(children: [
    SizedBox(width: 50),
    VwCircularProgressIndicator(),
    SizedBox(
      width: 50,
    )
  ]);


  @override
  void initState() {
    super.initState();



    this.myFormKeyPortrait = UniqueKey();
    this.myFormKeyLandscape = UniqueKey();
    String jsonInputFormResponse = json .encode(widget.formResponse.toJson());
    VwRowData inputRowData =
    VwRowData.fromJson(json.decode(jsonInputFormResponse));
    this.initialValue = inputRowData;

    this.currentFormDefinition = this.widget.formDefinition;
    this.successMessage = this.getFormName() + " is successfully saved.";

    this.commentLoaded = false;
    this.formDefinitionLoaded = false;
    this.formResponseLoaded = false;
    if (widget.formResponse.renderedFormResponseList == null) {
      widget.formResponse.renderedFormResponseList = [];
    }

    if (this.widget.key == null) {
      this.fieldKey = Key(widget.formResponse.recordId);
    } else {
      this.fieldKey = widget.key!;
    }

    doClosePage = false;
    toastBgColor = Colors.green;

    bool isLoadDataFromServer = false;

    if (this.currentFormDefinition.isCommentEnabled == true ||
        this.currentFormDefinition.loadDetailFromServer == true ||
        this.widget.loadFormDefinitionFormServer == true) {
      isLoadDataFromServer = true;
    }

    if (isLoadDataFromServer == true) {
      this.currentState = VwFormPage.fsLoadingForm;

    } else {
      this.currentState = VwFormPage.fsDataLoaded;
    }

    if (this.widget.formResponse.recordId.toString() ==
        "2549f3cc-2e12-4bd0-b4e0-be791114930a") {
      print("ROI");
    }

    VwFormDefinitionUtil .addRowDataFromFormDefinition(
        formResponse: widget.formResponse,
        formParam: this.currentFormDefinition,
        ownerUserId: "root");

    widget.formResponse.formDefinitionId = this.currentFormDefinition.recordId;
    widget.formResponse.collectionName =
        this.currentFormDefinition.formResponseSyncCollectionName;
    if (widget.formResponse.creatorUserId == null) {
      try {
        widget.formResponse.creatorUserId =
            this.widget.appInstanceParam.loginResponse!.userInfo!.user.recordId;
      } catch (error) {}
    }

    VwClassEncodedJson formDefinitionClassEncodedJson = VwClassEncodedJson(
        data: this.currentFormDefinition.toJson(),
        instanceId: this.currentFormDefinition.recordId,
        className: "VwFormDefinition");
    RemoteApi .compressClassEncodedJson(formDefinitionClassEncodedJson);

    currentSection = 0;
    doUpsync = false;
    needValidateBeforeMovingNextSection = false;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
    CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    this.resetFormValidationResponse();
    if(this.widget.formValidationResponse!=null)
      {
        this.formValidationResponse=this.widget.formValidationResponse!;
      }



    this._refreshController = StreamController<String>(onListen: () async {




      await this._asyncLoadData();

    }
    );


  }

  Future<void> _asyncLoadData() async {
    VwFormDefinition returnValue = this.currentFormDefinition;
    if (this.widget.loadFormDefinitionFormServer == true) {
      await this._asyncLoadFormDefinitionFromServer();
    } else {
      returnValue = await this._asyncLoadFormResponse();
    }


  }

  Future<void> _asyncLoadDetailFormResponseFromServer() async {
    try {
      if (this.currentFormDefinition.loadDetailFromServer == true &&
          this.formResponseLoaded == false) {
        VwRowData apiCallParam = VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
              fieldName: "nodeId", valueString: widget.formResponse.recordId),
        ]);

        VwNodeRequestResponse returnValue = await RemoteApi.nodeRequestApiCall(
          baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
          graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
            apiCallId: "getNodes",
            apiCallParam: apiCallParam,
            loginSessionId:
            widget.appInstanceParam.loginResponse!.loginSessionId!);

        if (returnValue.renderedNodePackage != null &&
            returnValue.renderedNodePackage!.renderedNodeList != null) {
          this.formResponseLoaded = true;
          if (widget.formResponse.recordId ==
              returnValue
                  .renderedNodePackage!.rootNode!.content.rowData!.recordId) {
            widget.formResponse =
            returnValue.renderedNodePackage!.rootNode!.content.rowData!;

            if (widget.formResponse.formDefinitionLinkNode != null) {
              this.currentFormDefinitionNode = NodeUtil.getNode(
                  linkNode: widget.formResponse.formDefinitionLinkNode!);
              this.currentFormDefinition = VwFormDefinition.fromJson(this
                  .currentFormDefinitionNode!
                  .content!
                  .classEncodedJson!
                  .data!);
            }
          }
        }
      }
    } catch (error) {}
  }



  Future<VwFormDefinition> _asyncLoadFormResponse() async {
    VwFormDefinition returnValue = this.currentFormDefinition;
    try {
      DateTime startDate = DateTime.now();

      await this._asyncLoadDetailFormResponseFromServer();
      await this._asyncLoadComment();

      bool formResponseLoadedSuccess =
          this.currentFormDefinition.loadDetailFromServer == false ||
              (this.currentFormDefinition.loadDetailFromServer == true &&
                  this.formResponseLoaded == true);

      bool commentLoadedSuccess =
          this.currentFormDefinition.isCommentEnabled == false ||
              (this.currentFormDefinition.isCommentEnabled == true &&
                  this.commentLoaded == true);

      if (formResponseLoadedSuccess == true && commentLoadedSuccess == true) {
        this.currentState = VwFormPage.fsDataLoaded;
        this._refreshController.sink.add(VwFormPage.fsDataLoaded);
      } else {
        this.currentState = VwFormPage.errorLoadingForm;
        this._refreshController.sink.add(VwFormPage.errorLoadingForm);
      }

      DateTime endDateTime = DateTime.now();

      final int difference = startDate.difference(endDateTime).inSeconds;
      if (this.currentState == VwFormPage.errorLoadingForm && difference < 2) {
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (error) {
      print("Error catched on _asyncLoadFormResponse():" + error.toString());
    }

    return returnValue;
  }

  Future<void> _asyncLoadComment() async {
    try {
      print("formId=" + this.widget.formDefinition.recordId.toString());
      print("recordId= " + this.widget.formResponse.recordId.toString());
      print("isCommentEnabled=" +
          this.currentFormDefinition.isCommentEnabled.toString());
      if (this.widget.formResponse.recordId.toString() ==
          "2549f3cc-2e12-4bd0-b4e0-be791114930a") {
        print("ROI");
      }
      if (this.currentFormDefinition.isCommentEnabled == true &&
          commentLoaded == false) {
        print("responseNodeId: " + widget.formResponse.recordId);
        VwRowData apiCallParam = VwRowData(recordId: Uuid().v4(), fields: [
          VwFieldValue(
              fieldName: "nodeId",
              valueString: "response_usercommentformdefinition"),
          VwFieldValue(
              fieldName: "responseNodeId",
              valueString: widget.formResponse.recordId)
        ]);

        VwNodeRequestResponse returnValue = await RemoteApi.nodeRequestApiCall(
          baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
            graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
            apiCallId: "getNodes",
            apiCallParam: apiCallParam,
            loginSessionId:
            widget.appInstanceParam.loginResponse!.loginSessionId!);

        if (returnValue.renderedNodePackage != null &&
            returnValue.renderedNodePackage!.renderedNodeList != null) {
          commentLoaded = true;
          widget.formResponse.renderedFormResponseList = [];
          for (int la = 0;
          la < returnValue.renderedNodePackage!.renderedNodeList!.length;
          la++) {
            VwNode currentNode = returnValue
                .renderedNodePackage!.renderedNodeList!
                .elementAt(la);
            if (currentNode.content.rowData != null) {
              this
                  .widget
                  .formResponse
                  .renderedFormResponseList!
                  .add(currentNode.content.rowData!);
            }
          }
        }
      }
    } catch (error) {}
  }

  Future<void> _asyncLoadFormDefinitionFromServer() async {
    try {
      VwRowData apiCallParam = VwRowData(recordId: Uuid().v4(), fields: [
        VwFieldValue(
            fieldName: "nodeId",
            valueString: this.currentFormDefinition.recordId),
      ]);

      VwNodeRequestResponse returnValue = await RemoteApi.nodeRequestApiCall(
          baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
          graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
          apiCallId: "getNodes",
          apiCallParam: apiCallParam,
          loginSessionId: this.getLoginSessionId());

      if (returnValue.renderedNodePackage != null &&
          returnValue.renderedNodePackage!.rootNode != null) {
        if (returnValue
            .renderedNodePackage!.rootNode!.content.classEncodedJson !=
            null &&
            returnValue.renderedNodePackage!.rootNode!.content.classEncodedJson!
                .data !=
                null) {
          this.currentFormDefinition = VwFormDefinition.fromJson(returnValue
              .renderedNodePackage!.rootNode!.content.classEncodedJson!.data!);
          this.currentFormDefinitionNode =
          returnValue.renderedNodePackage!.rootNode!;
          this.currentState = VwFormPage.fsDataLoaded;

          widget.formResponse.formDefinitionId =
              this.currentFormDefinition.recordId;
          widget.formResponse.formDefinitionLinkNode = VwLinkNode(
              rendered: VwLinkNodeRendered(
                  renderedDate: DateTime.now(),
                  node: this.currentFormDefinitionNode),
              nodeId: this.currentFormDefinitionNode!.recordId!,
              nodeType: VwNode.ntnClassEncodedJson);

          this.formDefinitionLoaded = true;
        }
      }
    } catch (error) {}
    if (this.currentState != VwFormPage.fsDataLoaded) {
      this.currentState = VwFormPage.errorLoadingForm;
      this._refreshController.sink.add(VwFormPage.errorLoadingForm);
    }
  }

  void resetFormValidationResponse() {
    this.formValidationResponse = new VwFormValidationResponse(
        formDefinition: this.currentFormDefinition,
        formFieldValidationResponses: <VwFormFieldValidationResponse>[],
        isFormResponseValid: false);
  }

  String getFormName() {
    String returnValue = "";
    try {
      returnValue = this.widget.formName == null
          ? this.currentFormDefinition.formName
          : this.widget.formName!;
    } catch (error) {}
    return returnValue;
  }

  Widget getTitleWidget() {
    Widget returnValue = Container();

    if (this.widget.enableTitle == true) {
      Widget nodeInfoContent = Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: widget.borderColor)),
          child: Row(children: [
            Expanded(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                    children: <InlineSpan>[
                      WidgetSpan(
                          child: InkWell(
                              onLongPress: () async {
                                await Clipboard.setData(ClipboardData(
                                    text: widget.formResponse.recordId));

                                Fluttertoast.showToast(
                                    msg: "Copied to clipboard",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: this.toastBgColor,
                                    textColor: Colors.white,
                                    webBgColor:
                                    "linear-gradient(to right, #5dbb63, #5dbb63)",
                                    webPosition: "center",
                                    fontSize: 16.0);
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.copy, size: 14),
                                    Expanded(
                                        child: Text(
                                            overflow: TextOverflow.clip,
                                            "recordId: " +
                                                widget.formResponse.recordId,
                                            textAlign: TextAlign
                                                .center, // _snapshot.data['username']
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)))
                                  ]))),
                      TextSpan(text: "\n"),
                      TextSpan(
                          text: widget.formResponse.creatorUserId == null
                              ? ""
                              : "created by: " +
                              widget.formResponse.creatorUserId.toString() +
                              "\n"),
                      TextSpan(
                          text: widget.formResponse.timestamp == null
                              ? ""
                              : "created: " +
                              VwDateUtil .indonesianShortFormatLocalTimeZone(
                                  widget.formResponse.timestamp!.created) +
                              "\n"),
                      TextSpan(
                          text: widget.formResponse.timestamp == null
                              ? ""
                              : "updated: " +
                              VwDateUtil.indonesianShortFormatLocalTimeZone(
                                  widget.formResponse.timestamp!.updated))
                    ],
                  ),
                ))
          ]));

      Widget formNameWidget = Container(
        padding: EdgeInsets.all(6),
        constraints: BoxConstraints(maxWidth: 600),
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: widget.borderColor)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                getFormName(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );



      Widget nodeInfoWidget = ExpansionTileCard(
        title: InkWell(
            onLongPress: () async {
              await Clipboard.setData(
                  ClipboardData(text: widget.formResponse.recordId));

              Fluttertoast.showToast(
                  msg: "Copied to clipboard",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: this.toastBgColor,
                  textColor: Colors.white,
                  webBgColor: "linear-gradient(to right, #5dbb63, #5dbb63)",
                  webPosition: "center",
                  fontSize: 16.0);
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.copy, size: 14),
              Expanded(
                  child: Text(
                      overflow: TextOverflow.clip,
                      "recordId: " + widget.formResponse.recordId,
                      textAlign: TextAlign.center, // _snapshot.data['username']
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)))
            ])),
        children: [nodeInfoContent],
      );

      returnValue = Container(
          constraints: BoxConstraints(maxWidth: 600),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: 5,
            ),
            formNameWidget,


          ]));
    }

    return returnValue;
  }

  Widget getFormView(Key key) {
    Widget returnValue = Container();
    try {
      Widget titleWidget = getTitleWidget();

      if(this.widget.isShowFormName==false)
      {
        titleWidget=Container();
      }

      returnValue = Container(
          key: key,
          margin: EdgeInsets.fromLTRB(8, 20, 8, 30),
          color: widget.backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [titleWidget, getFormWidget(), this.getControlButton()],
          ));
    } catch (error) {
      print("Error catched on VwForm.formSscrollView:" + error.toString());
    }

    return returnValue;
  }

  void scrollToTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  Future<VwFormValidationResponse>? _asyncValidateForm() async {
    try {
      String formResponseInString = json.encode(widget.formResponse);
      VwRowData validationFormResponse =
      VwRowData.fromJson(json.decode(formResponseInString));

      print("BeforeEmptying Data= " + formResponseInString.length.toString());
      FormUtil .nullifySyncDataOnStorageField(validationFormResponse);
      VwRowDataUtil .unsetValueLinkNodeRendered(validationFormResponse);
      VwRowDataUtil.cleanFieldValueRenderedFormResponseList(
          validationFormResponse);

      String formResponseInStringAfterEmptying =
      json.encode(validationFormResponse);

      print("AfterEmptying Data= " +
          formResponseInStringAfterEmptying.length.toString());

      VwRowData formResponseCloned = validationFormResponse;

      if (formResponseCloned.attachments != null) {
        for (int la = 0; la < formResponseCloned.attachments!.length; la++) {
          VwNodeContent currentNodeContent =
          formResponseCloned.attachments!.elementAt(la);
          if (currentNodeContent.linkbasemodel != null &&
              currentNodeContent.linkbasemodel!.cache != null) {
            int lengthDataCompressed = currentNodeContent
                .linkbasemodel!.cache!.dataCompressedBase64!.length;
            RemoteApi.decompressClassEncodedJson(
                currentNodeContent.linkbasemodel!.cache!);
            String dataUncompressed =
            json.encode(currentNodeContent.linkbasemodel!.cache!.data);
            int lengthDataUncompressed = dataUncompressed.length;

            RemoteApi.compressClassEncodedJson(
                currentNodeContent.linkbasemodel!.cache!);
            int lengthDataRecompressed = currentNodeContent
                .linkbasemodel!.cache!.dataCompressedBase64!.length;

            print("compressed=" +
                lengthDataCompressed.toString() +
                ", umcompressed=" +
                lengthDataUncompressed.toString() +
                ", recompressed=" +
                lengthDataRecompressed.toString());
          }
        }
      }

      VwFieldValue fieldValueValidateForm = VwFieldValue(
          valueTypeId: VwFieldValue.vatClassEncodedJson,
          fieldName: "formResponse",
          valueClassEncodedJson: VwClassEncodedJson(
              instanceId: validationFormResponse.recordId,
              data: validationFormResponse.toJson(),
              className: "VwRowData"));

      RemoteApi.compressClassEncodedJson(
          fieldValueValidateForm.valueClassEncodedJson!);

      VwRowData apiCallParam = VwRowData(
          timestamp: VwDateUtil.nowTimestamp(),
          recordId: Uuid().v4(),
          fields: [fieldValueValidateForm]);

      VwApiCallResponse ? apiCallResponse = await RemoteApi.requestApiCall(
          baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
        graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
          apiCallId: "validateFormResponse",
          apiCallParam: apiCallParam,
          loginSessionId:
          widget.appInstanceParam.loginResponse!.loginSessionId!);

      if (apiCallResponse != null &&
          apiCallResponse.valueResponseClassEncodedJson != null &&
          apiCallResponse.valueResponseClassEncodedJson!.data != null) {
        VwFormValidationResponse formValidationResponse =
        VwFormValidationResponse.fromJson(
            apiCallResponse.valueResponseClassEncodedJson!.data!);

        return formValidationResponse;
      }
    } catch (error) {
      print("Error catched on _asyncValidateForm(): " + error.toString());
    }

    return VwFormValidationResponse(
        formDefinition: this.currentFormDefinition,
        formFieldValidationResponses: []);
  }

  Future<void>? _asyncValidateSectionForm() async {
    try {
      if (needValidateBeforeMovingNextSection == true) {
        needValidateBeforeMovingNextSection = false;

        bool isAnyValidationErrorOnCurrentSection = false;
        VwFormValidationResponse? formValidationResponse =
        await this._asyncValidateForm();

        if (formValidationResponse != null) {
          this.formValidationResponse = formValidationResponse;

          List<VwFormFieldValidationResponse>
          currentFormFieldValidationResponseList = [];

          VwSectionFormDefinition currentSectionFormDefinition =
          this.currentFormDefinition.sections.elementAt(currentSection);

          for (int lb = 0;
          lb < currentSectionFormDefinition.formFields.length;
          lb++) {
            VwFormField currentFormField =
            currentSectionFormDefinition.formFields.elementAt(lb);

            for (int ld = 0;
            formValidationResponse.formFieldValidationResponses != null &&
                ld <
                    formValidationResponse
                        .formFieldValidationResponses!.length;
            ld++) {
              VwFormFieldValidationResponse currentFormFieldValidationResponse =
              formValidationResponse.formFieldValidationResponses!
                  .elementAt(ld);

              if (currentFormFieldValidationResponse
                  .formField.fieldDefinition.fieldName ==
                  currentFormField.fieldDefinition.fieldName) {
                for (int le = 0;
                le <
                    currentFormFieldValidationResponse
                        .validationReponses.length;
                le++) {
                  VwFormFieldValidationResponseComponent
                  currentFormFieldValidationResponseComponent =
                  currentFormFieldValidationResponse.validationReponses
                      .elementAt(le);
                  if (currentFormFieldValidationResponseComponent
                      .isValidationPassed ==
                      false) {
                    isAnyValidationErrorOnCurrentSection = true;
                  }
                }

                currentFormFieldValidationResponseList
                    .add(currentFormFieldValidationResponse);
              }
            }
          }
          formValidationResponse.formFieldValidationResponses =
              currentFormFieldValidationResponseList;
          this.formValidationResponse = formValidationResponse;

          if (isAnyValidationErrorOnCurrentSection == false) {
            currentSection = currentSection + 1;
            this.scrollToTop();
          } else {
            this.toastMessage =
            "Error: Input Data Ada Yang Belum Sesuai. Mohon periksa kembali";
            this.toastBgColor = Colors.red.shade500;
          }
        } else {
          this.toastMessage = "Error: Tidak terhubung ke server";
          this.toastBgColor = Colors.red.shade500;
          ;
        }
      }
    } catch (error) {}
  }

  Widget getControlButton() {
    Widget prevButton = currentSection == 0
        ? Container()
        : TextButton.icon(
        icon: Icon(Icons.navigate_before, color: Colors.blue),
        style: OutlinedButton.styleFrom(
          //backgroundColor: Colors.black,
          //primary: Colors.white,
          /*shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),*/
          side: BorderSide(color: Colors.blue, width: 2), //<-- SEE HERE
        ),
        onPressed: () {
          this.toastMessage = null;
          currentSection = currentSection - 1;
          this.scrollToTop();
          setState(() {});
        },
        label: Text(
          this.widget.prevCaption,
          style: TextStyle(color: Colors.blue),
        ));

    Widget nextButton = TextButton.icon(
      icon: Icon(Icons.navigate_next, color: Colors.blue),
      label: Text(
        this.widget.nextCaption,
        style: TextStyle(color: Colors.blue),
      ),
      style: OutlinedButton.styleFrom(
        //backgroundColor: Colors.black,
        //primary: Colors.white,

        side: BorderSide(color: Colors.blue, width: 2), //<-- SEE HERE
      ),
      onPressed: () async {
        this.toastMessage = null;

        if (this.currentFormDefinition.isReadOnly == false) {
          if (needValidateBeforeMovingNextSection == false) {
            needValidateBeforeMovingNextSection = true;

            showDialog(
              // The user CANNOT close this dialog  by pressing outsite it
                barrierDismissible: false,
                useRootNavigator: false,
                context: context,
                builder: (_) {
                  Dialog dialog = Dialog(
                    // The background color

                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          // The loading indicator
                          VwCircularProgressIndicator(),
                          SizedBox(
                            height: 15,
                          ),
                          // Some text
                          Text('Proses Validasi Form...')
                        ],
                      ),
                    ),
                  );

                  return WillPopScope(
                      child: dialog,
                      onWillPop: () {
                        return Future.value(false);
                      });
                });
            if (!mounted) return;
            await this._asyncValidateSectionForm();

            Navigator.of(context).pop();
          }
        } else {
          currentSection = currentSection + 1;
        }
        setState(() {});
      },
    );

    Widget submitButtonLink = Container();

    String submitButtonMode = "hidden"; //hidden, comment, submit

    Widget submitButtonWidget =
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          width: 150,
          height: 45,
          child: TextButton.icon(
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
              /*
              style:ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),

                side: BorderSide(color: Colors.blue, width: 3), //<-- SEE HERE
              ),*/

              onPressed: () async {
                this.toastMessage = null;
                if (this.doUpsync == false &&
                    this.currentState == VwFormPage.fsDataLoaded) {
                  this.doUpsync = true;

                  showDialog(
                    // The user CANNOT close this dialog  by pressing outsite it
                      barrierDismissible: false,
                      useRootNavigator: false,
                      context: context,
                      builder: (_) {
                        Dialog dialog = Dialog(
                          // The background color

                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                // The loading indicator
                                VwCircularProgressIndicator(),
                                SizedBox(
                                  height: 15,
                                ),
                                // Some text
                                Text('Menyimpan Form ke Server...')
                              ],
                            ),
                          ),
                        );

                        return WillPopScope(
                            child: dialog,
                            onWillPop: () {
                              return Future.value(false);
                            });
                      });

                  await this._asyncSaveFormResponse (
                      crudMode:
                      this.currentFormDefinition.formResponseSyncCrudMode);
                  Navigator.of(context).pop();

                  if (this.doClosePage == true) {
                    Navigator.pop(context);
                  } else {
                    setState(() {});
                  }
                }
              },
              icon: const Icon(Icons.check, color: Colors.white),
              label: Text(
                this.widget.syncCaption,
                style: TextStyle(fontSize: 18, color: Colors.white),
              )))
    ]);

    Widget submitCommentButton =
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          width: 150,
          height: 45,
          child: ElevatedButton.icon(
              onPressed: () async {
                this.toastMessage = null;
                if (this.doUpsync == false &&
                    this.currentState == VwFormPage.fsDataLoaded) {
                  this.doUpsync = true;

                  showDialog(
                    // The user CANNOT close this dialog  by pressing outsite it
                      barrierDismissible: false,
                      useRootNavigator: false,
                      context: context,
                      builder: (_) {
                        Dialog dialog = Dialog(
                          // The background color

                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                // The loading indicator
                                VwCircularProgressIndicator(),
                                SizedBox(
                                  height: 15,
                                ),
                                // Some text
                                Text('Menyimpan Data Verifikasi ke Server...')
                              ],
                            ),
                          ),
                        );

                        return PopScope(
                            child: dialog,
                            onPopInvoked: (didPop) {
                              didPop = false;
                              return;
                              //return Future.value(false);
                            });
                      });

                  await this._asyncSaveComment();
                  Navigator.of(context).pop();

                  setState(() {});
                }
              },
              icon: const Icon(Icons.check),
              label: Text(
                'Submit Verifikasi',
                style: TextStyle(fontSize: 18),
              )))
    ]);

    if (this.currentFormDefinition.isReadOnly == true ||
        this.widget.isShowSaveButton == false) {
      try {
        if (widget.formResponse.creatorUserId != null &&
            widget.appInstanceParam.loginResponse!.userInfo!.user.recordId !=
                null &&
            widget.formResponse.creatorUserId !=
                widget
                    .appInstanceParam.loginResponse!.userInfo!.user.recordId &&
            this.currentFormDefinition.isCommentEnabled == true) {
          submitButtonMode = "comment";
        }
      } catch (error) {}
    } else {
      submitButtonMode = "submit";
    }

    if (submitButtonMode == "submit") {
      submitButtonLink = submitButtonWidget;
    } else if (submitButtonMode == "comment" &&
        this.currentFormDefinition.isShowSubmitCommentButton == true) {
      submitButtonLink = submitCommentButton;
    }

    Widget nextOrSubmitButton =
    currentSection + 1 < this.currentFormDefinition.sections.length
        ? nextButton
        : this.currentFormDefinition.isReadOnly == true &&
        this.currentFormDefinition.isCommentEnabled == false
        ? Container()
        : this.currentState == VwFormPage.fsDataLoaded
        ? submitButtonLink
        : inProgressButton;

    Widget returnValue = Container(
        constraints: BoxConstraints(maxWidth: 600),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [prevButton, nextOrSubmitButton],
        ));

    return returnValue;
  }

  void _implementOnFormFieldValueChanged(
      VwFieldValue newValue,
      VwFieldValue oldValue,
      VwRowData currentFormResponse,
      bool isDoSetState) {

  }

  Widget getFormWidget() {
    Widget body = VwForm(

        key: this.fieldKey,
        fieldBoxDecoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: widget.borderColor)),
        appInstanceParam: widget.appInstanceParam,
        formValidationResponse: this.formValidationResponse,
        sectionIndex: currentSection,
        initFormResponse: widget.formResponse,
        backGroundColor: widget.backgroundColor,
        onFormValueChanged: _implementOnFormFieldValueChanged,
        formDefinition: this.currentFormDefinition);

    return Container(
        constraints: BoxConstraints(maxWidth: 600),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
        child: body);
  }

  Future<VwFormDefinition> _asyncSaveComment() async {
    VwFormDefinition returnValue = this.currentFormDefinition;
    try {
      if (this.doUpsync == true) {
        this.doUpsync = false;
        needValidateBeforeMovingNextSection = false;
        bool isSyncSuccessfull = false;

        SyncTokenBlock? syncTokenBlock = await VwNodeStoreOnHive.getToken(
            //graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
            baseUrl:this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl ,
            loginSessionId:
            widget.appInstanceParam.loginResponse!.loginSessionId!,
            count: widget.formResponse.syncFormResponseList!.length,
            apiCallId: "getToken");

        if (syncTokenBlock != null && syncTokenBlock.tokenList.length > 0) {
          if (widget.formResponse.timestamp != null) {
            widget.formResponse.timestamp!.updated = DateTime.now();
          }

          if (widget.formResponse.creatorUserId == null) {
            widget.formResponse.creatorUserId = this
                .widget
                .appInstanceParam
                .loginResponse!
                .userInfo
                ?.user
                .recordId;
          }

          List<VwFileStorage> uploadFileStorageList = [];

          if (widget.formResponse.syncFormResponseList != null &&
              widget.formResponse.syncFormResponseList!.length > 0) {
            List<VwFieldValue> commentFieldValueList = [];
            for (int lz = 0;
            lz < widget.formResponse.syncFormResponseList!.length;
            lz++) {
              VwRowData userComment =
              widget.formResponse.syncFormResponseList!.elementAt(lz);

              String formResponseInString = json.encode(userComment);
              VwRowData submitFormResponse =
              VwRowData.fromJson(json.decode(formResponseInString));

              FormUtil.extractVwFileStorage(
                  submitFormResponse, uploadFileStorageList);

              widget.formResponse.crudMode =
                  this.currentFormDefinition.formResponseSyncCrudMode;
              VwNode formResponseNode = NodeUtil.generateNodeRowData(
                  rowData: submitFormResponse,
                  upsyncToken: syncTokenBlock.tokenList.elementAt(lz),
                  parentNodeId: this.widget.formDefinitionFolderNodeId,
                  ownerUserId: this
                      .widget
                      .appInstanceParam
                      .loginResponse!
                      .userInfo!
                      .user
                      .recordId);

              VwFieldValue fieldValueFormResponse = VwFieldValue(
                  valueTypeId: VwFieldValue.vatClassEncodedJson,
                  fieldName: Uuid().v4(),
                  valueClassEncodedJson: VwClassEncodedJson(
                      uploadFileStorageList: uploadFileStorageList,
                      instanceId: formResponseNode.recordId,
                      data: formResponseNode.toJson(),
                      className: "VwNode"));

              RemoteApi.compressClassEncodedJson(
                  fieldValueFormResponse.valueClassEncodedJson!);

              commentFieldValueList.add(fieldValueFormResponse);
            }

            VwRowData apiCallParam = VwRowData(
                timestamp: VwDateUtil.nowTimestamp(),
                recordId: Uuid().v4(),
                fields: commentFieldValueList);

            VwNodeUpsyncResultPackage nodeUpsyncResultPackage =
            await RemoteApi.nodeUpsyncRequestApiCall(
                baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
                //graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
                apiCallId: "syncNodeContent",
                apiCallParam: apiCallParam,
                loginSessionId: this
                    .widget
                    .appInstanceParam
                    .loginResponse!
                    .loginSessionId!);

            if (nodeUpsyncResultPackage.nodeUpsyncResultList.length > 0) {
              VwNodeUpsyncResult nodeUpsyncResult =
              nodeUpsyncResultPackage.nodeUpsyncResultList.elementAt(0);

              if (nodeUpsyncResult.syncResult.createdCount == 1 ||
                  nodeUpsyncResult.syncResult.updatedCount == 1 ||
                  nodeUpsyncResult.syncResult.deletedCount ==1
              ) {
                isSyncSuccessfull = true;
              } else {
                this.toastBgColor = Colors.red.shade500;
                this.toastMessage =
                    "Error:  response can't be saved, errorMessage: " +
                        nodeUpsyncResult.syncResult.errorMessage.toString();
              }
            }
          }
        } else {
          this.toastBgColor = Colors.red.shade500;

          if (syncTokenBlock != null &&
              syncTokenBlock.isServerResponded == true) {
            this.toastMessage =
            "Error:  response can't be saved.\n Autorisasi tidak berhasil.";
          } else {
            this.toastMessage =
            "Error:  response can't be saved.\n Tidak terhubung dengan server.";
          }
        }

        if (isSyncSuccessfull == true) {
          this.toastMessage = "Response sucessfully saved";
          this.toastBgColor = Colors.green;

          if (this.widget.refreshDataOnParentFunction != null) {
            this.widget.refreshDataOnParentFunction!();
          }
        }

        Fluttertoast.showToast(
            msg: toastMessage.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: this.toastBgColor,
            textColor: Colors.white,
            webBgColor: "linear-gradient(to right, #5dbb63, #5dbb63)",
            webPosition: "center",
            fontSize: 14.0);
      }
    } catch (error) {
      print("Error catched on VwFormPage._asyncSaveComment(): " +
          error.toString());
    }

    return returnValue;
  }

  String getCreatorUserId() {
    String returnValue = this.widget.appInstanceParam.baseAppConfig.generalConfig.guestUserId;
    try {
      returnValue =
          this.widget.appInstanceParam.loginResponse!.userInfo!.user.recordId;
    } catch (error) {}
    return returnValue;
  }


  String getLoginSessionId() {
    String returnValue = this.widget.appInstanceParam.baseAppConfig.generalConfig.loginSessionGuestUserId;
    try {
      returnValue = widget.appInstanceParam.loginResponse!.loginSessionId!;
    } catch (error) {}

    return returnValue;
  }

  void reset() {
    String jsonInputFormResponse = json.encode(this.initialValue.toJson());

    VwRowData inputRowData =
    VwRowData.fromJson(json.decode(jsonInputFormResponse));

    widget.formResponse = inputRowData;

    widget.formResponse.recordId = Uuid().v4();

    this.fieldKey = UniqueKey();

    setState(() {});
  }

  Future<VwFormDefinition> _asyncSaveFormResponse(
      {bool validateForm = true, required String crudMode}) async {
    VwFormDefinition returnValue = this.currentFormDefinition;
    try {
      if (this.doUpsync == true) {
        this.doUpsync = false;
        needValidateBeforeMovingNextSection = false;
        bool isSyncSuccessfull = false;
        this.resetFormValidationResponse();

        if (this.currentFormDefinition.dataSource ==
            VwDataSourceDefinition.smParent) {
          if (validateForm == true) {
            VwFormValidationResponse? currentFormValidationResponse =
            await this._asyncValidateForm();

            if (currentFormValidationResponse != null) {
              this.formValidationResponse = currentFormValidationResponse;
            }
          }

          if (validateForm == false ||
              (validateForm == true &&
                  this.formValidationResponse.isFormResponseValid == true)) {
            VwNode formResponseNode = NodeUtil.generateNodeRowData(
                rowData: widget.formResponse,
                upsyncToken: "<invalid_sync_token>",
                parentNodeId: this.widget.formDefinitionFolderNodeId,
                ownerUserId: getCreatorUserId());

            if (widget.syncNodeToParentFunction != null) {
              widget.syncNodeToParentFunction!(formResponseNode);
            }

            isSyncSuccessfull = true;
            this.toastMessage = "Field sudah valid";
            this.toastBgColor = Colors.green;

            // this.widget.formResponse =widget.formResponse;
            if(this.widget.resultCallback!=null)
            {
              this.widget.resultCallback!(widget.formResponse);
            }
            //widget.result=widget.formResponse;
            this.currentState = VwFormPage.fsDataLoaded;


            if (widget.enablePopContextAfterSucessfullySaved) {
              this.doClosePage = true;
            }
          }
        } else if (this.currentFormDefinition.dataSource ==
            VwDataSourceDefinition.smServer) {
          SyncTokenBlock? syncTokenBlock = await VwNodeStoreOnHive.getToken(
              baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
            //graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
              loginSessionId: this.getLoginSessionId(),
              count: 1,
              apiCallId: "getToken");

          if (syncTokenBlock != null) {
            if (widget.formResponse.timestamp != null) {
              widget.formResponse.timestamp!.updated = DateTime.now();
            }

            if (widget.formResponse.creatorUserId == null) {
              widget.formResponse.creatorUserId = this.widget.appInstanceParam.baseAppConfig.generalConfig.guestUserId;
            }
            List<VwFileStorage> uploadFileStorageList = [];

            String formResponseInString = json.encode(widget.formResponse);
            VwRowData submitFormResponse =
            VwRowData.fromJson(json.decode(formResponseInString));

            VwRowDataUtil.cleanFieldValueRenderedFormResponseList(
                submitFormResponse);
            VwRowDataUtil.unsetValueLinkNodeRendered(submitFormResponse);

            if (submitFormResponse.fields != null) {
              for (int la = 0; la < submitFormResponse.fields!.length; la++) {
                VwFieldValue currentFieldValue =
                submitFormResponse.fields!.elementAt(la);

                if (currentFieldValue.valueFormResponse != null) {
                  currentFieldValue.valueFormResponse!.formDefinitionLinkNode =
                  null;
                  currentFieldValue
                      .valueFormResponse!.cmReadFormDefinitionLinkNode = null;
                  currentFieldValue.valueFormResponse!.attachments = [];
                }
              }
            }

            if (this.currentFormDefinition.formResponseSyncCollectionName !=
                null) {
              submitFormResponse.collectionName =
              this.currentFormDefinition.formResponseSyncCollectionName!;
            }

            FormUtil.extractVwFileStorage(
                submitFormResponse, uploadFileStorageList);

            submitFormResponse.crudMode = crudMode;

            VwNode formResponseNode = NodeUtil.generateNodeRowData(
                rowData: submitFormResponse,
                upsyncToken: syncTokenBlock.tokenList.elementAt(0),
                parentNodeId: this.widget.formDefinitionFolderNodeId,
                ownerUserId: getCreatorUserId());

            VwFieldValue fieldValueFormResponse = VwFieldValue(
                valueTypeId: VwFieldValue.vatClassEncodedJson,
                fieldName: "VwFormResponseNode",
                valueClassEncodedJson: VwClassEncodedJson(
                    uploadFileStorageList: uploadFileStorageList,
                    instanceId: formResponseNode.recordId,
                    data: formResponseNode.toJson(),
                    className: "VwNode"));

            RemoteApi.compressClassEncodedJson(
                fieldValueFormResponse.valueClassEncodedJson!);

            VwRowData apiCallParam = VwRowData(
                timestamp: VwDateUtil.nowTimestamp(),
                recordId: Uuid().v4(),
                fields: [fieldValueFormResponse]);

            VwNodeUpsyncResultPackage nodeUpsyncResultPackage =
            await RemoteApi.nodeUpsyncRequestApiCall(
                baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
              //graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
                apiCallId: "syncNodeContent",
                apiCallParam: apiCallParam,
                loginSessionId: this.getLoginSessionId());

            if (nodeUpsyncResultPackage.nodeUpsyncResultList.length > 0) {
              VwNodeUpsyncResult nodeUpsyncResult =
              nodeUpsyncResultPackage.nodeUpsyncResultList.elementAt(0);

              if (nodeUpsyncResult.formValidationResponse != null) {
                this.formValidationResponse =
                nodeUpsyncResult.formValidationResponse!;
              }

              if (nodeUpsyncResult.syncResult.createdCount == 1 ||
                  nodeUpsyncResult.syncResult.updatedCount == 1 ||
                  nodeUpsyncResult.syncResult.deletedCount==1) {
                isSyncSuccessfull = true;
                if (nodeUpsyncResult.syncResult.successMessage != null) {
                  this.successMessage =
                  nodeUpsyncResult.syncResult.successMessage!;
                }

                if (widget.syncNodeToParentFunction != null) {
                  widget.syncNodeToParentFunction!(formResponseNode);
                }
              } else {
                this.toastBgColor = Colors.red.shade500;
                ;
                this.toastMessage = this.getFormName() +
                    " Error: Current Record can't be saved, errorMessage: " +
                    nodeUpsyncResult.syncResult.errorMessage.toString();
              }
            }
          } else {
            this.toastBgColor = Colors.red.shade500;
            this.toastMessage = "Error: " +
                this.getFormName() +
                " Error: Current Record can't be saved.\n Auhorization failed.";
          }

          if (isSyncSuccessfull == true) {
            this.toastMessage = this.successMessage;

            this.toastBgColor = Colors.green;

            if (widget.enablePopContextAfterSucessfullySaved) {
              this.doClosePage = true;
            }

            if (this.widget.refreshDataOnParentFunction != null) {
              this.widget.refreshDataOnParentFunction!();
            }
            if (widget.enablePopContextAfterSucessfullySaved == true) {
              Fluttertoast.showToast(
                  msg: toastMessage.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 4,
                  backgroundColor: this.toastBgColor,
                  textColor: Colors.white,
                  webBgColor: "linear-gradient(to right, #5dbb63, #5dbb63)",
                  webPosition: "center",
                  fontSize: 16.0);
              this.doClosePage = true;
            }

            if (this.doClosePage == false) {
              this.reset();
            }
          }
        }

        if (isSyncSuccessfull == false) {
          this.toastBgColor = Colors.red.shade500;
          ;

          if (formValidationResponse == null ||
              (formValidationResponse != null &&
                  (formValidationResponse!.isTryValidated == null ||
                      formValidationResponse!.isTryValidated == false))) {
            this.toastMessage =
            "Error: Current Record Can't be saved.\nCan't connect to server";
          } else {
            String? errorMessage = formValidationResponse.errorMessage;

            if (errorMessage != null) {
              this.toastMessage = "Error: " + errorMessage;
            }
          }
        } else {}
      }
    } catch (error) {
      print("Error catched on VwFormPage._asyncSaveFormParam(): " +
          error.toString());
    }

    return returnValue;
  }

  Widget getFormScrollView(Key key) {
    Widget toastMessageWidget = toastMessage != null
        ? Container(
        padding: EdgeInsets.all(5),
        color: this.toastBgColor,
        child: Text(
          toastMessage.toString(),
          style: TextStyle(fontSize: 16, color: Colors.white),
        ))
        : Container();

    return SingleChildScrollView(
        controller: this._scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        key: key,
        child: Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 100),
            color: widget.backgroundColor,
            child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(fit: FlexFit.loose, child: toastMessageWidget),
                    //this.getTitleWidget(),
                    this.getFormWidget(),
                    this.getControlButton()
                  ],
                ))));
  }



  Widget _buildPageMultipageSections(BuildContext context) {
    Widget formView = this.getFormView(Key(currentSection.toString()));

    if (this.widget.disableScrollView == false) {
      formView = this.getFormScrollView(Key(currentSection.toString()));
    }

    formView = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: formView,
    );

    Widget printIconWidget = Container(
        margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
        child: InkWell(
          onTap: () async {
            String urlLink = this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl +
                "/rowdataexcel?recordId=" +
                widget.formResponse.recordId;

            final Uri url = Uri.parse(urlLink);

            await launchUrl(url);
          },
          child: Icon(
            Icons.print,
            size: 25,
          ),
        ));



    Widget nodeInfoIconWidget=Container(
      margin: EdgeInsets.fromLTRB(0, 0, 13, 0),
      child: InkWell(child:Icon(Icons.info_outline,size: 18,color: Colors.blue,),onTap: () async{
        await Navigator.push(
            context,
            MaterialTransparentRoute(
                builder: (context) => VwNodeInfoForm (formResponse: widget.formResponse) ));
      },)  ,
    );

    List<Widget> actionWidget = [];
    actionWidget.add(nodeInfoIconWidget);

    Widget deleteIconWidget = Container(
        margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
        child: InkWell(
          onLongPress: () async {
            VwFieldValue modalResult = VwFieldValue(fieldName: "modalResult");

            await Navigator.push(
              context,
              MaterialTransparentRoute(
                  builder: (context) =>
                      VwConfirmDialog(fieldValue: modalResult)),
            );

            if (modalResult.valueString == "yes") {
              this.toastMessage = null;
              if (this.doUpsync == false &&
                  this.currentState == VwFormPage.fsDataLoaded) {
                this.doUpsync = true;

                showDialog(
                  // The user CANNOT close this dialog  by pressing outsite it
                    barrierDismissible: false,
                    useRootNavigator: false,
                    context: context,
                    builder: (_) {
                      Dialog dialog = Dialog(
                        // The background color

                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              // The loading indicator
                              VwCircularProgressIndicator(),
                              SizedBox(
                                height: 15,
                              ),
                              // Some text
                              Text('Sinkronisasi Data ke Server...')
                            ],
                          ),
                        ),
                      );

                      return WillPopScope(
                          child: dialog,
                          onWillPop: () {
                            return Future.value(false);
                          });
                    });

                await this._asyncSaveFormResponse(
                    validateForm: false, crudMode: VwBaseModel .cmDelete);
                Navigator.of(context).pop();

                if (this.doClosePage == true) {
                  Navigator.pop(context);
                } else {
                  setState(() {});
                }
              }
            } else {
              print("no");
            }
          },
          child: Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: 25,
          ),
        ));



    if (this.widget.formResponse.recordId ==
        "6efaef28-345a-4572-bef2-bdf69be66229") {
      actionWidget.add(printIconWidget);
    }

    if ((widget.appInstanceParam.loginResponse != null &&
        widget.appInstanceParam.loginResponse!.userInfo != null &&
        widget.appInstanceParam.loginResponse!.userInfo!.user!
            .mainRoleUserGroupId !=
            null &&
        (widget.appInstanceParam.loginResponse!.userInfo!.user!.mainRoleUserGroupId!
             ==
            this.widget.appInstanceParam.baseAppConfig.generalConfig.appAdminUserMainRole || widget.appInstanceParam.loginResponse!.userInfo!.user!.mainRoleUserGroupId!
            ==
            this.widget.appInstanceParam.baseAppConfig.generalConfig.rootMainRole)    ) ||
        (widget.showDeleteIcon == true &&
            this.currentFormDefinition.enableDeleteRecord == true &&
            this.currentFormDefinition.isReadOnly == false)) {
      actionWidget.add(deleteIconWidget);
    }

    //Widget page = formScrollView;

    Widget returnValue = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          bool isPortrait = true;

          Key currentFormKey = myFormKeyPortrait;

          if (constraints.maxWidth > constraints.maxHeight) {
            isPortrait = false;
            currentFormKey = myFormKeyLandscape;
          }

          if (widget.enableScaffold == true) {
            return Scaffold(
              key: this.fieldKey,
              resizeToAvoidBottomInset: true,
              backgroundColor: this.widget.backgroundColor,
              appBar: widget.isShowAppBar == false
                  ? null
                  : AppBar(
                title: Text(
                  getFormName(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                actions: actionWidget,
              ),
              body: formView,
            );
          } else {
            return formView;
          }
        });

    return returnValue;
  }

  Widget _reloadForm(String caption) {
    Widget body = InkWell(
        onTap: () async{

            this.currentState = VwFormPage.fsLoadingForm;
            this._refreshController.sink.add(VwFormPage.fsLoadingForm);
            await this._asyncLoadData();

        },
        child: Container(
            color: Colors.blue,
            child: Icon(Icons.refresh, color: Colors.white, size: 60)));

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        body,
        Container(margin: EdgeInsets.all(10), child: Text(caption))
      ],
    );
  }

  Widget _builReloadForm(String caption) {
    if (this.widget.disableScrollView == false) {
      return this._reloadFormWithScaffold(caption);
    } else {
      return this._reloadForm(caption);
    }
  }

  Widget _reloadFormWithScaffold(String caption) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(child: this._reloadForm(caption)));
  }

  Widget _buildLoadingWidget(String caption) {
    if (this.widget.disableScrollView == false) {
      return WidgetUtil.loadingWidget(caption);
    } else {
      return WidgetUtil.loadingWidgetDisableScaffold(caption);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _refreshController.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData && snapshot.data == VwFormPage.fsDataLoaded) {
            return this._buildPageMultipageSections(context);
          } else if (snapshot.hasData && snapshot.data == VwFormPage.errorLoadingForm) {
            return this
                ._builReloadForm("Error: Not Connected To Server. Click to Reload Page");
          } else {
            return _buildLoadingWidget("Loading...");
          }
        });
  }
}