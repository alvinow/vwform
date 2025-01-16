import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:intl/intl.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';
import 'dart:convert';

import 'package:vwform/modules/noderowviewer/noderowviewer.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwformpage/vwdefaultformpage.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';


class VwFormResponseUserRowViewer extends NodeRowViewer {
  VwFormResponseUserRowViewer(
      {required super.rowNode,
        required super.appInstanceParam,
        super.highlightedText,
        super.refreshDataOnParentFunction
      });



  @override
  Widget build(BuildContext context) {
    Widget returnValue = Text(rowNode.recordId);

    Map<String, HighlightedWord> words = {};

    if (this.highlightedText != null) {
      words = {
        this.highlightedText!: HighlightedWord(
          onTap: () {
            print("this.highlightedText");
          },
          textStyle: TextStyle(backgroundColor: Colors.yellow),
        ),
      };
    }

    var f = NumberFormat.simpleCurrency(locale: 'id_ID');

    try {

      if (rowNode.content != null &&
          rowNode.content.linkRowCollection != null &&
          rowNode.content.linkRowCollection!.rendered!=null &&
          rowNode.content.linkRowCollection!.rendered!.collectionName!=null

      ) {
        VwRowData formResponse =rowNode.content.linkRowCollection!.rendered!;

       Key rowKey= Key(formResponse.recordId+(formResponse.timestamp==null?"":formResponse.timestamp!.created.toIso8601String()));

        if(formResponse.attachments!=null) {
          for (int la = 0; la < formResponse.attachments!.length; la++) {
            VwNodeContent currentNodeContent= formResponse.attachments!.elementAt(la);

            if(currentNodeContent.tag==this.appInstanceParam.baseAppConfig.generalConfig.tagLinkBaseModelFormDefinition && currentNodeContent.linkbasemodel!=null && currentNodeContent.linkbasemodel!.rendered!=null)
              {
                RemoteApi.decompressClassEncodedJson(currentNodeContent.linkbasemodel!.rendered!);
                VwFormDefinition formDefinition=VwFormDefinition.fromJson(currentNodeContent.linkbasemodel!.rendered!.data!);



                Widget captionRow=Expanded(flex:5, child:Container( child:Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "[Respon] ${formDefinition.formName}",

                    overflow: TextOverflow.visible,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Container(margin: EdgeInsets.fromLTRB(0, 5, 0, 0), child:  Text(  "Update "+  (formResponse.timestamp==null?"": VwDateUtil.indonesianFormatLocalTimeZone(formResponse.timestamp!.updated))   ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                ])));

                Widget iconRow=Container(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),  child: Stack(alignment: AlignmentDirectional.bottomEnd, children: [Container(padding: EdgeInsets.fromLTRB(0, 0, 5, 5), child:Icon(Icons.list_alt,color: Colors.purple,size:20)),Icon(Icons.person_sharp,color: Colors.black,size: 20,)],),);

                Widget row=Container(padding: EdgeInsets.all(10),  child: Row(children: [iconRow,captionRow]));

                returnValue = InkWell(
                    key: rowKey,
                    onTap: () async{
                      print("form tapped");

                      String formResponseCloneString=json.encode(formResponse.toJson());
                      VwRowData formResponseClone=VwRowData.fromJson(json.decode(formResponseCloneString));


                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VwFormPage(
                                  appInstanceParam: this.appInstanceParam,
                                    isMultipageSections: true,
                                    formDefinitionFolderNodeId: this.appInstanceParam.baseAppConfig.generalConfig.formDefinitionFolderNodeId,

                                    formDefinition: formDefinition,
                                    formResponse: formResponseClone,
                                    refreshDataOnParentFunction: this.refreshDataOnParentFunction
                                )
                        ),
                      );

                    },
                    child: row
                );
                break;
              }
          }
        }



      }
    } catch (error) {
      returnValue = Text(rowNode.recordId + ': Error=' + error.toString());
    }

    return returnValue;
  }
}
