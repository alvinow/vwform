import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwapicall/synctokenblock/synctokenblock.dart';
import 'package:matrixclient2base/modules/base/vwbasemodel/vwbasemodel.dart';
import 'package:matrixclient2base/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwfilestorage/vwfilestorage.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformvalidationresponse.dart';
import 'package:vwform/modules/vwnodeupsyncresult/vwnodeupsyncresult.dart';
import 'package:vwform/modules/vwnodeupsyncresultpackage/vwnodeupsyncresultpackage.dart';
import 'package:vwnodestoreonhive/vwnodestoreonhive/vwnodestoreonhive.dart';
import 'package:vwutil/modules/util/formutil.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class SendMesageBoxWidget extends StatefulWidget {
  SendMesageBoxWidget(
      {required this.recipientRecordId,
      required this.appInstanceParam,
      this.syncNodeToParentFunction,
      this.refreshDataOnParentFunction});

  final String recipientRecordId;
  final VwAppInstanceParam appInstanceParam;
  final SyncNodeToParentFunction? syncNodeToParentFunction;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  SendMesageBoxWidgetState createState() => SendMesageBoxWidgetState();
}

class SendMesageBoxWidgetState extends State<SendMesageBoxWidget> {
  late VwRowData sendNewMessage;
  late String senderRecordId;
  VwFormValidationResponse? formValidationResponse;
  late int
      messageState; //0:newMessage 1:failedToSend404 2:failedToSendAuthorizationFailed
  late TextEditingController textEditingController;

  @override
  void initState() {
    try {
      this.textEditingController = TextEditingController();
      this.messageState = 0;
      this.senderRecordId =
          this.widget.appInstanceParam.loginResponse!.userInfo!.user.recordId;
      this.initSendNewMessage();
    } catch (error) {}
  }

  void initSendNewMessage() {
    try {
      this.textEditingController.clear();
      this.sendNewMessage = VwRowData(recordId: Uuid().v4());
      this.sendNewMessage.collectionName = "messagemessengerformdefinition";
      this.sendNewMessage.timestamp = VwDateUtil.nowTimestamp();
      this.sendNewMessage.creatorUserId =
          this.widget.appInstanceParam.loginResponse?.userInfo?.user.recordId;
      this.sendNewMessage.ownerUserId = this.sendNewMessage.creatorUserId;

      this.sendNewMessage.fields!.add(VwFieldValue(
          valueLinkNode: VwLinkNode(
              nodeId: senderRecordId, nodeType: VwNode.ntnClassEncodedJson),
          fieldName: "sender",
          valueTypeId: VwFieldValue.vatValueLinkNode));
      this.sendNewMessage.fields!.add(VwFieldValue(
          valueLinkNode: VwLinkNode(
              nodeId: widget.recipientRecordId,
              nodeType: VwNode.ntnClassEncodedJson),
          fieldName: "recipient",
          valueTypeId: VwFieldValue.vatValueLinkNode));
      this.sendNewMessage.fields!.add(VwFieldValue(
          fieldName: "message", valueTypeId: VwFieldValue.vatString));
      this.sendNewMessage.fields!.add(VwFieldValue(
          fieldName: "delivereddatetime",
          valueTypeId: VwFieldValue.vatDateTime));
      this.sendNewMessage.fields!.add(VwFieldValue(
          fieldName: "readdatetime", valueTypeId: VwFieldValue.vatDateTime));
      this.sendNewMessage.fields!.add(VwFieldValue(
          valueNumber: 0,
          fieldName: "deliverystatus",
          valueTypeId: VwFieldValue.vatNumber));
      this.sendNewMessage.fields!.add(VwFieldValue(
          valueNumber: 1,
          fieldName: "visibilitystatus",
          valueTypeId: VwFieldValue.vatNumber));
      this.sendNewMessage.fields!.add(VwFieldValue(
          fieldName: "attachmentdocument",
          valueTypeId: VwFieldValue.vatFieldFileStorage));
      this.sendNewMessage.fields!.add(VwFieldValue(
          fieldName: "attachmentphotovideo",
          valueTypeId: VwFieldValue.vatFieldFileStorage));

      for (int la = 0; la < this.sendNewMessage.fields!.length; la++) {
        VwFieldValue currentFieldValue =
            this.sendNewMessage.fields!.elementAt(la);

        if (currentFieldValue.valueFormResponse != null) {
          currentFieldValue.valueFormResponse!.formDefinitionLinkNode = null;
          currentFieldValue.valueFormResponse!.cmReadFormDefinitionLinkNode =
              null;
          currentFieldValue.valueFormResponse!.attachments = [];
        }
      }
    } catch (error) {
      print("Error catched on initSendNewMessage: " + error.toString());
    }
  }

