import 'package:json_annotation/json_annotation.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:vwform/modules/vwcardparameter/vwcardparameter.dart';
import 'package:vwform/modules/vwdatasourcedefinition/vwdatasourcedefinition.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwfielduiparam/vwfielduiparam.dart';
import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';
part 'vwcollectionlistviewdefinition.g.dart';

@JsonSerializable()
class VwCollectionListViewDefinition {
  VwCollectionListViewDefinition(
      {
      this.title,
        this.showSearchIcon = false,
      this.searchFormDefinition,
        required this.cardParameter,
      this.showNotificationIcon = false,
      this.showUserInfoIcon = false,
      this.detailLinkFormDefinition,
      this.detailFormDefinition,
      this.detailFormDefinitionMode =
          VwFieldUiParam.dfmLinkFormDefinition,
      required this.dataSource,
      this.enableCreateRecord=false,
        this.showBackArrow=false,
        this.detailFormDefinitionId,
        this.staticRefLinkNodeList
      });


  final String? title;
  final bool showSearchIcon;
  final VwFormDefinition? searchFormDefinition;
  final VwCardParameter cardParameter;
  final bool showNotificationIcon;
  final bool showUserInfoIcon;
  final VwLinkNode? detailLinkFormDefinition;
  final VwFormDefinition? detailFormDefinition;
  final String detailFormDefinitionMode;
  final VwDataSourceDefinition dataSource;
  final bool enableCreateRecord;
  final bool showBackArrow;
  final String? detailFormDefinitionId;
  List<VwLinkNode>? staticRefLinkNodeList;




  factory VwCollectionListViewDefinition.fromJson(
          Map<String, dynamic> json) =>
      _$VwCollectionListViewDefinitionFromJson(json);
  Map<String, dynamic> toJson() =>
      _$VwCollectionListViewDefinitionToJson(this);
}
