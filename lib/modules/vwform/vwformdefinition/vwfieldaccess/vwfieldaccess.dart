import 'package:json_annotation/json_annotation.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfieldaccessusergroup/vwfieldaccessusergroup.dart';
part 'vwfieldaccess.g.dart';

@JsonSerializable()
class VwFieldAccess{
  VwFieldAccess({
    required this.enabled,
    required this.fieldAccessUserGroupList,
});
  bool enabled;
  List<VwFieldAccessUserGroup> fieldAccessUserGroupList ;

  factory VwFieldAccess.fromJson(Map<String, dynamic> json) =>
      _$VwFieldAccessFromJson(json);
  Map<String, dynamic> toJson() => _$VwFieldAccessToJson(this);
}