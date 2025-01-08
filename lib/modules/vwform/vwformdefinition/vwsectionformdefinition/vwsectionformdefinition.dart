import 'package:json_annotation/json_annotation.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformfield/vwformfield.dart';
part 'vwsectionformdefinition.g.dart';

@JsonSerializable()
class VwSectionFormDefinition {
  VwSectionFormDefinition({
    this.name,
    this.description,
    required this.formFields,
  });
  final String? name;
  final String? description;
  final List<VwFormField> formFields;

  factory VwSectionFormDefinition.fromJson(Map<String, dynamic> json) =>
      _$VwSectionFormDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$VwSectionFormDefinitionToJson(this);
}
