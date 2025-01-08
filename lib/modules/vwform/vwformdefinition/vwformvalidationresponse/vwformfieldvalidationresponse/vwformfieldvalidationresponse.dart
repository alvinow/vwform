import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformfieldvalidationresponsecomponent/vwformfieldvalidationresponsecomponent.dart';
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