import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformfieldvalidationresponsecomponent/vwformfieldvalidationresponsecomponent.dart';

import 'package:json_annotation/json_annotation.dart';
part 'vwformfieldvalidationresponse.g.dart';

@JsonSerializable()

class VwFormFieldValidationResponse{
   VwFormField formField;
   VwFieldValue fieldValue;
   List<VwFormFieldValidationResponseComponent> validationReponses;

   VwFormFieldValidationResponse({
     required this.formField,
     required this.fieldValue,
     required this.validationReponses
});

   factory VwFormFieldValidationResponse.fromJson(Map<String, dynamic> json) =>
       _$VwFormFieldValidationResponseFromJson(json);
   Map<String, dynamic> toJson() => _$VwFormFieldValidationResponseToJson(this);

}