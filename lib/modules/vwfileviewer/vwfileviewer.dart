import 'dart:async';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwfilestorage/vwfilestorage.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_svg/svg.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwaudioplayer/vwaudioplayer.dart';
import 'package:vwform/modules/vwfileviewer/bloc/fileviewer_bloc.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfieldfiletagdefinition/vwfieldfiletagdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefintionutil.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwform/modules/vwvideoplayer/vwvideoplayer.dart';
import 'package:vwform/modules/vwwidget/vwcircularprogressindicator/vwcircularprogressindicator.dart';
import 'package:vwform/modules/youtubeappdemo/youtubeappdemo.dart';
import 'package:vwutil/modules/util/formutil.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwrowdatautil.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';


typedef MediaInfo = void Function(
    String extension, PdfViewerController? pdfViewerController);

typedef GetTagWidget = Widget Function({required int page});

typedef FileViewerPageChanged = void Function(
    PdfPageChangedDetails? pageChangedDetails);

class VwFileViewer extends StatefulWidget {
  VwFileViewer(
      {required this.appInstanceParam,
      required this.fileStorage,
      this.tagFieldValue,
      this.refTagLinkNodeList,
      this.fieldFileTagDefinition,
      this.initPage = 1,
      required super.key,
      this.readOnly=false
      });

  VwFileStorage fileStorage;
  int initPage;
  VwFileViewerState createState() => VwFileViewerState();
  final VwFieldValue? tagFieldValue;
  final List<VwLinkNode>? refTagLinkNodeList;
  final VwFieldFileTagDefinition? fieldFileTagDefinition;
  final VwAppInstanceParam appInstanceParam;
  final bool readOnly;
}

class VwFileViewerState extends State<VwFileViewer> {
  late PdfViewerController _pdfViewerController;
  late PageInfo pageInfo;
  late VwFieldValue currentPageNumber;


  @override
  void initState() {
    super.initState();

    VwLinkNode? activeTagLinkNode;

    this.initRefTagLinkNodeList();

    _pdfViewerController = PdfViewerController();
    currentPageNumber = VwFieldValue(
        fieldName: "pageNumber",
        valueTypeId: VwFieldValue.vatString,
        valueString: "-");

    this.pageInfo = PageInfo(
      fieldValue: this.currentPageNumber,
      getTagWidget: this.getTagWidgetFormResponse,
    );
  }

