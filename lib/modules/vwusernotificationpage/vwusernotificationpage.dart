import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:uuid/uuid.dart';
import 'package:vwform/modules/adminpages/vwuserspage/vwuserrowviewer.dart';
import 'package:vwform/modules/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:vwform/modules/vwform/vwform.dart';
import 'package:vwutil/modules/util/vwdateutil.dart';

class VwUserNotificationPage extends StatelessWidget {
  VwUserNotificationPage(
      {required this.appInstanceParam,
        this.refreshDataOnParentFunction,
        required this.baseUrl
      });

  final VwAppInstanceParam appInstanceParam;
  final String baseUrl;

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
    return VwUserRowViewer (appInstanceParam: appInstanceParam,
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
      baseUrl:this.baseUrl,
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
