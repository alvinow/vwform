import 'package:json_annotation/json_annotation.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformfieldvalidationresponse/vwformfieldvalidationresponse.dart';
part 'vwformvalidationresponse.g.dart';

/*
    isTryValidated:boolean;
    lastTryValidated?:Date;
 */

@JsonSerializable()
class VwFormValidationResponse{
   VwFormDefinition? formDefinition;
   List< VwFormFieldValidationResponse >? formFieldValidationResponses;
   bool isTryValidated;
   bool isFormResponseValid;
   DateTime? lastTryValidated;
   String? errorMessage;




   VwFormValidationResponse({
     required this.formDefinition,
     required this.formFieldValidationResponses,
     this.isFormResponseValid=false,
     this.isTryValidated=false,
     this.lastTryValidated,
     this.errorMessage
});

   factory VwFormValidationResponse.fromJson(Map<String, dynamic> json) =>
       _$VwFormValidationResponseFromJson(json);
   Map<String, dynamic> toJson() => _$VwFormValidationResponseToJson(this);
}