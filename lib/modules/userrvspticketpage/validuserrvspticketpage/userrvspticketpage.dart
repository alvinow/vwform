import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io' as FileIo;
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwbasemodel/vwbasemodel.dart';
import 'package:matrixclient2base/modules/base/vwclassencodedjson/vwclassencodedjson.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwfilestorage/vwfilestorage.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformvalidationresponse.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediainstanceparam/vwmultimediaviewerinstanceparam.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediaviewer.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediaviewerparam/vwmultimediaviewerparam.dart';
import 'package:vwform/modules/vwnodeupsyncresult/vwnodeupsyncresult.dart';
import 'package:vwform/modules/vwnodeupsyncresultpackage/vwnodeupsyncresultpackage.dart';
import 'package:vwform/modules/vwwidget/vwcircularprogressindicator/vwcircularprogressindicator.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';
import 'package:vwutil/modules/util/vwrowdatautil.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class UserRvspTicketPage extends StatefulWidget {
  UserRvspTicketPage(
      {required this.ticketCode,
      this.ticketNode,
      required this.appInstanceParam});

  String ticketCode;
  VwNode? ticketNode;
  VwAppInstanceParam appInstanceParam;

  UserRvspTicketPageState createState() => UserRvspTicketPageState();
}

class UserRvspTicketPageState extends State<UserRvspTicketPage> {
  //WidgetsToImageController controller = WidgetsToImageController();

  String? toastMessage;
  Color? toastBgColor;
  String? title;
  String? data;
  String? nameContactticket;
  String? circleContactTicket;
  String? addressLine1;
  String? addressLine2;

  VwRowData? currentFormResponse;

  VwFormValidationResponse? formValidationResponse;
  bool? isSyncSuccessfull;

  Uint8List? finalTicketJpg;
  String? outputFileName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toastBgColor = Colors.green;

