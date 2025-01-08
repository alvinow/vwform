import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwfilestorage/vwfilestorage.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwfileviewer/vwfileviewer.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediainstanceparam/vwmultimediaviewerinstanceparam.dart';
import 'package:vwform/modules/vwmultimediaviewer/vwmultimediaviewerparam/vwmultimediaviewerparam.dart';
import 'package:vwform/modules/vwwidget/vwpageswiper/vwpageswiper.dart';

class VwMultimediaViewer extends StatefulWidget{
  VwMultimediaViewer({
    Key? key,
    required this.appInstanceParam,
    required this.multimediaViewerParam,
    required this.multimediaViewerInstanceParam,
    this.initPage=1,
    this.usedAsWidgetComponent=false,

}):super(key: key);
  final bool usedAsWidgetComponent;
  final VwAppInstanceParam appInstanceParam;
  final VwMultimediaViewerParam multimediaViewerParam;
  final VwMultimediaViewerInstanceParam multimediaViewerInstanceParam;
  int initPage;
  _VwMultimediaViewerState createState()=>_VwMultimediaViewerState();

}

class _VwMultimediaViewerState extends State<VwMultimediaViewer>{

  @override
  void initState() {

    super.initState();
  }

  List<Widget> _createFileViewerWidgetList(){
    List<Widget> returnValue=[];

    for(int la=0;la< widget.multimediaViewerInstanceParam.remoteSource.length;la++)
      {
        VwFileStorage currentElement=widget.multimediaViewerInstanceParam.remoteSource.elementAt(la);

        returnValue.add(VwFileViewer(key: Key(la.toString()), readOnly: this.widget.multimediaViewerParam.readOnly, refTagLinkNodeList: widget.multimediaViewerParam.refTagLinkNodeList, initPage: this.widget.initPage, fieldFileTagDefinition: this.widget.multimediaViewerParam.fieldFileTagDefinition, fileStorage: currentElement,tagFieldValue: widget.multimediaViewerInstanceParam.tagFieldvalue,appInstanceParam: this.widget.appInstanceParam,));


      }

    return returnValue;
  }

  Widget _titleWidget()
  {
    Widget returnValue=Container();
    try
    {
      Widget iconWidget=this.widget.multimediaViewerInstanceParam.icon==null?Container():this.widget.multimediaViewerInstanceParam.icon!;

      Widget captionWidget=this.widget.multimediaViewerInstanceParam.caption==null?Container():Text(this.widget.multimediaViewerInstanceParam.caption!);

      returnValue=Row(mainAxisAlignment: MainAxisAlignment.start, children: [iconWidget,captionWidget],);
    }
    catch(error)
    {

    }

    return returnValue;
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pageList=_createFileViewerWidgetList();


    Widget mediaWidget = Icon(Icons.image);

    if(pageList.length>1)
      {
        mediaWidget=VwPageSwiper(key:this.widget.key, usedAsWidgetComponent:true ,pages: pageList);
      }
    else{
      mediaWidget=pageList.elementAt(0);
    }





    if(this.widget.usedAsWidgetComponent==true)
      {
       return  Container(
            color: Colors.transparent,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: mediaWidget);
      }

    return Scaffold (
      appBar: AppBar(
        centerTitle: false,
        title:_titleWidget() ,

      ),
      body: Row(children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
                color: Colors.transparent,
                //padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: mediaWidget)),

      ]),

    );
  }

}