import 'package:flutter/cupertino.dart';
import 'package:vwform/modules/noderowviewer/noderowviewer.dart';

class VwUserMemberOfGroupRowViewer extends NodeRowViewer {
  VwUserMemberOfGroupRowViewer(
      {
        super.key,
        required super.rowNode,
        required super.appInstanceParam,
        super.highlightedText,super.refreshDataOnParentFunction,
      });



  @override
  Widget build(BuildContext context) {
    Widget returnValue = Text(rowNode.recordId);
    return returnValue;
  }
}