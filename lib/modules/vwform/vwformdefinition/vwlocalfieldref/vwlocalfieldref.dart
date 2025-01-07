import 'package:json_annotation/json_annotation.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
part 'vwlocalfieldref.g.dart';

@JsonSerializable()
class VwLocalFieldRef {
  VwLocalFieldRef(
      {required this.localFieldName,
      this.internalFieldName,
      this.internalSubFieldName,
      this.fieldRefMode = VwLocalFieldRef.rfmInternalSubFieldValue,
      this.staticFilter});

  String localFieldName;
  String? internalFieldName;
  String? internalSubFieldName;
  String? internalSub2FieldName;
  String? internalSub3FieldName;
  String fieldRefMode;
  VwRowData? staticFilter;

  static const String rfmLocalFieldValue = "rfmLocalFieldNameFieldValue";
  static const String rfmInternalFieldValue = "rfmInternalFieldValue";
  static const String rfmInternalSubFieldValue = "rfmInternalSubFieldValue";
  static const String rfmInternalSub2FieldValue = "rfmInternalSub2FieldValue";
  static const String rfmInternalSub3FieldValue = "rfmInternalSub3FieldValue";
  static const String rfmLocalFieldRecordId = "rfmLocalFieldRecordId";
  static const String rfmInternalFieldRecordId = "rfmInternalFieldRecordId";
  static const String rfmInternalSubFieldRecordId =
      "rfmInternalSubFieldRecordId";

  factory VwLocalFieldRef.fromJson(Map<String, dynamic> json) =>
      _$VwLocalFieldRefFromJson(json);
  Map<String, dynamic> toJson() => _$VwLocalFieldRefToJson(this);
}
