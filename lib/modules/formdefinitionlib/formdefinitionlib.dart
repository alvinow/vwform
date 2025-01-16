import 'package:flutter/material.dart';
import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwdataformattimestamp/vwdataformattimestamp.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfieldconstraint/vwfieldconstraint.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfielddefinition/vwfielddefinition.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwqueryresult/vwqueryresult.dart';

import 'package:uuid/uuid.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwsectionformdefinition/vwsectionformdefinition.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class FormDefinitionLib {
  static String checkListBerkasSpm = "checklistBerkasSpm";

  static cleanZeroLengthString(VwRowData rowData) {
    if (rowData.fields != null) {
      for (int la = 0; la < rowData.fields!.length; la++) {
        VwFieldValue? currentFieldValue = rowData.fields!.elementAt(la);

        if (currentFieldValue.valueString != null &&
            currentFieldValue.valueString == "") {
          currentFieldValue.valueString = null;
        }
      }
    }
  }



  static VwFormDefinition getLoginForm() {
    VwFormField formField1 = VwFormField(
      fieldDefinition: VwFieldDefinition(
        fieldName: 'username',
        fieldConstraint: VwFieldConstraint(isMandatory: true),
      ),
      fieldUiParam: VwFieldUiParam(
          caption: 'username',
          uiTypeId: VwFieldUiParam.uitTextField,
          isReadOnly: false),
    );
    VwFormField formField2 = VwFormField(
      fieldDefinition: VwFieldDefinition(
        fieldName: 'password',
        fieldConstraint: VwFieldConstraint(isMandatory: true),
      ),
      fieldUiParam: VwFieldUiParam(
          uiTypeId: VwFieldUiParam.uitTextpasswordField,
          caption: 'password',
          isReadOnly: false),
    );
    VwFormField formField3 = VwFormField(
      fieldDefinition: VwFieldDefinition(
        fieldName: 'errorMessage',
        fieldConstraint: VwFieldConstraint(
          isMandatory: true,
        ),
      ),
      fieldUiParam: VwFieldUiParam(
          uiTypeId: VwFieldUiParam.uitStaticTextField,
          caption: 'error',
          isReadOnly: true),
    );

    //initialValue.formDefinitionId = FormDefinitionLib.checkListBerkasSpm;
    /*
    VwFormRecord formResponse = VwFormRecord(
        recordId: Uuid().v4(),
        timestamp: VwDataFormatTimestamp(
            created: DateTime.now(), updated: DateTime.now()),
        formDefinitionId: FormDefinitionLib.checkListBerkasSpm,
        rowData: initialValue,
        ownerUserId: "<invalid_owner_user_id>");

     */

    //VwSectionFormParam sectionA=VwSectionFormParam( formFields: <VwFormField>[formField1, formField2, formField3]);

    VwSectionFormDefinition sectionA = VwSectionFormDefinition(formFields: [
      formField1,
      formField2,
      formField3,
    ]);

    VwFormDefinition returnValue = VwFormDefinition(
        recordId: "loginForm",
        isReadOnly: false,
        formResponseSyncCollectionName: "<invalid_collection_name>",
        timestamp: VwDataFormatTimestamp(
            created: DateTime.now(), updated: DateTime.now()),
        formName: "Login",
        sections: [sectionA]);

    return returnValue;
  }
}
