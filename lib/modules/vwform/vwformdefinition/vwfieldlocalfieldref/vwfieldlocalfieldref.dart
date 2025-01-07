import 'package:matrixclient/modules/vwform/vwformdefinition/vwlocalfieldref/vwlocalfieldref.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vwfieldlocalfieldref.g.dart';

@JsonSerializable()
class VwFieldLocalFieldRef{
  VwFieldLocalFieldRef({
    required this.fieldNameOnContentDataSource,
    required this.localFieldRef
});

  String fieldNameOnContentDataSource;
  VwLocalFieldRef localFieldRef;


  factory VwFieldLocalFieldRef.fromJson(Map<String, dynamic> json) =>
      _$VwFieldLocalFieldRefFromJson(json);
  Map<String, dynamic> toJson() => _$VwFieldLocalFieldRefToJson(this);
  }