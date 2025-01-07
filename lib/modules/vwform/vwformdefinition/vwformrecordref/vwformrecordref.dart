import 'package:json_annotation/json_annotation.dart';
part 'vwformrecordref.g.dart';

@JsonSerializable()
class VwFormRecordRef {
  String formDefinitionId;
  String formRecordId;

  VwFormRecordRef({
    required this.formDefinitionId,
    required this.formRecordId
});

  factory VwFormRecordRef.fromJson(Map<String, dynamic> json) =>
      _$VwFormRecordRefFromJson(json);
  Map<String, dynamic> toJson() => _$VwFormRecordRefToJson(this);
}