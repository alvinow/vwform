import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:intl/intl.dart';
import 'package:matrixclient/modules/base/vwlinknode/modules/vwlinknoderendered/vwlinknoderendered.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient/modules/base/vwnode/vwcontentcontext/vwcontentcontext.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/vwwidget/vwcardparameternodeviewermaterial/vwcardparameternodeviewermaterial.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwwidget/noderowviewer/noderowviewer.dart';
import 'package:matrixclient/modules/vwwidget/vwselectnoderecordpage/vwselectnoderecordpage.dart';

class VwSelectNodeRecordPageRowViewer extends NodeRowViewer {
  VwSelectNodeRecordPageRowViewer(
      {required super.rowNode,
      required super.appInstanceParam,
      super.highlightedText,
      super.refreshDataOnParentFunction,
      required this.formField,
      this.nodeRecordSelected,
      super.topRowWidget
      });


  final VwFormField formField;
  final NodeRecordSelected? nodeRecordSelected;


  @override
  Widget build(BuildContext context) {
    Widget returnValue = Text(rowNode.recordId);



    try {

      if(rowNode.nodeType==VwNode.ntnTopNodeInsert )
        {
          if(topRowWidget!=null) {
            return topRowWidget!;
          }
          else {
            return Container();
          }
        }




      InkWell cardTapper = InkWell(
          onTap: () async {
            //print("recordId/CollectionName="+currentBaseModel.recordId+"/"+collectionName);

            if (nodeRecordSelected != null) {

              try {
                if(this.rowNode.content.linkRowCollection!=null) {
                  //this.rowNode.content.linkRowCollection!.rendered = null;
                  //this.rowNode.content.linkRowCollection!.cache = null;
                }
                if(this.rowNode.content.linkbasemodel!=null) {
                  //this.rowNode.content.linkbasemodel!.rendered = null;
                  //this.rowNode.content.linkbasemodel!.cache = null;
                }
              }
              catch(error)
            {

            }

              VwLinkNode selectedLinkNode = VwLinkNode(
                  cache:  VwLinkNodeRendered(
                      renderedDate: DateTime.now(), node: this.rowNode),
                  nodeId: this.rowNode.recordId,
                  nodeType: this.rowNode.nodeType,

                  contentContext: VwContentContext(
                    collectionName: this.rowNode.nodeType ==
                        VwNode.ntnLinkBaseModelCollection
                        ? this.rowNode.content.linkbasemodel!.collectionName
                        : this.rowNode.nodeType == VwNode.ntnLinkRowCollection
                        ? this
                        .rowNode
                        .content
                        .linkRowCollection!
                        .collectionName
                        : this.rowNode.nodeType == VwNode.ntnRowData
                        ?this.rowNode.content.rowData!.collectionName:null,
                    recordId: this.rowNode.nodeType ==
                        VwNode.ntnLinkBaseModelCollection
                        ? this.rowNode.content.linkbasemodel!.recordId
                        : this.rowNode.nodeType == VwNode.ntnLinkRowCollection
                        ? this.rowNode.content.linkRowCollection!.recordId
                        : this.rowNode.nodeType == VwNode.ntnRowData
                        ?this.rowNode.content.rowData!.recordId  : null,
                  ),
              );
              this.nodeRecordSelected!(selectedLinkNode);
            }

            Navigator.pop(context);
          }
          );


      return VwCardParameterNodeViewerMaterial(
          appInstanceParam: this.appInstanceParam,
          cardParameter: formField.fieldUiParam.collectionListViewDefinition!.cardParameter, rowNode: rowNode, cardTapper: cardTapper);




    } catch (error) {
      print("Error catcted on VwSelectBaseModelRowViewer: " + error.toString());
    }

    return returnValue;
  }
}
