import 'package:json_annotation/json_annotation.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformvalidationresponse/vwformvalidationresponse.dart';
part 'vwformfieldvalidationresponsecomponent.g.dart';

@JsonSerializable()

class VwFormFieldValidationResponseComponent {
  final String fieldName;
  final DateTime validationTimestamp;
  final bool isValidationPassed;
  final String validationMethodCode;
  final String validationMethodName;
  final String sufficeSuggestion;
  final String? errorMessage;
  final VwFormValidationResponse? validationFormResponse;

  VwFormFieldValidationResponseComponent(
      {required this.fieldName,
      required this.validationTimestamp,
      required this.isValidationPassed,
        required this.validationMethodCode,
        required this.validationMethodName,
        required this.sufficeSuggestion,
      this.errorMessage,
      this.validationFormResponse
      });

  factory VwFormFieldValidationResponseComponent.fromJson(Map<String, dynamic> json) =>
      _$VwFormFieldValidationResponseComponentFromJson(json);
  Map<String, dynamic> toJson() => _$VwFormFieldValidationResponseComponentToJson(this);
}
