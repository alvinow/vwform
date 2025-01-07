import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfieldfilestorage/vwfieldfilestorage.dart';
import 'package:matrixclient/modules/base/vwencodedfile/vwencodedfile.dart';
import 'package:matrixclient/modules/base/vwfilestorage/modules/vwfileinfo/vwfileinfo.dart';
import 'package:matrixclient/modules/base/vwfilestorage/modules/vwfilesource/vwfilesource.dart';
import 'package:matrixclient/modules/base/vwfilestorage/modules/vwimagefileinfo/vwimagefileinfo.dart';
import 'package:matrixclient/modules/base/vwfilestorage/vwfilestorage.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/util/cryptoutil.dart';
import 'package:matrixclient/modules/util/deviceinfoutil.dart';
import 'package:matrixclient/modules/util/formutil.dart';
import 'package:matrixclient/modules/util/imageutil.dart';
import 'package:matrixclient/modules/util/ioutil.dart';
import 'package:matrixclient/modules/util/networkutil.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/util/vwdateutil.dart';
import 'package:matrixclient/modules/vwfileviewer/vwfileviewer.dart';
import 'package:matrixclient/modules/vwform/vwfieldwidget/vwfieldwidget.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';

import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwwidget/vwcircularprogressindicator/vwcircularprogressindicator.dart';

import 'package:path/path.dart' as pa;
import 'package:matrixclient/modules/vwmultimediaviewer/vwmultimediainstanceparam/vwmultimediaviewerinstanceparam.dart';
import 'package:matrixclient/modules/vwmultimediaviewer/vwmultimediaviewer.dart';
import 'package:matrixclient/modules/vwmultimediaviewer/vwmultimediaviewerparam/vwmultimediaviewerparam.dart';
import 'package:uuid/uuid.dart';

class VwFileFieldWidget extends StatefulWidget {
  const VwFileFieldWidget(
      {Key? key,
      this.readOnly = false,
      required this.field,
      required this.formField,
      this.onValueChanged,
      required this.appInstanceParam,
      required this.getCurrentFormResponseFunction,
      required this.getCurrentFormDefinitionFunction})
      : super(key: key);

  final VwFieldValue field;
  final bool readOnly;
  final VwFormField formField;
  final VwFieldWidgetChanged? onValueChanged;
  final VwAppInstanceParam appInstanceParam;
  final GetCurrentFormResponseFunction getCurrentFormResponseFunction;
  final GetCurrentFormDefinitionFunction getCurrentFormDefinitionFunction;

  _VwFileFieldWidget createState() => _VwFileFieldWidget();
}

class _VwFileFieldWidget extends State<VwFileFieldWidget> {
  late bool applyReadOnly;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.widget.field.valueTypeId = VwFieldValue.vatFieldFileStorage;



       this.applyReadOnly = this.widget.readOnly;

