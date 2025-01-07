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

  static VwFormDefinition searchSpmForm() {
    VwFormField formField1 = VwFormField(
      fieldDefinition: VwFieldDefinition(
        fieldName: 'filterByThang',
        fieldConstraint: VwFieldConstraint(isMandatory: false),
      ),
      fieldUiParam: VwFieldUiParam(
          uiTypeId: VwFieldUiParam.uitTextField,
          caption: 'Thang',
          isReadOnly: false),
    );
    VwFormField formField2 = VwFormField(
      fieldDefinition: VwFieldDefinition(
          fieldName: 'filterByKdsatker',
          fieldConstraint: VwFieldConstraint(isMandatory: false)),
      fieldUiParam: VwFieldUiParam(
          uiTypeId: VwFieldUiParam.uitTextField,
          caption: 'Kode Satker',
          isReadOnly: false),
    );

    VwFormField formField3 = VwFormField(
      fieldDefinition: VwFieldDefinition(
          fieldName: 'filterByUntuk',
          fieldConstraint: VwFieldConstraint(isMandatory: false)),
      fieldUiParam: VwFieldUiParam(
          uiTypeId: VwFieldUiParam.uitTextField,
          caption: 'Untuk',
          isReadOnly: false),
    );

    VwFormField formField4 = VwFormField(
      fieldDefinition: VwFieldDefinition(
          fieldName: 'filterByKdakun',
          fieldConstraint: VwFieldConstraint(isMandatory: false)),
      fieldUiParam: VwFieldUiParam(
          uiTypeId: VwFieldUiParam.uitTextField,
          caption: 'Kode Akun',
          isReadOnly: false),
    );

    VwFormField formField5 = VwFormField(
      fieldDefinition: VwFieldDefinition(
          fieldName: 'filterByNmppk',
          fieldConstraint: VwFieldConstraint(isMandatory: false)),
      fieldUiParam: VwFieldUiParam(
          uiTypeId: VwFieldUiParam.uitTextField,
          caption: 'Nama PPK',
          isReadOnly: false),
    );

    VwFormField formField6 = VwFormField(
      fieldDefinition: VwFieldDefinition(
          fieldName: 'filterByNipppk',
          fieldConstraint: VwFieldConstraint(isMandatory: false)),
      fieldUiParam: VwFieldUiParam(
          uiTypeId: VwFieldUiParam.uitTextField,
          caption: 'NIP PPK',
          isReadOnly: false),
    );

    VwFormField formField7 = VwFormField(
      fieldDefinition: VwFieldDefinition(
          fieldName: 'filterByNoSpp',
          fieldConstraint: VwFieldConstraint(isMandatory: false)),
      fieldUiParam: VwFieldUiParam(
          uiTypeId: VwFieldUiParam.uitTextField,
          caption: 'No.SPP',
          isReadOnly: false),
    );

    VwFormField formField8 = VwFormField(
      fieldDefinition: VwFieldDefinition(
          fieldName: 'filterByNoSp2d',
          fieldConstraint: VwFieldConstraint(isMandatory: false)),
      fieldUiParam: VwFieldUiParam(
          uiTypeId: VwFieldUiParam.uitTextField,
          caption: 'No.SP2D',
          isReadOnly: false),
    );

    VwFormField formField9 = VwFormField(
      fieldDefinition: VwFieldDefinition(
        fieldName: 'sortFieldName',
        fieldConstraint: VwFieldConstraint(isMandatory: false),
      ),
      fieldUiParam: VwFieldUiParam(
          caption: 'urutan',
          uiTypeId: VwFieldUiParam.uitDropdown,
          parameter: VwQueryResult(rows: [
            VwRowData(
                creatorUserId: AppConfig.invalidUserId,
                timestamp: VwDateUtil.nowTimestamp(),
                recordId: Uuid().v4(),
                fields: [
                  VwFieldValue(
                      fieldName: "choiceValue", valueString: "sortObject.nospm")
                ]),
            VwRowData(
                creatorUserId: AppConfig.invalidUserId,
                timestamp: VwDateUtil.nowTimestamp(),
                recordId: Uuid().v4(),
                fields: [
                  VwFieldValue(
                      fieldName: "choiceValue", valueString: "sortObject.tgspm")
                ]),
            VwRowData(
                timestamp: VwDateUtil.nowTimestamp(),
                recordId: Uuid().v4(),
                fields: [
                  VwFieldValue(
                      fieldName: "choiceValue",
                      valueString: "sortObject.nmppk"),
                ]),
          ]),
          isReadOnly: false),
    );

    VwFormField formField10 = VwFormField(
      fieldDefinition: VwFieldDefinition(
          fieldName: 'spmWithAttachment',
          fieldConstraint: VwFieldConstraint(isMandatory: false)),
      fieldUiParam: VwFieldUiParam(
          caption: 'ada berkas',
          isReadOnly: false,
          uiTypeId: VwFieldUiParam.uitCheckboxField),
    );

    //initialValue.formDefinitionId = "<invalid_form_definition_id>";

    VwSectionFormDefinition sectionA = VwSectionFormDefinition(formFields: [
      formField1,
      formField2,
      formField3,
      formField5,
      formField7,
      formField10
    ]);

    VwFormDefinition returnValue = VwFormDefinition(
        recordId: "<invalid_form_id>",
        formResponseSyncCollectionName: "<invalid_form_id>",
        timestamp: VwDataFormatTimestamp(
            created: DateTime.now(), updated: DateTime.now()),
        formName: "SearchSpm",
        sections: [sectionA]);

    return returnValue;
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
