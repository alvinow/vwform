import 'package:matrixclient2base/modules/base/vwdataformat/vwfieldconstraint/vwfieldconstraint.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfielddefinition/vwfielddefinition.dart';
import 'package:matrixclient2base/modules/base/vwqueryresult/vwqueryresult.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfieldaccess/vwfieldaccess.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
part 'vwformfield.g.dart';

@JsonSerializable()
class VwFormField {
  VwFormField(
      {
        required this.fieldDefinition,
        required this.fieldUiParam,
        this.fieldAccess
      });




  final VwFieldUiParam fieldUiParam;
  final VwFieldAccess? fieldAccess;
  final VwFieldDefinition fieldDefinition;



  factory VwFormField.fromJson(Map<String, dynamic> json) =>
      _$VwFormFieldFromJson(json);
  Map<String, dynamic> toJson() => _$VwFormFieldToJson(this);
}
