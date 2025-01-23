import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwlocalfieldref/vwlocalfieldref.dart';
import 'package:vwutil/modules/util/nodeutil.dart';

class FormUtil {
  static VwFieldValue? getFieldValueByLocalFieldRef(
      {required VwRowData rowData, required VwLocalFieldRef localFieldRef}) {
    VwFieldValue? returnValue;

    try {
      VwFieldValue? tempFieldValue;
      if (localFieldRef.localFieldName != null) {
        tempFieldValue = rowData.getFieldByName(localFieldRef.localFieldName);

        if (localFieldRef.internalFieldName != null) {
          if (tempFieldValue != null &&
              tempFieldValue.valueTypeId == VwFieldValue.vatValueLinkNode &&
              tempFieldValue!.valueLinkNode != null) {
            tempFieldValue = NodeUtil.extractRowDataFromLinkNode(
                    tempFieldValue!.valueLinkNode!)!
                .getFieldByName(localFieldRef.internalFieldName!);

            if (localFieldRef.internalSubFieldName != null) {
              tempFieldValue = NodeUtil.extractRowDataFromLinkNode(
                      tempFieldValue!.valueLinkNode!)!
                  .getFieldByName(localFieldRef.internalSubFieldName!);

              if (localFieldRef.internalSub2FieldName != null) {
                tempFieldValue = NodeUtil.extractRowDataFromLinkNode(
                        tempFieldValue!.valueLinkNode!)!
                    .getFieldByName(localFieldRef.internalSub2FieldName!);

                if (localFieldRef.internalSub3FieldName != null) {
                  tempFieldValue = NodeUtil.extractRowDataFromLinkNode(
                          tempFieldValue!.valueLinkNode!)!
                      .getFieldByName(localFieldRef.internalSub3FieldName!);
                  returnValue = tempFieldValue;
                } else {
                  returnValue = tempFieldValue;
                }
              } else {
                returnValue = tempFieldValue;
              }
            } else {
              returnValue = tempFieldValue;
            }
          }
        } else {
          returnValue = tempFieldValue;
        }
      }
    } catch (error) {}
    return returnValue;
  }
}
