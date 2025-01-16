import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnodecontent/vwnodecontent.dart';


import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwsectionformdefinition/vwsectionformdefinition.dart';

class VwFormDefinitionUtil{

  static VwFormDefinition? extractFirstOccurenceFormDefinition(
      {
        required String tagLinkBaseModelFormDefinition,
        required List<VwNodeContent> nodeContents}) {
    for (int la = 0; la < nodeContents.length; la++) {
      VwNodeContent currentNodeContent = nodeContents.elementAt(la);
      if (currentNodeContent.tag == tagLinkBaseModelFormDefinition &&
          currentNodeContent.linkbasemodel != null &&
          currentNodeContent.linkbasemodel!.rendered != null) {
        try {
          VwFormDefinition formDefinition = VwFormDefinition.fromJson(
              currentNodeContent.linkbasemodel!.rendered!.data!);

          return formDefinition;
        } catch (error) {}
      }
    }

    return null;
  }


  static VwRowData addRowDataFromFormDefinition({required VwRowData formResponse,  required VwFormDefinition formParam, required String ownerUserId }) {

    //VwRowData rowData=VwRowData(recordId:Uuid().v4() , timestamp: VwDataFormatTimestamp(created: DateTime.now(), updated: DateTime.now()), formDefinitionId: Uuid().v4(), creatorUserId: ownerUserId,fields:<VwFieldValue>[]);

    for(int la=0; la<formParam.sections.length;la++)
    {
      VwSectionFormDefinition currentSectionFormParam=formParam.sections.elementAt(la);
      for(int lb=0;lb<currentSectionFormParam.formFields.length;lb++)
      {
        VwFormField currentFormField=currentSectionFormParam.formFields.elementAt(lb);

        VwFieldValue currentFieldValue=VwFieldValue(fieldName: currentFormField.fieldDefinition.fieldName,valueTypeId:currentFormField.fieldDefinition.valueTypeId );

        VwFieldValue? currentFieldValueOnFormResponse = formResponse.getFieldByName(currentFieldValue.fieldName);
        if(currentFieldValueOnFormResponse==null) {
          formResponse.fields!.add(currentFieldValue);
        }
      }
    }

    return formResponse;
  }


  static VwRowData createBlankRowDataFromFormDefinition({required VwFormDefinition formDefinition, required String ownerUserId }) {

    VwRowData rowData=VwRowData(recordId:Uuid().v4() , formDefinitionId: Uuid().v4(), creatorUserId: ownerUserId,fields:<VwFieldValue>[]);

    for(int la=0; la<formDefinition.sections.length;la++)
      {
        VwSectionFormDefinition currentSectionFormParam=formDefinition.sections.elementAt(la);
        for(int lb=0;lb<currentSectionFormParam.formFields.length;lb++)
          {
            VwFormField currentFormField=currentSectionFormParam.formFields.elementAt(lb);

            VwFieldValue currentFieldValue=VwFieldValue(fieldName: currentFormField.fieldDefinition.fieldName,valueTypeId:currentFormField.fieldDefinition.valueTypeId );
            rowData.fields!.add(currentFieldValue);
          }
      }

   return rowData;
  }
}