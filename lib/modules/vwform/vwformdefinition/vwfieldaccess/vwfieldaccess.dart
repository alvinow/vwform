import 'package:matrixclient/modules/vwform/vwformdefinition/vwfieldaccessusergroup/vwfieldaccessusergroup.dart';
import 'package:json_annotation/json_annotation.dart';
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