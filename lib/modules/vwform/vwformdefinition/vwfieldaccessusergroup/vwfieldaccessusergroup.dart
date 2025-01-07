import 'package:json_annotation/json_annotation.dart';
part 'vwfieldaccessusergroup.g.dart';

@JsonSerializable()
class VwFieldAccessUserGroup {
  VwFieldAccessUserGroup(
      {required this.userGroupId,
      this.createAccess=false,
      this.readAccess=false,
      this.updateAccess=false});
  String userGroupId;
  bool createAccess;
  bool readAccess;
  bool updateAccess;

  factory VwFieldAccessUserGroup.fromJson(Map<String, dynamic> json) =>
      _$VwFieldAccessUserGroupFromJson(json);
  Map<String, dynamic> toJson() => _$VwFieldAccessUserGroupToJson(this);
}