        if(applyReadOnly==false) {


          /*
          applyReadOnly=  this.widget.getCurrentFormResponseFunction().creatorUserId ==
              this.widget.appInstanceParam.loginResponse!.userInfo!.user.recordId
              ? false
              : true;*/
        }


  }

  int getFileCount(){
    int returnValue=0;
    try
        {
          returnValue= widget.field.valueFieldFileStorage!.uploadFile!.length!    ;
        }
        catch(error)
    {

    }
    return returnValue;
  }

  Widget buildBlankUploadFileWidget(BuildContext context) {
    Widget buttonUpload = TextButton.icon(
        style: OutlinedButton.styleFrom(

          side: BorderSide(color: Colors.blue, width: 2), //<-- SEE HERE
        ),
        onPressed: () async {
          try {
            print("Upload File");

            // show the loading dialog

            // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
            if(this.getFileCount()<this.widget.formField.fieldUiParam.maxFileCount) {
              FilePickerResult? myFile = await FilePicker.platform.pickFiles(

                  type: FileType.custom,
                  allowedExtensions:
                  this.widget.formField.fieldUiParam.fieldFileExtension !=
                      null &&
                      this
                          .widget
                          .formField
                          .fieldUiParam
                          .fieldFileExtension!
                          .length >
                          0
                      ? this.widget.formField.fieldUiParam.fieldFileExtension
                      : ["jpg", "png", "pdf", "jpeg", "pdf", "mp4"]);

              // Close the dialog programmatically
              // We use "mounted" variable to get rid of the "Do not use BuildContexts across async gaps" warning
              //if (!mounted) return;

              double _sizeKbs = 0;
              final int maxSizeKbs = this.widget.formField.fieldUiParam.maxFileSizeInKB;

              bool isFileSizeAccepted = false;
              bool isFileSelected = false;

              if (myFile != null) {
                final size = myFile.files.first.size;
                _sizeKbs = size / 1024;
                isFileSelected = true;
                if (_sizeKbs > maxSizeKbs) {
                  print('size should be less than $maxSizeKbs KB');
                } else {
                  isFileSizeAccepted = true;
                  print('file size accepted');
                  //Upload your file
                }
              }

              if (isFileSizeAccepted) {
                if (kIsWeb == true &&
                    myFile != null &&
                    myFile.files.first.bytes != null) {
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
                                Text('Memproses File...')
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

                  Uint8List fileContent = myFile.files.first.bytes!;
                  String fileName = myFile.files.first.name;

                  int fileSize = fileContent.length;

                  String fileBasename = fileName;
                  String fileDirectoryPath = fileName;

                  if (fileSize > 0) {
                    String fileContentBase64 = base64.encode(fileContent);

                    String? md5hashValue =
                    await CryptoUtil.getMd5Checksum(fileContent);

                    String sha256DigestValueString =
                    CryptoUtil.getSha256Checksum(fileContent);

                    Map<String, dynamic> deviceInfo =
                    await DeviceInfoutil.getDeviceInfo();

                    String devicePlatform = DeviceInfoutil.getDevicePlatform();

                    String deviceId = await DeviceInfoutil.getDeviceId();
                    String ipAddress = "127.0.0.1";

                    try {
                      ipAddress = await NetworkUtil.getIp();
                    } catch (error) {}


                    VwImageFileInfo? imageFileInfo = ImageUtil.getImageFileInfo(
                        fileBasename, fileContent);


                    VwEncodedFile uploadFile = VwEncodedFile(
                        recordId: Uuid().v4(),
                        timestamp: VwDateUtil.nowTimestamp(),
                        fileInfo: VwFileInfo(
                            imageFileInfo: imageFileInfo,
                            fileName: fileBasename,
                            md5HashValue: md5hashValue,
                            sha256HashValue: sha256DigestValueString,
                            fileSize: fileSize,
                            fileEncoding: "utf-8"),
                        fileSource: VwFileSource(
                            deviceIp: ipAddress,
                            platformDeviceId: deviceId,
                            platformDeviceType: devicePlatform,
                            deviceInfo: deviceInfo,
                            path: fileDirectoryPath,
                            pathType: VwFileSource.ptsFileSystem,
                            filename: fileBasename,
                            createdDate: DateTime.now()),
                        isEncrypted: false,
                        fileDataEncodedBase64: fileContentBase64);

                    VwFileStorage uploadFileStorage = VwFileStorage(
                        recordId: Uuid().v4(),
                        timestamp: VwDateUtil.nowTimestamp(),
                        isEncrypted: false,
                        uploaderUserId: "<invalid_user_id>",
                        clientEncodedFile: uploadFile,
                        availableOnClientStorage: true,
                        availableOnClientEncodedFile: true);

                    if (widget.field.valueFieldFileStorage == null) {
                      widget.field.valueFieldFileStorage = VwFieldFileStorage(
                          doSyncFile: true, uploadFile: [], serverFile: []);
                    }

                    if (widget.field.valueFieldFileStorage!.uploadFile ==
                        null) {
                      widget.field.valueFieldFileStorage!.uploadFile = [];
                    }
                    widget.field.valueFieldFileStorage!.uploadFile!
                        .add(uploadFileStorage);
                  }

                  if (!mounted) return;
                  Navigator.of(context).pop();
                  setState(() {});
                } else if (kIsWeb == false &&
                    myFile != null &&
                    myFile.files.single.path != null) {
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
                                Text('Memproses File...')
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
                  //File file = File(myFile.files.single.path!);
                  String filePath = myFile.files.single.path!;

                  String fileBasename = pa.basename(filePath);
                  String fileDirectoryPath = pa.dirname(filePath);

                  Uint8List fileContent =
                  await IoUtil.getContentAsBytes(filePath: filePath);

                  int fileSize = fileContent.length;

                  if (fileSize > 0) {
                    String fileContentBase64 = base64.encode(fileContent);

                    String? md5hashValue =
                    await CryptoUtil.getMd5Checksum(fileContent);

                    String sha256DigestValueString =
                    CryptoUtil.getSha256Checksum(fileContent);

                    Map<String, dynamic> deviceInfo =
                    await DeviceInfoutil.getDeviceInfo();

                    String devicePlatform = DeviceInfoutil.getDevicePlatform();

                    String deviceId = await DeviceInfoutil.getDeviceId();
                    String ipAddress = "127.0.0.1";

                    try {
                      ipAddress = await NetworkUtil.getIp();
                    } catch (error) {}

                    VwImageFileInfo? imageFileInfo = ImageUtil.getImageFileInfo(
                        fileBasename, fileContent);

                    VwEncodedFile uploadFile = VwEncodedFile(
                        recordId: Uuid().v4(),
                        timestamp: VwDateUtil.nowTimestamp(),
                        fileInfo: VwFileInfo(
                            imageFileInfo: imageFileInfo,
                            fileName: fileBasename,
                            md5HashValue: md5hashValue,
                            sha256HashValue: sha256DigestValueString,
                            fileSize: fileSize,
                            fileEncoding: "utf-8"),
                        fileSource: VwFileSource(
                            deviceIp: ipAddress,
                            platformDeviceId: deviceId,
                            platformDeviceType: devicePlatform,
                            deviceInfo: deviceInfo,
                            path: fileDirectoryPath,
                            pathType: VwFileSource.ptsFileSystem,
                            filename: fileBasename,
                            createdDate: DateTime.now()),
                        isEncrypted: false,
                        fileDataEncodedBase64: fileContentBase64);

                    VwFileStorage uploadFileStorage = VwFileStorage(
                        recordId: Uuid().v4(),
                        timestamp: VwDateUtil.nowTimestamp(),
                        isEncrypted: false,
                        uploaderUserId: "<invalid_user_id>",
                        clientEncodedFile: uploadFile,
                        availableOnClientStorage: true,
                        availableOnClientEncodedFile: true);

                    if (widget.field.valueFieldFileStorage == null) {
                      widget.field.valueFieldFileStorage = VwFieldFileStorage(
                          doSyncFile: true, uploadFile: [], serverFile: []);
                    }

                    if (widget.field.valueFieldFileStorage!.uploadFile ==
                        null) {
                      widget.field.valueFieldFileStorage!.uploadFile = [];
                    }
                    widget.field.valueFieldFileStorage!.uploadFile!
                        .add(uploadFileStorage);

                    if (mounted == false) {
                      return;
                    }
                    Navigator.of(context).pop();

                    setState(() {});
                  }
                } else {
                  // User canceled the picker
                }
              }
              else {
                if (isFileSelected && !isFileSizeAccepted) {
                  Fluttertoast.showToast(
                      msg: "Error: Ukuran File Maksimal "+this.widget.formField.fieldUiParam.maxFileSizeInKB.toString()+" KB",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      webBgColor: "linear-gradient(to right, #ff0000, #ff0000)",
                      webPosition: "center",
                      fontSize: 16.0);
                }
              }
            }
            else{
              Fluttertoast.showToast(
                  msg: "Error: Jumlah File maksimal "+this.widget.formField.fieldUiParam.maxFileCount.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  webBgColor: "linear-gradient(to right, #ff0000, #ff0000)",
                  webPosition: "center",
                  fontSize: 16.0);
            }
          } catch (error) {
            print("Error on selectting file");
          }
        },
        icon: Icon(
          Icons.upload_file,
          color: Colors.blue,
          size: 25,
        ),
        label: Text(
          "Unggah File",
          style: TextStyle(color: Colors.blue),
        ));

    return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        //color: Colors.blue,
        child: this.applyReadOnly == true ? Container() : buttonUpload);
  }



  Widget buildUploadFileWidget(
      {required VwFileStorage fileStorage,
      required BuildContext context,
      required int index}) {
    Widget returnValue = TextFormField(
      key: Key(index.toString()),
      maxLines: 1,
      minLines: 1,
      autocorrect: false,
      enableSuggestions: false,
      readOnly: true,
      initialValue: fileStorage.clientEncodedFile!.fileSource.filename,
      //controller: this.getTextEditingController(),
      decoration: InputDecoration(
        fillColor: Colors.grey[10],
        prefixIcon: InkWell(
            onTap: () {
              VwFieldValue? tagListFieldValue = widget.field;
              if (widget.formField.fieldUiParam.fieldFileTagDefinition !=
                      null &&
                  widget.formField.fieldUiParam.fieldFileTagDefinition!
                          .linkNodeListFieldName !=
                      null) {
                String linkNodeListFieldName = widget.formField.fieldUiParam
                    .fieldFileTagDefinition!.linkNodeListFieldName;

                if (widget
                        .getCurrentFormResponseFunction()
                        .getFieldByName(linkNodeListFieldName) !=
                    null) {
                  tagListFieldValue = widget
                      .getCurrentFormResponseFunction()
                      .getFieldByName(linkNodeListFieldName);
                }
              }

              List<VwLinkNode>? tagRefLinkNodeList;
              if (widget.formField.fieldUiParam.fieldFileTagDefinition !=
                      null &&
                  widget.formField.fieldUiParam.fieldFileTagDefinition!
                          .linkNodeListFieldName !=
                      null) {
                String tagLinkNodeListFieldName = widget.formField.fieldUiParam
                    .fieldFileTagDefinition!.linkNodeListFieldName;

                if (widget
                        .getCurrentFormResponseFunction()
                        .getFieldByName(tagLinkNodeListFieldName) !=
                    null) {
                  tagListFieldValue = widget
                      .getCurrentFormResponseFunction()
                      .getFieldByName(tagLinkNodeListFieldName);

                  //String linkNodeListFieldName=linkNodeListFieldName;
                  VwFormDefinition currentFormDefinition =
                      widget.getCurrentFormDefinitionFunction();

                  VwFormField? tagLinkNodeListFormField = FormUtil.getFormField(
                      fieldName: tagLinkNodeListFieldName,
                      formDefinition: currentFormDefinition);

                  if (tagLinkNodeListFormField != null) {
                    if (tagLinkNodeListFormField
                                .fieldUiParam.nodeContainerTagLinkNode !=
                            null &&
                        tagLinkNodeListFormField
                                .fieldUiParam
                                .nodeContainerTagLinkNode!
                                .childrenNodeRendered !=
                            null) {
                      tagRefLinkNodeList =
                          NodeUtil.convertNodeListToLinkNodeList(
                              nodeList: widget
                                  .formField
                                  .fieldUiParam
                                  .nodeContainerTagLinkNode!
                                  .childrenNodeRendered!
                                  .rows);
                    }
                  }
                }
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VwMultimediaViewer(
                        appInstanceParam: this.widget.appInstanceParam,
                        multimediaViewerParam: VwMultimediaViewerParam(
                          readOnly: this.applyReadOnly,
                            refTagLinkNodeList: tagRefLinkNodeList,
                            fieldFileTagDefinition: widget
                                .formField.fieldUiParam.fieldFileTagDefinition),
                        multimediaViewerInstanceParam:
                            VwMultimediaViewerInstanceParam(
                                caption: fileStorage.clientEncodedFile!=null? fileStorage.clientEncodedFile!.fileInfo.fileName :null,
                                tagFieldvalue: tagListFieldValue,
                                remoteSource: [fileStorage],
                                fileSource: [],
                                memorySource: []))),
              );
            },
            child: Stack(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                    child: Icon(Icons.upload_file_rounded,
                        color: Colors.blue, size: 25))
              ],
            )),
        suffixIcon: InkWell(
            onTap: () async {
              String oldFieldValueInString = json.encode(widget.field.toJson());

              VwFieldValue oldFieldValue =
                  VwFieldValue.fromJson(json.decode(oldFieldValueInString));

              VwFieldValue? tagListFieldValue = widget.field;
              if (widget.formField.fieldUiParam.fieldFileTagDefinition !=
                      null &&
                  widget.formField.fieldUiParam.fieldFileTagDefinition!
                          .linkNodeListFieldName !=
                      null) {
                String linkNodeListFieldName = widget.formField.fieldUiParam
                    .fieldFileTagDefinition!.linkNodeListFieldName;

                if (widget
                        .getCurrentFormResponseFunction()
                        .getFieldByName(linkNodeListFieldName) !=
                    null) {
                  tagListFieldValue = widget
                      .getCurrentFormResponseFunction()
                      .getFieldByName(linkNodeListFieldName);
                }
              }

              VwFileStorage currentFileStorage = widget
                  .field.valueFieldFileStorage!.uploadFile!
                  .elementAt(index);

              if (tagListFieldValue != null &&
                  tagListFieldValue!.valueLinkNodeList != null) {
                NodeUtil.deletePageTagRecordByFile(
                    fileStorageId: currentFileStorage.recordId,
                    rowDataList: tagListFieldValue!.valueRowDataList!);
              }

              widget.field.valueFieldFileStorage!.uploadFile!.removeAt(index);

              if (this.widget.onValueChanged != null) {
                widget.onValueChanged!(widget.field, oldFieldValue, true);
              } else {
                setState(() {});
              }
            },
            child: Icon(Icons.delete, color: Colors.red, size: 25)),
        filled: true,
        border: const UnderlineInputBorder(),
        labelStyle: const TextStyle(color: Colors.black38, fontSize: 16),
        contentPadding: EdgeInsets.zero,
        labelText: "nama file",
        focusColor: Colors.orange,
        isDense: true,
      ),
    );

    return returnValue;
  }

  Widget buildServerFileWidget(
      {required VwFileStorage fileStorage,
      required BuildContext context,
      required int index}) {
    Widget returnValue = TextFormField(
      key: Key(Uuid().v4()),
      maxLines: 1,
      minLines: 1,
      autocorrect: false,
      enableSuggestions: false,
      readOnly: true,
      initialValue: fileStorage.clientEncodedFile!.fileSource.filename,
      //controller: this.getTextEditingController(),
      decoration: InputDecoration(
        fillColor: Colors.grey[10],
        prefixIcon: InkWell(
            onTap: () {
              VwFieldValue? tagListFieldValue = widget.field;
              if (widget.formField.fieldUiParam.fieldFileTagDefinition !=
                      null &&
                  widget.formField.fieldUiParam.fieldFileTagDefinition!
                          .linkNodeListFieldName !=
                      null) {
                String linkNodeListFieldName = widget.formField.fieldUiParam
                    .fieldFileTagDefinition!.linkNodeListFieldName;

                if (widget
                        .getCurrentFormResponseFunction()
                        .getFieldByName(linkNodeListFieldName) !=
                    null) {
                  tagListFieldValue = widget
                      .getCurrentFormResponseFunction()
                      .getFieldByName(linkNodeListFieldName);
                }
              }

              if (this.widget.formField.fieldUiParam.fieldFileTagDefinition !=
                  null) {
                this
                    .widget
                    .formField
                    .fieldUiParam
                    .fieldFileTagDefinition!
                    .linkNodeListFieldName;
              }

              List<VwLinkNode>? tagRefLinkNodeList;
              if (widget.formField.fieldUiParam.fieldFileTagDefinition !=
                      null &&
                  widget.formField.fieldUiParam.fieldFileTagDefinition!
                          .linkNodeListFieldName !=
                      null) {
                String tagLinkNodeListFieldName = widget.formField.fieldUiParam
                    .fieldFileTagDefinition!.linkNodeListFieldName;

                if (widget
                        .getCurrentFormResponseFunction()
                        .getFieldByName(tagLinkNodeListFieldName) !=
                    null) {
                  tagListFieldValue = widget
                      .getCurrentFormResponseFunction()
                      .getFieldByName(tagLinkNodeListFieldName);

                  //String linkNodeListFieldName=linkNodeListFieldName;
                  VwFormDefinition currentFormDefinition =
                      widget.getCurrentFormDefinitionFunction();

                  VwFormField? tagLinkNodeListFormField = FormUtil.getFormField(
                      fieldName: tagLinkNodeListFieldName,
                      formDefinition: currentFormDefinition);

                  if (tagLinkNodeListFormField != null) {
                    if (tagLinkNodeListFormField
                                .fieldUiParam.nodeContainerTagLinkNode !=
                            null &&
                        tagLinkNodeListFormField
                                .fieldUiParam
                                .nodeContainerTagLinkNode!
                                .childrenNodeRendered !=
                            null) {
                      tagRefLinkNodeList =
                          NodeUtil.convertNodeListToLinkNodeList(
                              nodeList: widget
                                  .formField
                                  .fieldUiParam
                                  .nodeContainerTagLinkNode!
                                  .childrenNodeRendered!
                                  .rows);
                    }
                  }
                }
              }



              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VwMultimediaViewer(
                        appInstanceParam: this.widget.appInstanceParam,
                        multimediaViewerParam: VwMultimediaViewerParam(
                            readOnly: this.applyReadOnly,
                            refTagLinkNodeList: tagRefLinkNodeList,
                            fieldFileTagDefinition: this
                                .widget
                                .formField
                                .fieldUiParam
                                .fieldFileTagDefinition),
                        multimediaViewerInstanceParam:
                            VwMultimediaViewerInstanceParam(
                              caption: fileStorage.clientEncodedFile!=null? fileStorage.clientEncodedFile!.fileInfo.fileName :null,
                                tagFieldvalue: tagListFieldValue,
                                remoteSource: [fileStorage],
                                fileSource: [],
                                memorySource: []))),
              );
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Stack(
                  children: [
                    Icon(Icons.image_outlined, color: Colors.blue, size: 25),
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 12, 0, 0),
                        child: Icon(Icons.cloud_download,
                            color: Colors.blue, size: 17))
                  ],
                ))),
        suffixIcon: this.applyReadOnly == true
            ? null
            : InkWell(
                onTap: () async {
                  widget.field.valueFieldFileStorage!.serverFile!
                      .removeAt(index);

                  VwFieldValue? tagListFieldValue = widget.field;
                  if (widget.formField.fieldUiParam.fieldFileTagDefinition !=
                          null &&
                      widget.formField.fieldUiParam.fieldFileTagDefinition!
                              .linkNodeListFieldName !=
                          null) {
                    String tagLinkNodeListFieldName = widget
                        .formField
                        .fieldUiParam
                        .fieldFileTagDefinition!
                        .linkNodeListFieldName;

                    if (widget
                            .getCurrentFormResponseFunction()
                            .getFieldByName(tagLinkNodeListFieldName) !=
                        null) {
                      tagListFieldValue = widget
                          .getCurrentFormResponseFunction()
                          .getFieldByName(tagLinkNodeListFieldName);

                      //String linkNodeListFieldName=linkNodeListFieldName;
                      VwFormDefinition currentFormDefinition =
                          widget.getCurrentFormDefinitionFunction();

                      VwFormField? tagLinkNodeListFormField =
                          FormUtil.getFormField(
                              fieldName: tagLinkNodeListFieldName,
                              formDefinition: currentFormDefinition);

                      if (tagLinkNodeListFormField != null) {}
                    }
                  }

                  if (tagListFieldValue != null &&
                      tagListFieldValue!.valueLinkNodeList != null) {
                    NodeUtil.deletePageTagRecordByFile(
                        fileStorageId: fileStorage.recordId,
                        rowDataList: tagListFieldValue!.valueRowDataList!);
                  }

                  setState(() {});
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 25,
                )),
        filled: true,
        border: const UnderlineInputBorder(),
        labelStyle: const TextStyle(color: Colors.black38, fontSize: 16),
        contentPadding: EdgeInsets.zero,
        labelText: "nama file",
        focusColor: Colors.orange,
        isDense: true,
      ),
    );

    return returnValue;
  }



  @override
  Widget build(BuildContext context) {
    Widget returnValue = Container();



    List<Widget> uploadFiles = [];
    List<Widget> serverFiles = [];

    if (widget.field.valueFieldFileStorage != null &&
        widget.field.valueFieldFileStorage!.uploadFile != null) {
      for (int la = 0;
          la < widget.field.valueFieldFileStorage!.uploadFile!.length;
          la++) {
        VwFileStorage currentElement =
            this.widget.field.valueFieldFileStorage!.uploadFile!.elementAt(la);

        uploadFiles.add(buildUploadFileWidget(
            fileStorage: currentElement, context: context, index: la));
      }
    }

    if (widget.field.valueFieldFileStorage != null &&
        widget.field.valueFieldFileStorage!.serverFile != null) {
      for (int la = 0;
          la < this.widget.field.valueFieldFileStorage!.serverFile!.length;
          la++) {
        VwFileStorage currentElement =
            this.widget.field.valueFieldFileStorage!.serverFile!.elementAt(la);

        serverFiles.add(this.buildServerFileWidget(
            fileStorage: currentElement, context: context, index: la));
      }
    }

    if (this.applyReadOnly == false) {
      uploadFiles.add(buildBlankUploadFileWidget(context));
    }

    Widget uploadFileWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: uploadFiles);

    Widget serverFileWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: serverFiles);

    Widget caption = VwFieldWidget.getLabel(widget.field, this.widget.formField,
        DefaultTextStyle.of(context).style, this.applyReadOnly);

    returnValue = Container(
        key: Key(widget.getCurrentFormResponseFunction().recordId +
            widget.field.fieldName),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          caption,
          serverFileWidget,
          uploadFileWidget,
        ]));

    return returnValue;
  }
}
