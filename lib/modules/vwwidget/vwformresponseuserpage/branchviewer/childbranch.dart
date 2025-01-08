import 'package:flutter/cupertino.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';

class ChildBranch {

  ChildBranch({this.hideExpandedButton=false, this.depth=1,this.isInitiallyExpanded=false, required this.createRecordButtonList, required this.branchNodeId,  this.leftMargin=30, this.depth1FilterObject=const{},this.showCreateButton=false,this.showDeleteButton=false});
  final dynamic depth1FilterObject;
  final double leftMargin;
  final String branchNodeId;
  final bool showCreateButton;
  final bool showDeleteButton;
   bool isInitiallyExpanded;
   bool hideExpandedButton;
  final int depth;
  List<CreateRecordButtonChildBranch> createRecordButtonList;
}

class CreateRecordButtonChildBranch{
  CreateRecordButtonChildBranch({
    required this.title,
    required this.icon,
    this.createRecordFormDefinitionId,
    this.newRecordPresetValues
});

  final String title;
  final IconData icon;
  final String? createRecordFormDefinitionId;
  final VwRowData? newRecordPresetValues;
}
