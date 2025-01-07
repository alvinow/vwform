import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient/modules/base/vwnode/vwnode.dart';
import 'package:matrixclient/modules/edokumen2022/uiwidget/vwuserdrawer/vwuserdrawer.dart';
import 'package:matrixclient/modules/vwwidget/vwformsubmitpage/vwformsubmitrowviewer.dart';
import 'package:matrixclient/modules/util/vwdateutil.dart';
import 'package:matrixclient/modules/vwnodestoreonhive/vwnodestoreonhive.dart';
import 'package:matrixclient/modules/adminpages/vwuserspage/vwuserrowviewer.dart';
import 'package:matrixclient/modules/vwwidget/nodelistview/modules/vwnodelistviewrdefaultfilterparam/vwnodelistviewdefaultfilterparam.dart';
import 'package:matrixclient/modules/vwwidget/nodelistview/nodelistview.dart';
import 'package:uuid/uuid.dart';

class VwUserNotificationPage extends StatelessWidget {
  VwUserNotificationPage(
      {required this.appInstanceParam,
        this.refreshDataOnParentFunction
      });

  final VwAppInstanceParam appInstanceParam;

  final RefreshDataOnParentFunction? refreshDataOnParentFunction;



  Widget nodeRowViewer(
      {required VwNode renderedNode,
        required BuildContext context,
        required int index,
        Widget? topRowWidget,
        String? highlightedText,
        RefreshDataOnParentFunction? refreshDataOnParentFunction,
        CommandToParentFunction? commandToParentFunction
      }) {
    return VwUserRowViewer(appInstanceParam: appInstanceParam,
        rowNode: renderedNode, highlightedText: highlightedText,refreshDataOnParentFunction: this.refreshDataOnParentFunction);
  }

  Widget uploadIconButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.cloud_upload),
      tooltip: 'Uploading Data...',
      onPressed: () async {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Uploading Data...')));

        await VwNodeStoreOnHive(boxName: AppConfig.unsyncedRecordFieldname)
            .syncToServer(loginSessionId: this.appInstanceParam.loginResponse!.loginSessionId!);
      },
    );
  }



  void modifyParamFunction(VwRowData apiCallParam) {}

  @override
  Widget build(BuildContext context) {
    final VwRowData apiCallParam = VwRowData(timestamp: VwDateUtil .nowTimestamp(),recordId: Uuid().v4(),fields: <VwFieldValue>[
      VwFieldValue(fieldName: "nodeId",valueString: "b2a4dc48-3310-4dda-b2d6-6d1803f556ad"),
      VwFieldValue(fieldName: "depth",valueNumber: 1),
      VwFieldValue(fieldName: "depth1FilterObject",valueTypeId: VwFieldValue.vatObject,value: {"contentClassName":"VwUserNotification"})
    ]);

    return NodeListView(
      appInstanceParam: appInstanceParam,

        apiCallId: "getNodes",
        zeroDataCaption: "(No notification)",
        mainLogoTextCaption: "Notification",
        mainLogoMode: NodeListView.mlmText,
        showBackArrow: true,
        nodeRowViewerFunction: nodeRowViewer,
        apiCallParam: apiCallParam,
        );
  }
}
