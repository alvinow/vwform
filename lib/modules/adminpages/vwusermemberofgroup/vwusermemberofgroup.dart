import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:nodelistview/modules/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/adminpages/vwusermemberofgroup/vwusermemberofgrouprowviewer/vwusermemberofgrouprowviewer.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwUserMemberOfGroup extends StatelessWidget {
  const VwUserMemberOfGroup(
      {super.key,
      required this.appInstanceParam,
      required this.parentBloc,
      this.refreshDataOnParentFunction,
      this.currentParentLocalNodeRecords
      });

  final VwAppInstanceParam appInstanceParam;
  final Bloc parentBloc;
  final RefreshDataOnParentFunction? refreshDataOnParentFunction;
  final List<VwNode>? currentParentLocalNodeRecords;

  Widget nodeRowViewer(
      {required VwNode  renderedNode,
        required BuildContext context,
        required int index,
        Widget? topRowWidget,
      String? highlightedText,
      RefreshDataOnParentFunction? refreshDataOnParentFunction,
        List<VwNode>? currentParentLocalNodeRecords,
        CommandToParentFunction? commandToParentFunction
      }) {
    return VwUserMemberOfGroupRowViewer(
        appInstanceParam: this.appInstanceParam,
        rowNode: renderedNode,
        highlightedText: highlightedText,
        refreshDataOnParentFunction: this.refreshDataOnParentFunction);
  }

  void modifyParamFunction(VwRowData apiCallParam) {}

  @override
  Widget build(BuildContext context) {
    final VwRowData apiCallParam = VwRowData(
        timestamp: VwDateUtil.nowTimestamp(),
        recordId: const Uuid().v4(),
        creatorUserId: "<invalid_user_id>",
        fields: <VwFieldValue>[
          VwFieldValue(
              fieldName: "nodeId",
              valueString: "e827de48-8404-4dbe-9cc5-7d5b2ca7ffb1"),
          VwFieldValue(fieldName: "depth", valueNumber: 1),
          VwFieldValue(
              fieldName: "depth1FilterObject",
              valueTypeId: VwFieldValue.vatObject,
              value: {"contentClassName": "VwUser"})
        ]);

    return NodeListView(
      appInstanceParam: this.appInstanceParam,
      apiCallId: "getNodes",


      nodeRowViewerFunction: nodeRowViewer,
      apiCallParam: apiCallParam,
    );
  }
}
