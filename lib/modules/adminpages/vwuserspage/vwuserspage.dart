import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrixclient/appconfig.dart';
import 'package:matrixclient/modules/adminpages/vwuserspage/vwuserrowviewer.dart';
import 'package:matrixclient/modules/util/vwdateutil.dart';
import 'package:matrixclient/modules/vwnodestoreonhive/vwnodestoreonhive.dart';
import 'package:matrixclient/modules/vwwidget/nodelistview/nodelistview.dart';
import 'package:matrixclient2base/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient2base/modules/base/vwnode/vwnode.dart';
import 'package:uuid/uuid.dart';

class VwUsersPage extends StatelessWidget {
  VwUsersPage(
      {required this.appInstanceParam,
        required this.parentBloc,
        this.refreshDataOnParentFunction
      });

  final VwAppInstanceParam appInstanceParam;
  final Bloc parentBloc;
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
    return VwUserRowViewer(appInstanceParam: this.appInstanceParam,
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

    final VwRowData apiCallParam = VwRowData(timestamp: VwDateUtil.nowTimestamp(),creatorUserId: AppConfig.invalidUserId, recordId: Uuid().v4(),fields: <VwFieldValue>[
      VwFieldValue(fieldName: "nodeId",valueString: "e827de48-8404-4dbe-9cc5-7d5b2ca7ffb1"),
      VwFieldValue(fieldName: "depth",valueNumber: 1),
      VwFieldValue(fieldName: "depth1FilterObject",valueTypeId: VwFieldValue.vatObject,value: {"content.contentContext.contentClassName":"VwUser"})
    ]);

    return NodeListView(
appInstanceParam: this.appInstanceParam,

        apiCallId: "getNodes",

        nodeRowViewerFunction: nodeRowViewer,
        apiCallParam: apiCallParam,


        );
  }
}
