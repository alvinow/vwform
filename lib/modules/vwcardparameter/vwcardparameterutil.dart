import 'dart:convert';
import 'package:line_icons/line_icon.dart';
import 'package:matrixclient2base/modules/base/nodeexplorerdefinition/fieldexplorerdefinition.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwfielddisplayformat/vwfielddisplayformat.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:vwform/modules/remoteapi/remote_api.dart';
import 'package:vwform/modules/vwcardparameter/vwjsonfieldnamecardparameter.dart';
import 'package:vwutil/modules/util/displayformatutil.dart';
import 'package:vwutil/modules/util/nodeutil.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwCardParameterUtil {
  static VwJsonFieldNameCardParameter? getJsonFieldNameCardParameterFromString(
      String jsonString) {
    VwJsonFieldNameCardParameter? returnValue;
    try {
      returnValue =
          VwJsonFieldNameCardParameter.fromJson(json.decode(jsonString));
    } catch (error) {}
    return returnValue;
  }

  static String? getStringFormFieldValue(
      {required VwFieldValue fieldValue,
      VwFieldDisplayFormat? fieldDisplayFormat,
      required String locale}) {
    String? returnValue;
    try {
      if (fieldDisplayFormat != null) {
        returnValue = DisplayFormatUtil.renderDisplayFormat(
            fieldDisplayFormat!, fieldValue, locale);
      } else {
        if (fieldValue.valueTypeId == VwFieldValue.vatString &&
            fieldValue.valueString != null) {
          returnValue = fieldValue.valueString;
        } else if (fieldValue.valueTypeId == VwFieldValue.vatNumber &&
            fieldValue.valueNumber != null) {
          returnValue = fieldValue.valueNumber.toString();
        } else if (fieldValue.valueTypeId == VwFieldValue.vatDateTime &&
            fieldValue.valueDateTime != null) {
          returnValue = VwDateUtil.indonesianFormatLocalTimeZone(
              fieldValue.valueDateTime!);
        } else if (fieldValue.valueTypeId == VwFieldValue.vatDateOnly &&
            fieldValue.valueDateTime != null) {
          returnValue = VwDateUtil.indonesianFormatLocalTimeZone_DateOnly(
              fieldValue.valueDateTime!);
        } else if (fieldValue.valueTypeId == VwFieldValue.vatDateOnly &&
            fieldValue.valueDateTime != null) {
          returnValue = VwDateUtil.indonesianFormatLocalTimeZone_TimeOnly(
              fieldValue.valueDateTime!);
        }
      }
    } catch (error) {}
    return returnValue;
  }

  static VwFieldValue? renderJsonFieldNameByStringJsonFieldName(
      {required VwNode sourceNode,
      required String jsonFieldName,
      required String locale}) {
    /*
    {
    functionName:"concat",
    fieldNameList:["goodsitem","goodstype","name"]
    }


     */
    //print("jsonFieldName= " + jsonFieldName);
    VwFieldValue? returnValue;
    try {
      VwJsonFieldNameCardParameter parameter =
          VwJsonFieldNameCardParameter.fromJson(jsonDecode(jsonFieldName));

      returnValue = VwCardParameterUtil.renderJsonFieldName(
          sourceNode: sourceNode, parameter: parameter, locale: locale);
    } catch (error) {}

    return returnValue;
  }

  static VwFieldValue? renderJsonFieldName(
      {required VwNode sourceNode,
      required VwJsonFieldNameCardParameter parameter,
      required String locale}) {
    /*
    {
    functionName:"concat",
    fieldNameList:["goodsitem","goodstype","name"]
    }


     */
    VwFieldValue? returnValue =
        VwFieldValue(fieldName: "result", valueString: "");
    try {
      if (parameter.functionName == VwJsonFieldNameCardParameter.fnConcat) {
        if (parameter.memberList != null) {
          String concatResult = '';
          for (int la = 0; la < parameter.memberList!.length; la++) {
            try {
              VwJsonFieldNameCardParameter currentParameter =
                  parameter.memberList!.elementAt(la);

              VwFieldValue? currentResult =
                  VwCardParameterUtil.renderJsonFieldName(
                      sourceNode: sourceNode,
                      parameter: currentParameter,
                      locale: locale);

              String? currentValueString =
                  VwCardParameterUtil.getStringFormFieldValue(
                      fieldValue: currentResult!,
                      fieldDisplayFormat: currentParameter.fieldDisplayFormat,
                      locale: locale);

              if (currentResult != null && currentValueString != null) {
                concatResult = concatResult + currentValueString.toString();
              }
            } catch (error) {}
          }
          returnValue.valueString = concatResult;
        } else {
          returnValue.valueString = "(empty)";
        }
      } else if (parameter.functionName ==
          VwJsonFieldNameCardParameter.fnNodeExplorer) {
        if (parameter.nodeExplorerDefinition != null) {
          VwFieldValue? currentExploredResult;
          VwNode currentLevelNode = sourceNode;
          for (int la = 0;
              la < parameter.nodeExplorerDefinition!.fieldExplorerList.length;
              la++) {
            FieldExplorerDefinition currentDefinition = parameter
                .nodeExplorerDefinition!.fieldExplorerList
                .elementAt(la);

            currentExploredResult = VwCardParameterUtil.exploreField(
                sourceNode: currentLevelNode, definition: currentDefinition);

            if (la + 1 <
                parameter.nodeExplorerDefinition!.fieldExplorerList.length) {
              if (currentExploredResult != null) {
                VwNode? candidateSourceNode;
                if (currentExploredResult!.valueLinkNode != null) {
                  candidateSourceNode = NodeUtil.getNode(
                      linkNode: currentExploredResult!.valueLinkNode!);
                }

                if (candidateSourceNode == null &&
                    currentExploredResult!.valueTypeId ==
                        VwFieldValue.vatValueFormResponse &&
                    currentExploredResult!.valueFormResponse != null) {
                  VwFieldValue? currentFieldValue = currentExploredResult!
                      .valueFormResponse!
                      .getFieldByName(currentDefinition.fieldName);



                  if (currentFieldValue != null &&
                      currentFieldValue!.valueTypeId ==
                          VwFieldValue.vatValueLinkNode &&
                      currentFieldValue.valueLinkNode != null) {
                    candidateSourceNode = NodeUtil.getNode(
                        linkNode: currentFieldValue.valueLinkNode!);
                  }
                  else if (currentFieldValue != null &&
                      currentFieldValue!.valueTypeId ==
                          VwFieldValue.vatValueFormResponse &&
                      currentFieldValue.valueFormResponse != null) {

                    FieldExplorerDefinition nextDefinition = parameter
                        .nodeExplorerDefinition!.fieldExplorerList
                        .elementAt(la+1);

                    VwFieldValue? nextFieldValue = currentFieldValue.valueFormResponse!.getFieldByName(nextDefinition.fieldName)

                    if(nextFieldValue!=null && (nextFieldValue!.valueTypeId==VwFieldValue.vatString
                        ||
                        nextFieldValue!.valueTypeId==VwFieldValue.vatNumber
                        ||
                        nextFieldValue!.valueTypeId==VwFieldValue.vatDateTime
                        ||
                        nextFieldValue!.valueTypeId==VwFieldValue.vatDateOnly
                        ||
                        nextFieldValue!.valueTypeId==VwFieldValue.vatTimeOnly

                      ))
                      {
                        la++;
                        currentFieldValue=nextFieldValue;
                        break;
                      }


                  }
                }

                if (candidateSourceNode != null) {
                  currentLevelNode = candidateSourceNode;
                } else {
                  returnValue!.valueString = "(not found)";
                  break;
                }
              }
            } else {
              returnValue = currentExploredResult;
            }
          }
        } else {
          returnValue.valueString = "(undefined)";
        }
      } else if (parameter.functionName ==
          VwJsonFieldNameCardParameter.fnStatictext) {
        if (parameter.staticText != null) {
          returnValue.valueString = parameter.staticText;
        } else {
          returnValue.valueString = "";
        }
      }
    } catch (error) {}
    return returnValue;
  }

  static VwFieldValue? exploreField(
      {required VwNode sourceNode,
      required FieldExplorerDefinition definition}) {
    VwFieldValue? returnValue;
    try {
      if (definition.nodeType == VwNode.ntnRowData) {
        returnValue =
            sourceNode.content.rowData!.getFieldByName(definition.fieldName);
      } else if (definition.nodeType == VwNode.ntnClassEncodedJson) {
        RemoteApi.decompressClassEncodedJson(
            sourceNode.content.classEncodedJson!);

        returnValue = VwFieldValue(
            fieldName: definition.fieldName,
            valueString: sourceNode
                .content.classEncodedJson!.data![definition.fieldName]
                .toString());
      }
    } catch (error) {}
    return returnValue;
  }
}
