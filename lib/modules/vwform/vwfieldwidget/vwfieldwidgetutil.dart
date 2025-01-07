import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/util/nodeutil.dart';
import 'package:matrixclient/modules/vwform/vwform.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwlocalfieldref/vwlocalfieldref.dart';

class VwFieldWidgetUtil {
  static VwFieldValue? getFielValueFromRowData(
      {required VwRowData source, required VwLocalFieldRef localFieldRef}) {
    try {
      return source.getFieldByName(localFieldRef.localFieldName);
    } catch (error) {}
    return null;
  }



  static VwNode ? getLinkNodeActiveContent(VwLinkNode linkNode){
    VwNode? returnValue;
    try
        {
          if(linkNode.sync!=null) {
            returnValue = linkNode.sync!.node;
          }

          if(returnValue==null && linkNode.rendered!=null) {
            returnValue = linkNode.rendered!.node;
          }

          if(returnValue==null && linkNode.cache!=null){
            returnValue=linkNode.cache!.node;
          }




        }
        catch(error)
    {

    }

    return returnValue;
  }


  static VwFieldValue? getInternalOfFielValueFromRowData(
      {required VwRowData source, required VwLocalFieldRef localFieldRef}) {
    try {
      VwFieldValue? localFieldvalue = VwFieldWidgetUtil.getFielValueFromRowData(
          source: source, localFieldRef: localFieldRef);

      if (localFieldRef.internalFieldName != null && localFieldvalue != null) {
        if (localFieldvalue.valueTypeId == VwFieldValue.vatValueLinkNode) {
          VwRowData? internalRowsData;

          try {



            VwNode? curentNode=VwFieldWidgetUtil.getLinkNodeActiveContent(localFieldvalue.valueLinkNode!);


            if(curentNode!=null)
              {
                if(curentNode.nodeType==VwNode.ntnLinkRowCollection) {
                  internalRowsData =
                      NodeUtil.extractLinkRowCollection(curentNode!.content);
                }
                else if(curentNode.nodeType==VwNode.ntnRowData)
                {
                  internalRowsData = curentNode.content.rowData;
                  }
              }


            /*
            internalRowsData=localFieldvalue.valueLinkNode!.cache!.node!.content
                .linkRowCollection!.cache!;*/
          } catch (error) {}



          if (internalRowsData != null) {
            return internalRowsData!
                .getFieldByName(localFieldRef.internalFieldName!);
          }
        } else if (localFieldvalue.valueTypeId ==
            VwFieldValue.vatValueRowData) {
          return localFieldvalue.valueRowData!
              .getFieldByName(localFieldRef.internalFieldName!);
        }
      }
    } catch (error) {}
    return null;
  }
}