    if (widget.ticketNode != null &&
        widget.ticketNode!.content.rowData != null) {
      try {
        currentFormResponse = widget.ticketNode!.content.rowData!;
        VwRowData ticketshowevent = widget.ticketNode!.content.rowData!;

        VwFieldValue? contactticketFieldValue =
            ticketshowevent.getFieldByName("contactticket");

        VwFieldValue? ticketcodeFieldValue =
            ticketshowevent.getFieldByName("ticketCode");

        nameContactticket = NodeUtil.getFieldValueFromLinkNodeRowData(
                fieldName: "name",
                linkNode: contactticketFieldValue!.valueLinkNode!)!
            .valueString!;

        try {
          circleContactTicket = NodeUtil.getFieldValueFromLinkNodeRowData(
                  fieldName: "circle",
                  linkNode: contactticketFieldValue!.valueLinkNode!)!
              .valueString;
        } catch (error) {}

        try {
          addressLine1 = NodeUtil.getFieldValueFromLinkNodeRowData(
                  fieldName: "addressline1",
                  linkNode: contactticketFieldValue!.valueLinkNode!)!
              .valueString;
        } catch (error) {}

        try {
          addressLine2 = NodeUtil.getFieldValueFromLinkNodeRowData(
                  fieldName: "addressline2",
                  linkNode: contactticketFieldValue!.valueLinkNode!)!
              .valueString;
        } catch (error) {}

        outputFileName = "ticket_" +
            this.nameContactticket.toString() +
            "_" +
            this.widget.ticketCode;

        title = nameContactticket.toString();

        data = this.widget.appInstanceParam.baseAppConfig.generalConfig.baseUrl +
            "/?ticketCode=" +
            ticketcodeFieldValue!.valueString!;
      } catch (error) {}
    }
  }

  Future<void> _syncFormResponse() async {
    try {
      if (true) {
        if (currentFormResponse!.timestamp != null) {
          currentFormResponse!.timestamp!.updated = DateTime.now();
        }

        //currentFormResponse.creatorUserLinkNode.cache = this.widget.loginResponse.userInfo?.user;

        if (currentFormResponse!.creatorUserId == null) {
          currentFormResponse!.creatorUserId = this
              .widget
              .appInstanceParam
              .loginResponse!
              .userInfo
              ?.user
              .recordId;
        }

        List<VwFileStorage> uploadFileStorageList = [];

        String formResponseInString = json.encode(this.currentFormResponse);
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

        submitFormResponse.crudMode = VwBaseModel.cmUpdate;

        VwNode? currentFormResponseNode = NodeUtil.getNode(
            linkNode: this.currentFormResponse!.formDefinitionLinkNode!);

        VwClassEncodedJson? formDefinitionClassEncodedJson =
            NodeUtil.extractClassEncodedJsonFromContent(
                nodeContent: currentFormResponseNode!.content);

        RemoteApi.decompressClassEncodedJson(formDefinitionClassEncodedJson!);

        VwFormDefinition formDefinition =
            VwFormDefinition.fromJson(formDefinitionClassEncodedJson!.data!);

        VwNode formResponseNode = NodeUtil.generateNodeRowData(
            rowData: submitFormResponse,
            upsyncToken: this.widget.ticketCode,
            parentNodeId: "response_" + formDefinition.recordId,
            ownerUserId: "<invalid_owner_user_id>");

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
              graphqlServerAddress: this.widget.appInstanceParam.baseAppConfig.generalConfig.graphqlServerAddress,
                apiCallId: "syncNodeContent",
                apiCallParam: apiCallParam,
                loginSessionId: this.widget.ticketCode);

        if (nodeUpsyncResultPackage.nodeUpsyncResultList.length > 0) {
          VwNodeUpsyncResult nodeUpsyncResult =
              nodeUpsyncResultPackage.nodeUpsyncResultList.elementAt(0);

          if (nodeUpsyncResult.formValidationResponse != null) {
            this.formValidationResponse =
                nodeUpsyncResult.formValidationResponse!;
          }

          if (nodeUpsyncResult.syncResult.createdCount == 1 ||
              nodeUpsyncResult.syncResult.updatedCount == 1) {
            isSyncSuccessfull = true;
          } else {
            this.toastBgColor = Colors.red;
            this.toastMessage =
                "Error saving current Record, errorMessage: " +
                    nodeUpsyncResult.syncResult.errorMessage.toString();
          }
        }
      } else {
        this.toastBgColor = Colors.red;
        this.toastMessage =
            "Error: Konfirmasi  gagal disinkronisasi dengan server.\n Autorisasi tidak berhasil.";
      }

      if (isSyncSuccessfull == true) {
        this.toastMessage = "Current Record successfully saved to server.";
        this.toastBgColor = Colors.green;

        Fluttertoast.showToast(
            msg: toastMessage.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: this.toastBgColor,
            textColor: Colors.white,
            webBgColor: "linear-gradient(to right, #5dbb63, #5dbb63)",
            webPosition: "center",
            fontSize: 16.0);
      }
    } catch (error) {
      print("error catched on syncFormResponse=" + error.toString());
    }
  }

  Widget RsvpResult() {
    VwFieldValue? rsvpStatus =
        this.widget.ticketNode!.content.rowData!.getFieldByName("RSVPStatus");

    if (rsvpStatus == null) {
      rsvpStatus = VwFieldValue(fieldName: "RSVPStatus");
      this.widget.ticketNode!.content.rowData!.fields!.add(rsvpStatus);
    }

    bool hasDecision = rsvpStatus != null && rsvpStatus!.valueString != null;

    bool isAccepted =
        hasDecision == true && rsvpStatus!.valueString == "accept";

    Widget datangButton = FloatingActionButton.extended(
        label: Text(
          'Datang',
          style: TextStyle(color: Colors.black),
        ), // <-- Text
        backgroundColor: hasDecision == true && isAccepted == true
            ? Colors.lightBlueAccent
            : Colors.white,
        icon: Icon(
          // <-- Icon
          hasDecision == true && isAccepted == true
              ? Icons.check_circle
              : Icons.check_circle_outline,
          size: 24.0,
          color: hasDecision == true && isAccepted == true
              ? Colors.white
              : Colors.black,
        ),
        onPressed: () async {
          rsvpStatus!.valueString = "accept";

          await this._syncFormResponse();

          setState(() {});
        });
    Widget tidakDatangButton = FloatingActionButton.extended(
        label: Text(
          'Maaf, tidak bisa',
          style: TextStyle(color: Colors.black),
        ), // <-- Text
        backgroundColor: hasDecision == true && isAccepted == false
            ? Colors.grey
            : Colors.white,
        icon: Icon(
          // <-- Icon
          hasDecision == true && isAccepted == true
              ? Icons.navigate_next_outlined
              : Icons.navigate_next,
          size: 24.0,
          color: hasDecision == true && isAccepted == false
              ? Colors.black
              : Colors.grey,
        ),
        onPressed: () async {
          rsvpStatus!.valueString = "decline";

          await this._syncFormResponse();
          setState(() {});
        });

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        datangButton,
        SizedBox(
          width: 20,
        ),
        tidakDatangButton
      ],
    );
  }

  Future<Uint8List> toQrImageData(String text) async {
    try {
      final image = await QrPainter(
        data: text,
        version: QrVersions.auto,
        gapless: false,
      ).toImage(300);
      final a = await image.toByteData(format: ImageByteFormat.png);
      return a!.buffer.asUint8List();
    } catch (e) {
      throw e;
    }
  }

  Widget getTicketQrCodeImage(
      {double? size = 100,
      double? fontSize = 16,
      required BuildContext context}) {
    if (this.title != null && this.data != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImageView(
              data: data.toString(), version: QrVersions.auto, size: size),
          /*Text(
            "Silahkan scan QR Code\nSaat memasuki lokasi acara\nTerima kasih untuk kehadirannya",
            style: TextStyle(fontSize: fontSize),
          )*/
        ],
      );
    } else {
      return Container();
    }
  }

  Widget getTicketAddress({double fontSize = 14}) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 190, maxHeight: 190),
        child: Container(
            margin: EdgeInsets.fromLTRB(30, 10, 10, 0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: fontSize, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: "Kepada : ",
                      style:
                          TextStyle(fontSize: fontSize, color: Colors.black)),
                  TextSpan(text: "\n"),
                  TextSpan(text: "\n"),
                  TextSpan(
                      text: this.nameContactticket.toString(),
                      style: TextStyle(
                          fontSize: fontSize + 3.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black)),
                  TextSpan(
                      text: this.addressLine1 != null
                          ? "\n" + this.addressLine1.toString()
                          : null,
                      style:
                          TextStyle(fontSize: fontSize, color: Colors.black)),
                  TextSpan(
                      text: this.addressLine2 != null
                          ? "\n" + this.addressLine2.toString()
                          : null,
                      style:
                          TextStyle(fontSize: fontSize, color: Colors.black)),
                ],
              ),
            )));

    return Container(
        margin: EdgeInsets.fromLTRB(30, 10, 10, 0),
        child: Text(
          "Kepada:\n" +
              this.nameContactticket.toString() +
              "\n" +
              this.circleContactTicket.toString(),
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: fontSize),
        ));
  }

  static String? getUrl({
    required BaseAppConfig baseAppConfig,
    required VwFileStorage fileStorage}) {
    String? returnValue;

    if (fileStorage.availableOnServer == true) {
      if (fileStorage.url != null) {
        returnValue = fileStorage.url;
      } else {
        returnValue = baseAppConfig.generalConfig.baseUrl +
            baseAppConfig.generalConfig.filesUrlPath +
            "/" +
            fileStorage.recordId;
      }
    }

    return returnValue;
  }

  Future<Uint8List?> getBaseTicketImage() async {
    Uint8List? returnValue;
    try {
      VwFieldValue? gateshoweventFieldValue =
          widget.ticketNode!.content.rowData!.getFieldByName!("gateshowevent");

      VwNode? gateshoweventNode =
          NodeUtil.getNode(linkNode: gateshoweventFieldValue!.valueLinkNode!);

      VwFieldValue? showeventFieldValue =
          gateshoweventNode!.content.rowData!.getFieldByName("showevent");

      VwNode? showeventNode =
          NodeUtil.getNode(linkNode: showeventFieldValue!.valueLinkNode!);

      VwFieldValue? contentImageFieldValue =
          showeventNode!.content.rowData!.getFieldByName("contentimage");

      VwFileStorage baseTicketFileStorage = contentImageFieldValue!
          .valueFieldFileStorage!.serverFile!
          .elementAt(0);

      String? url =
          UserRvspTicketPageState.getUrl(
              baseAppConfig: this.widget.appInstanceParam.baseAppConfig,
              fileStorage: baseTicketFileStorage);

      FileIo.File file = await DefaultCacheManager().getSingleFile(url!);
      String fileBase64 = await file.readAsString();

      returnValue = RemoteApi.decryptAes(fileBase64, baseTicketFileStorage);
    } catch (error) {}

    return returnValue;
  }

  Widget getTicketImage(
      {double? overrideContainerHeight,
      Orientation? overrideOrientation = Orientation.portrait}) {
    Widget returnValue = Container();
    try {
      VwFieldValue? gateshoweventFieldValue =
          widget.ticketNode!.content.rowData!.getFieldByName!("gateshowevent");

      VwNode? gateshoweventNode =
          NodeUtil.getNode(linkNode: gateshoweventFieldValue!.valueLinkNode!);

      VwFieldValue? showeventFieldValue =
          gateshoweventNode!.content.rowData!.getFieldByName("showevent");

      VwNode? showeventNode =
          NodeUtil.getNode(linkNode: showeventFieldValue!.valueLinkNode!);

      VwFieldValue? contentImageFieldValue =
          showeventNode!.content.rowData!.getFieldByName("contentimage");

      Size screenSize = MediaQuery.of(context).size;
      Orientation orientation = MediaQuery.of(context).orientation;

      if (overrideOrientation != null) {
        orientation = overrideOrientation;
      }

      if (orientation == Orientation.landscape) {
        double frameHeight = screenSize.longestSide * 2;

        if (overrideContainerHeight != null) {
          frameHeight = overrideContainerHeight;
        }

        return SizedBox(
            height: frameHeight,
            child: VwMultimediaViewer(
                usedAsWidgetComponent: true,
                appInstanceParam: this.widget.appInstanceParam,
                multimediaViewerParam: VwMultimediaViewerParam(),
                multimediaViewerInstanceParam: VwMultimediaViewerInstanceParam(
                    remoteSource: contentImageFieldValue!
                        .valueFieldFileStorage!.serverFile!,
                    fileSource: [],
                    memorySource: [])));
      } else {
        double frameHeight = screenSize.shortestSide * 2;
        if (overrideContainerHeight != null) {
          frameHeight = overrideContainerHeight;
        }
        return SizedBox(
            height: frameHeight,
            child: VwMultimediaViewer(
                usedAsWidgetComponent: true,
                appInstanceParam: this.widget.appInstanceParam,
                multimediaViewerParam: VwMultimediaViewerParam(),
                multimediaViewerInstanceParam: VwMultimediaViewerInstanceParam(
                    remoteSource: contentImageFieldValue!
                        .valueFieldFileStorage!.serverFile!,
                    fileSource: [],
                    memorySource: [])));
      }
    } catch (error) {
      print("Error catched on getTicketImage()=" + error.toString());
    }
    return returnValue;
  }

  Future<Uint8List?> initializeUserTicket() async {
    Uint8List? returnValue;
    try {
      int qrPosX = 650;
      int qrPosY = 30;
      int qrSize = 280;
      int lineSpacing = 40;
      int tab = 40;
      int textPosX = 40;
      int textPosY = 40;
      int ticketImageWidth = 960;

      if (this.finalTicketJpg == null) {
        Uint8List qrMemory = await toQrImageData(this.data!);
        Uint8List? baseTicketMemory = await this.getBaseTicketImage();
        if (qrMemory != null && baseTicketMemory != null) {
          img.Image? qrImage = img.decodePng(qrMemory);

          img.Image qrImage100 = img.copyResize(
            qrImage!,
            width: qrSize,
          );

          img.Image? baseTicketImage = img.decodeJpg(baseTicketMemory!);

          baseTicketImage = img.copyResize(
            baseTicketImage!,
            width: ticketImageWidth,
          );

          //dstX: 255, dstY: 1165
          img.Image finalTicketImage = img.compositeImage(
              baseTicketImage!, qrImage100!,
              dstX: qrPosX, dstY: qrPosY);

          final ByteData fontZipBytes =
              await rootBundle.load('assets/fonts/ArialTh.ttf.zip');
          final Uint8List fontZip = fontZipBytes.buffer.asUint8List();

          img.BitmapFont undanganFont = img.BitmapFont.fromZip(fontZip);

          undanganFont.size = 25;
          undanganFont.bold = true;

          img.BitmapFont namaFont = img.BitmapFont.fromZip(fontZip);
          namaFont.size = 18;
          namaFont.bold = true;

          img.Image finalTicketWithName = img.drawString(
            finalTicketImage,
            "UNDANGAN",
            font: undanganFont,
            x: textPosX + tab,
            y: textPosY,
          );

          finalTicketWithName = img.drawString(
            finalTicketWithName,
            "Kepada Yth. :",
            font: img.BitmapFont.fromZip(fontZip),
            x: textPosX + tab,
            y: textPosY + (lineSpacing * 2),
          );

          finalTicketWithName = img.drawString(
            finalTicketWithName,
            this.nameContactticket!,
            font: namaFont,
            x: textPosX + tab + tab,
            y: textPosY + (lineSpacing * 3),
          );

          finalTicketWithName = img.drawString(
            finalTicketWithName,
            "*Undangan ini harap ditunjukkan di meja registrasi",
            font: namaFont,
            x: textPosX + tab ,
            y: textPosY + (lineSpacing * 6),
          );

          this.finalTicketJpg = Uint8List.fromList(
            img.encodeJpg(finalTicketWithName, quality: 90),
          );
        }
      }
      returnValue = this.finalTicketJpg;
    } catch (error) {
      print("Error occured on initializeUserTicket(): " + error.toString());
    }

    return returnValue;
  }

  Widget getEventNameWidget() {
    return Container();


  }

  @override
  Widget build(BuildContext context) {
    if (widget.ticketNode != null) {
      return FutureBuilder<Uint8List?>(
        future: initializeUserTicket(),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasError == true) {
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Terjadi galat ketika memuat data. Cobalah beberapa saat lagi")
                    ],
                  )
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [VwCircularProgressIndicator()],
                  )
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              this.finalTicketJpg != null) {
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.download),
                  onPressed: () async {
                    if (finalTicketJpg != null && outputFileName != null) {

                      await FileSaver.instance.saveFile(
                          name: outputFileName!,
                          bytes: finalTicketJpg,
                          ext: "jpg",
                          mimeType: MimeType.jpeg);
                    }
                  },
                ),
                appBar: AppBar(
                  actions: [
                   InkWell(onTap: () async{
                     final Uri url = Uri.parse('https://www.instagram.com/alphabeta.forpresident/?igshid=MzRlODBiNWFlZA%3D%3D');

                     await launchUrl(url);
                   }, child:Image.asset("assets/icons/instagram.png",width: 20,))  ,
                    SizedBox(width: 10,),
                    InkWell(onTap: () async{
                      final Uri url = Uri.parse('https://www.tiktok.com/@alphabeta.bantuanies');

                      await launchUrl(url);
                    }, child:Image.asset("assets/icons/tik-tok.png",width: 20,)),
                    SizedBox(width: 10,),
                  ],
                    title: Row(children: [

                  this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.centerLogoMode == NodeListView.mlmLogo
                      ? Image.asset(
                    this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
                          scale: 15,
                        )
                      : Container(),
                      this.widget.appInstanceParam.baseAppConfig.baseThemeConfig.centerLogoMode == NodeListView.mlmText
                      ?InkWell(
                      onTap: () async{
                        final Uri url = Uri.parse('https://alumniitb.org');

                        await launchUrl(url);
                      },
                      child: Text(
                        this.widget.appInstanceParam.baseAppConfig.generalConfig.appTitle,
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  ))
                      : Container(),
                ])),
                body: FadeIn(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeInOutBack,
                    child: SingleChildScrollView(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                /*
                                this.getEventNameWidget(),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      this.getTicketAddress(),

                                      Container(margin: EdgeInsets.fromLTRB(0, 0, 10, 0), child:QrImageView (
                                        data: this.data!,
                                        version: QrVersions.auto,
                                        size: 200.0,
                                      ))
                                    ]),
                                SizedBox(
                                  height: 30,
                                ),
*/
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.loose,
                                      // your image goes here which will take as much height as possible.
                                      child: ZoomOverlay(
                                        modalBarrierColor:
                                            Colors.black12, // Optional
                                        minScale: 0.5, // Optional
                                        maxScale: 3.0, // Optional
                                        animationCurve: Curves
                                            .fastOutSlowIn, // Defaults to fastOutSlowIn which mimics IOS instagram behavior
                                        animationDuration: Duration(
                                            milliseconds:
                                                300), // Defaults to 100 Milliseconds. Recommended duration is 300 milliseconds for Curves.fastOutSlowIn
                                        twoTouchOnly: true, // Defaults to false
                                        onScaleStart:
                                            () {}, // optional VoidCallback
                                        onScaleStop:
                                            () {}, // optional VoidCallback
                                        child: Image.memory(
                                            this.finalTicketJpg!,
                                            fit: BoxFit.contain),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Konfirmasi Kehadiran :",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                this.RsvpResult(),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "*Untuk mendukung kelancaran acara, diharapkan mengisi konfirmasi kehadiran",
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                              ],
                            )))));
          } else {
            return Scaffold(
                appBar: AppBar(
                    title: Row(children: [
                  Image.asset(
                    this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
                    scale: 15,
                  ),
                  Text(
                    "Ticketing System",
                    style: TextStyle(fontSize: 18),
                  ),
                ])),
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Error Loading Data From Server"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () async {
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.refresh,
                              )),
                          Text("Reload")
                        ],
                      )
                    ]));
          }
        },
      );
    } else {
      return Scaffold(
          appBar: AppBar(
              title: Row(children: [
            Image.asset(
              this.widget.appInstanceParam.baseAppConfig.generalConfig.mainLogoPath,
              scale: 15,
            ),
            Text(
              "Ticketing System",
              style: TextStyle(fontSize: 18),
            ),
          ])),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Maaf, no tiket tidak valid.",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              )
            ],
          ));
    }

    //return VwFormPage(formResponse: widget.ticketNode.content!.rowData!, formDefinition: formDefinition, appInstanceParam: widget.appInstanceParam, formDefinitionFolderNodeId: "response_"+formDefinition.recordId);
  }
}