  Future<void> _asyncSaveFormResponse() async {
    try {
      String? loginSessionId =
          this.widget.appInstanceParam.loginResponse?.loginSessionId;

      if (true && loginSessionId != null) {
        SyncTokenBlock? syncTokenBlock = await VwNodeStoreOnHive.getToken(
           // graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
          baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
            loginSessionId: loginSessionId, count: 1, apiCallId: "getToken");

        if (syncTokenBlock != null) {
          List<VwFileStorage> uploadFileStorageList = [];

          /*
          String formResponseInString = json.encode(widget.formResponse);
          VwRowData submitFormResponse =
              VwRowData.fromJson(json.decode(formResponseInString));

          VwRowDataUtil.cleanFieldValueRenderedFormResponseList(
              submitFormResponse);

           */
          this.sendNewMessage.getFieldByName!("message")!.valueString =
              this.textEditingController.text;
          FormUtil.extractVwFileStorage(
              this.sendNewMessage, uploadFileStorageList);

          this.sendNewMessage.crudMode = VwBaseModel.cmCreate;

          VwNode formResponseNode = NodeUtil.generateNodeRowData(
              rowData: this.sendNewMessage,
              upsyncToken: syncTokenBlock.tokenList.elementAt(0),
              parentNodeId: "messagemessengerformdefinition",
              ownerUserId: this.senderRecordId);

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
                //graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress ,
                baseUrl: this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl,
                  apiCallId: "syncNodeContent",
                  apiCallParam: apiCallParam,
                  loginSessionId: loginSessionId);

          if (nodeUpsyncResultPackage.nodeUpsyncResultList.length > 0) {
            VwNodeUpsyncResult nodeUpsyncResult =
                nodeUpsyncResultPackage.nodeUpsyncResultList.elementAt(0);

            if (nodeUpsyncResult.formValidationResponse != null) {
              this.formValidationResponse =
                  nodeUpsyncResult.formValidationResponse!;
            }

            if (nodeUpsyncResult.syncResult.createdCount == 1 ||
                nodeUpsyncResult.syncResult.updatedCount == 1) {
              this.messageState = 0;
              this.initSendNewMessage();

              if (widget.syncNodeToParentFunction != null) {
                this.widget.syncNodeToParentFunction!(formResponseNode);
              }
              if (this.widget.refreshDataOnParentFunction != null) {
                this.widget.refreshDataOnParentFunction!();
              }
              setState(() {});
            } else {
              this.messageState = 1;
              setState(() {});
            }
          }
        } else {
          this.messageState = 2;
          setState(() {});
        }
      } else {
        this.messageState = 2;
        setState(() {});
      }
    } catch (error) {
      print("Error catched on VwFormResponseUserPage._asyncSaveFormParam(): " +
          error.toString());
    }
  }

  Widget getSendButton() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Icon(
          Icons.circle,
          color: Colors.blue,
          size: 48,
        ),
        Icon(
          size: 18,
          Icons.send,
          color: Colors.black
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        height: 60,
        child: Row(
          children: [
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    margin: EdgeInsets.fromLTRB(8, 10, 5, 10),
                    padding: EdgeInsets.fromLTRB(13, 0, 5, 5),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      controller: this.textEditingController,
                    ))),
            this.messageState == 1 || this.messageState == 2
                ? Icon(
                    Icons.error_outline,
                    color: Colors.yellow,
                  )
                : Container(),
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                constraints: BoxConstraints(maxWidth: 100),
                child: InkWell(
                    onTap: () async {
                      if (this.textEditingController.text.isNotEmpty) {
                        await this._asyncSaveFormResponse();
                      }
                    },
                    child: this.getSendButton()))
          ],
        ));
  }
}
