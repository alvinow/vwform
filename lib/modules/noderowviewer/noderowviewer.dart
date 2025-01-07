import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwlinknode/vwlinknode.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwcollectionlistviewdefinition/vwcollectionlistviewdefinition.dart';
import 'package:vwform/modules/vwform/vwform.dart';


typedef UpdateSelectedState = void Function(bool selected,VwNode node);



class NodeRowViewer extends StatelessWidget{
  NodeRowViewer({
    required this.appInstanceParam,
    super.key,
    required this.rowNode,
    required this.highlightedText,
    this.topRowWidget,
    this.refreshDataOnParentFunction,
    this.refreshDataOnParentRecordFunction,
    this.collectionListViewDefinition,
    this.updateSelectedState,
    this.selectedList,
    this.selectedIcon,
    this.unselectedIcon,
    this.rowViewerBoxContraints,
    this.commandToParentFunction,
    this.localeId="id_ID",

});
  final VwAppInstanceParam appInstanceParam;

  final VwNode rowNode;
  final List<VwLinkNode>? selectedList;
  final String? highlightedText;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  final RefreshDataOnParentFunction? refreshDataOnParentRecordFunction;
  final VwCollectionListViewDefinition? collectionListViewDefinition;
  final UpdateSelectedState? updateSelectedState;
  final Icon? selectedIcon;
  final Icon? unselectedIcon;
  final Widget? topRowWidget ;
  final BoxConstraints? rowViewerBoxContraints;
  final CommandToParentFunction? commandToParentFunction;
  final String localeId;



  @override
  Widget build(BuildContext context) {
    return Container(child: Text("(Unimplemented Error)"));
  }
}