  void initRefTagLinkNodeList() {
    try {
      VwFormDefinition tagFormDefinition =
          widget.fieldFileTagDefinition!.filePageTagFormDefinition!;

      VwFormField? linkTagNodeFormField = FormUtil.getFormField(
          fieldName: "linkTagNode", formDefinition: tagFormDefinition);

      linkTagNodeFormField!.fieldUiParam.collectionListViewDefinition!
          .staticRefLinkNodeList = widget.refTagLinkNodeList;
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(key:this.widget.key,providers: [
      BlocProvider(
          create: (_) => FileviewerBloc (
              appInstanceParam: this.widget.appInstanceParam,
              key:this.widget.key! , fileStorage: this.widget.fileStorage)
            ..add(BootstrapFileviewerEvent(timestamp: DateTime.now())))
    ], child: _bodyFileViewer(context));
  }

  void _onPdfPageLoaded(PdfDocumentLoadedDetails pdfDocumentLoadedDetails) {
    if (pdfDocumentLoadedDetails != null) {
      currentPageNumber.valueString =
          this._pdfViewerController.pageNumber.toString();

      _pdfViewerController.jumpToPage(this.widget.initPage!);
    }
    ;
  }

  void _onPdfPageChanged(PdfPageChangedDetails? pageChangedDetails) {
    if (pageChangedDetails != null) {
      currentPageNumber.valueString =
          pageChangedDetails.newPageNumber.toString();
    }
    ;
  }



  static void removeLinkNode({required List<VwLinkNode> masterList, required List<VwLinkNode> deletedList })
  {
    try
        {
          List<int> indexDeletedList=[];

                for(int lb=0;lb<deletedList.length;lb++)
                {
                  VwLinkNode currentDeleteListLinkNode=deletedList.elementAt(lb);

                  VwRowData?  currentDeleteRowData=NodeUtil.extractRowDataFromLinkNode(currentDeleteListLinkNode);

                  VwFieldValue? deletedTagLinkNodeFieldValue=currentDeleteRowData!.getFieldByName("linkTagNode");


                  for(int la=0;la<masterList.length;la++) {
                    VwLinkNode currentMasterLinkNode = masterList.elementAt(la);

                    VwRowData? currentMasterRowData = NodeUtil
                        .extractRowDataFromLinkNode(currentMasterLinkNode);

                    VwFieldValue? masterTagLinkNodeFieldValue = currentMasterRowData!
                        .getFieldByName("linkTagNode");

                    if(masterTagLinkNodeFieldValue!=null && masterTagLinkNodeFieldValue!.valueLinkNode!=null   && masterTagLinkNodeFieldValue!.valueLinkNode!.nodeId !=null && masterTagLinkNodeFieldValue!.valueLinkNode!.nodeId ==deletedTagLinkNodeFieldValue!.valueLinkNode!.nodeId)
                    {
                      indexDeletedList.add(la);
                    }
                  }

                }


          indexDeletedList = indexDeletedList.toSet().toList();



          int originalLength=masterList.length;
          for(int la=originalLength;la>0;la--)
            {
              for(int lb=0;lb<indexDeletedList.length;lb++)
                {
                  int currentDeletedIndexValue=indexDeletedList.elementAt(lb);
                  if(currentDeletedIndexValue==la)
                    {
                      masterList.removeAt(la);
                    }

                }
            }

        }
        catch(error)
    {
      print("Error catched on Remove Link Node="+error.toString());
    }
  }


   void setTagNode({required VwFieldValue newTagNode,required VwRowData newFormResponse}){
    try
        {
          VwFieldValue? linkTagNodeFieldValue = newFormResponse.getFieldByName("linkTagNode");


          if(widget.tagFieldValue!.valueRowDataList==null)
            {
              widget.tagFieldValue!.valueRowDataList=[];
            }

          if(linkTagNodeFieldValue!=null && linkTagNodeFieldValue.valueLinkNode!=null )
            {
              List<VwRowData>  duplicateTagLinkNodeList= VwFileViewerState.getRowDataListByTagRecordId(
                rowDataList: widget.tagFieldValue!.valueRowDataList!,
                  tagRecordId: linkTagNodeFieldValue.valueLinkNode!.nodeId
              );

              List<String> deletedRowDataRecordIdList= VwRowDataUtil.getRecordIdListFromRowDataList(rowDataList: duplicateTagLinkNodeList);
              VwRowDataUtil.removeRowDataList(rowDataList: widget.tagFieldValue!.valueRowDataList!, deletedRowDataRecordIdList: deletedRowDataRecordIdList);
              widget.tagFieldValue!.valueRowDataList!.add(newFormResponse);
            }

        }
        catch(error)
    {

    }
  }

  static List<VwRowData> getRowDataListByTagRecordId({required List<VwRowData> rowDataList,required String tagRecordId}){
    List<VwRowData> returnValue=[];
    try{
      for(int la=0;la<rowDataList.length;la++)
        {
          VwRowData currentFormResponse=rowDataList[la];

          VwFieldValue? linkTagNodeFieldValue = currentFormResponse
              .getFieldByName("linkTagNode");

          if(linkTagNodeFieldValue!=null && linkTagNodeFieldValue!.valueLinkNode!=null && linkTagNodeFieldValue.valueLinkNode!.nodeId==tagRecordId)
          {
            returnValue.add(currentFormResponse);
          }
        }
    }
    catch(error){

    }

    return returnValue;
  }

  static List<VwLinkNode> getLinkNodeListByTagRecordId({required VwFieldValue tagFieldValue,required String tagRecordId}) {
    List<VwLinkNode> returnValue = [];
    try {
      if (tagFieldValue.valueLinkNodeList != null &&
          tagFieldValue.valueLinkNodeList!.length > 0) {
        for (int la = 0; la < tagFieldValue.valueLinkNodeList!.length; la++) {

          VwLinkNode? currentLinkNode= tagFieldValue.valueLinkNodeList!.elementAt(la);

          VwRowData? currentFormResponse =NodeUtil.extractRowDataFromLinkNode(currentLinkNode);

          if(currentFormResponse!=null) {
            VwFieldValue? linkTagNodeFieldValue = currentFormResponse!
                .getFieldByName("linkTagNode");

            if(linkTagNodeFieldValue!=null && linkTagNodeFieldValue!.valueLinkNode!=null && linkTagNodeFieldValue.valueLinkNode!.nodeId==tagRecordId)
              {
                returnValue.add(tagFieldValue.valueLinkNodeList!.elementAt(la));
              }
          }

        }
      }



    } catch (error) {}
    return returnValue;
  }

  VwRowData? getFormResponseByFileStorageIdAndPage({required VwFieldValue tagFieldValue,
    required String fileStorageId,
    required int page})
  {
    VwRowData? returnValue;

    try
        {
          if (tagFieldValue.valueRowDataList != null &&
              tagFieldValue.valueRowDataList!.length > 0)
            {
              for(int la=0;la<tagFieldValue.valueRowDataList!.length;la++)
                {
                  VwRowData currentFormResponse=tagFieldValue.valueRowDataList!.elementAt(la);
                  if (currentFormResponse != null) {
                    VwFieldValue? pageFieldValue =
                    currentFormResponse.getFieldByName("page");
                    VwFieldValue? fileStorageIdValue =
                    currentFormResponse.getFieldByName("fileStorageId");
                    if (pageFieldValue != null &&
                        pageFieldValue.valueNumber == page &&
                        fileStorageIdValue != null &&
                        fileStorageIdValue.valueString == fileStorageId) {
                      returnValue = currentFormResponse;
                      break;
                    }
                  }

                }

            }

        }
        catch(error)
    {

    }
    return returnValue;

  }
/*
  VwLinkNode? getLinkNodeByFileStorageIdAndPage(
      {required VwFieldValue tagFieldValue,
      required String fileStorageId,
      required int page}) {
    VwLinkNode? returnValue;

    try {
      if (tagFieldValue.valueLinkNodeList != null &&
          tagFieldValue.valueLinkNodeList!.length > 0) {
        for (int la = 0; la < tagFieldValue.valueLinkNodeList!.length; la++) {
          VwLinkNode currentLinkNode =
              tagFieldValue.valueLinkNodeList!.elementAt(la);

          VwRowData? currentFormResponse =
              NodeUtil.extractRowDataFromLinkNode(currentLinkNode);
          if (currentFormResponse != null) {
            VwFieldValue? pageFieldValue =
                currentFormResponse.getFieldByName("page");
            VwFieldValue? fileStorageIdValue =
                currentFormResponse.getFieldByName("fileStorageId");
            if (pageFieldValue != null &&
                pageFieldValue.valueNumber == page &&
                fileStorageIdValue != null &&
                fileStorageIdValue.valueString == fileStorageId) {
              returnValue = currentLinkNode;
              break;
            }
          }
        }
      }
    } catch (error) {
      print("Error catched on VwFileViewer.getLinkNodeByFileStorageIdAndPage=" +
          error.toString());
    }
    return returnValue;
  }
  */



  Widget getTagWidgetFormResponse({required int page}) {
    Widget returnValue = Container();

    if (widget.fieldFileTagDefinition != null && widget.tagFieldValue != null) {
      VwRowData? currentFilePageTagFormResponse;

      if (widget.tagFieldValue!.valueRowDataList == null) {
        widget.tagFieldValue!.valueRowDataList = [];
      }

      if (
          widget.tagFieldValue!.valueRowDataList!.length > 0) {
        currentFilePageTagFormResponse = this.getFormResponseByFileStorageIdAndPage(
            tagFieldValue: widget.tagFieldValue!,
            fileStorageId: widget.fileStorage.recordId,
            page: page);
      }

      //VwRowData? initFormResponse;

      if (currentFilePageTagFormResponse == null) {
        VwRowData newFormResponse =
            VwFormDefinitionUtil.createBlankRowDataFromFormDefinition(
                formDefinition:
                    widget.fieldFileTagDefinition!.filePageTagFormDefinition,
                ownerUserId: widget
                    .appInstanceParam.loginResponse!.userInfo!.user.recordId);
        newFormResponse.getFieldByName("fileStorageId")!.valueString =
            this.widget.fileStorage.recordId;
        newFormResponse.getFieldByName("page")!.valueNumber =
            double.parse(page.toString());


        widget.tagFieldValue!.valueRowDataList!
            .add(newFormResponse);
        currentFilePageTagFormResponse=newFormResponse;
      }

      VwFormField? linkTagNodeFieldValue = FormUtil.getFormField(
          fieldName: "linkTagNode",
          formDefinition:
              widget.fieldFileTagDefinition!.filePageTagFormDefinition);

      if (linkTagNodeFieldValue != null) {
        linkTagNodeFieldValue!.fieldUiParam!.caption =
            "Tag - Halaman " + page.toString();
      }

      VwRowData? initFormResponses =
          currentFilePageTagFormResponse;

      widget.fieldFileTagDefinition!.filePageTagFormDefinition.isReadOnly=this.widget.readOnly;

      if (initFormResponses != null) {
        returnValue = VwForm(
            key:UniqueKey(),

            appInstanceParam: this.widget.appInstanceParam,
            initFormResponse: initFormResponses,
            onFormValueChanged: implementOnValueChanged,
            formDefinition:
                widget.fieldFileTagDefinition!.filePageTagFormDefinition);
      }
    }

    return returnValue;
  }

  void implementOnValueChanged(VwFieldValue newValue , VwFieldValue oldValue, VwRowData  formResponse, bool doSetState){
    try
        {
          this.setTagNode(newTagNode: newValue, newFormResponse: formResponse);
        }
        catch(error)
    {

    }

  }

  Widget _bodyFileViewer(BuildContext context) {
    return BlocBuilder<FileviewerBloc, FileviewerState>(
        builder: (context, state) {
      FileviewerBloc bloc = context.read<FileviewerBloc>();
      if (state is LoadingFileviewerState) {
        return Center(child: VwCircularProgressIndicator());

      }
      else if(state is DisplayContentInYoutubeVideoIdFileviewerState){


        return YoutubeAppDemo(appInstanceParam: this.widget.appInstanceParam, videoIds: state.videoIds);
      }
      else if (state is DisplayContentInFileFileviewerState) {
        final String? extension = p
            .extension(state.fileStorage.clientEncodedFile!.fileInfo.fileName)
            .toLowerCase(); // '.dart'

        if (extension != null) {
          if (extension == ".pdf") {
            SfPdfViewer sfPdfViewer = SfPdfViewer.file(
              key: this.widget.key,
              scrollDirection:PdfScrollDirection.vertical,
              state.fileLink,
              onDocumentLoaded: this._onPdfPageLoaded,
              onPageChanged: this._onPdfPageChanged,
              enableDoubleTapZooming: false,
              controller: this._pdfViewerController,
            );

            return Scaffold(
                body: Column(
                    children: [this.pageInfo, Expanded(child: sfPdfViewer)]));
          } else if (extension == ".mp4") {
            return VwVideoPlayer(file: state.fileLink);


          } else if (extension == ".mp3") {
            return VwAudioPlayer(file: state.fileLink);
          }  else if (extension == ".png" ||
              extension == ".jpg" ||
              extension == ".jpeg" ||
              extension == ".webp" ||
              extension == ".gif"
          ) {
            return Image.file(key: this.widget.key, state.fileLink,scale: 0.01,);
          } else {
            Fluttertoast.showToast(
                msg: "Error: File can't be displayed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.yellow,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      } else if (state is DisplayContentInMemoryFileviewerState) {
        final String? extension = p
            .extension(state.fileStorage.clientEncodedFile!.fileInfo.fileName)
            .toLowerCase();

        if (extension != null) {
          if (extension == ".xlsx")
            {
              Widget downloadLink=InkWell(
                  onTap: () async{
                    await FileSaver.instance.saveFile(
                      name: this.widget.fileStorage.clientEncodedFile!=null?this.widget.fileStorage.clientEncodedFile!.fileInfo.fileName:Uuid().v4()+".pdf",
                      bytes: state.fileInMemory,

                    );
                  },
                  child:Icon(Icons.download_for_offline,color: Colors.blue,size: 40,));
              //return XlsViewer(bytes:state.fileInMemory,fileName: state.fileStorage.clientEncodedFile!.fileInfo.fileName, );
              return Scaffold(
                  body: Column(
                      children: [this.pageInfo,downloadLink]));
            }
          else if (extension == ".pdf") {
            //return PdfViewer.openData(state.fileInMemory);
            SfPdfViewer sfPdfViewer = SfPdfViewer.memory ( state.fileInMemory,key: widget.key,
                scrollDirection:PdfScrollDirection.vertical,
                onDocumentLoaded: this._onPdfPageLoaded,
                onPageChanged: this._onPdfPageChanged,
                enableDoubleTapZooming: false,
                controller: this._pdfViewerController);



            Widget downloadLinkPdf=InkWell(
                onTap: () async{
                  await FileSaver.instance.saveFile(
                      name: this.widget.fileStorage.clientEncodedFile!=null?this.widget.fileStorage.clientEncodedFile!.fileInfo.fileName:Uuid().v4()+".pdf",
                      bytes: state.fileInMemory,

                      );
                },
                child:Icon(Icons.download_for_offline,color: Colors.blue,));


            return Scaffold(
                body: Column(
                    children: [this.pageInfo,downloadLinkPdf, Expanded(child: sfPdfViewer)]));
          } else if (extension == ".svg") {
            return SvgPicture.memory(
              state.fileInMemory,
              fit: BoxFit.contain,
            );
          } else if (extension == ".png" ||
              extension == ".jpg" ||
              extension == ".jpeg" ||
              extension == ".webp" ||
              extension == ".gif"
          ) {
            //return Image.memory(state.fileInMemory);
            return ZoomOverlay(
              key: this.widget.key,
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
              child:Image.memory( key: this.widget.key, state.fileInMemory,scale: 0.01,),
            );


            /*
            return ExtendedImage.memory(
              state.fileInMemory,
              key: widget.key,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.gesture,
            );*/
          } else {
            Fluttertoast.showToast(
                msg: "Error: File can;t be displayed.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.pop(context);
          }
        }
      } else if (state is BootupFileviewerState) {
        return Center(child: Text('Bootup'));
      } else if (state is LoadFailedFileviewerState) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    bloc.add(LoadFileviewerEvent(timestamp: DateTime.now()));
                  },
                  icon: const Icon(Icons.refresh)),
              Text("Error downloading file. Please Tap to refrewsh.")
            ]);
      }

      return Container(
          color: Colors.white, child: Center(child: Text('Uknown Error has been occured.')));
    });
  }
}

class PageInfo extends StatefulWidget {
  PageInfo({this.actionsWidget=const [], required this.fieldValue, required this.getTagWidget});

  final VwFieldValue fieldValue;
  final GetTagWidget getTagWidget;
  final List<Widget> actionsWidget;

  _PageInfoState createState() => _PageInfoState();
}

class _PageInfoState extends State<PageInfo> {
  Timer? timer;
  late String currentValueString;

  @override
  void initState() {
    // TODO: implement initState
    currentValueString = widget.fieldValue.valueString.toString();
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (currentValueString != widget.fieldValue.valueString) {
        currentValueString = widget.fieldValue.valueString.toString();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    try {
      int currentPage = int.parse(currentValueString);
      return widget.getTagWidget(page: currentPage);
    } catch (error) {}
    return Container();
  }
}
