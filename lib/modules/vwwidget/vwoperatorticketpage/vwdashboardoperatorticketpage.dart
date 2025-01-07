import 'package:flutter/cupertino.dart';
import 'package:matrixclient/modules/base/vwappinstanceparam/vwappinstanceparam.dart';
import 'package:matrixclient/modules/vwwidget/chartnodelistview/chartnodelistview.dart';

class VwDashboardOperatorTicketPage extends StatelessWidget{
  VwDashboardOperatorTicketPage({
    required this.appInstanceParam
});

  final VwAppInstanceParam appInstanceParam;

  @override
  Widget build(BuildContext context) {
    return ChartNodeListView(

      folderNodeId: "f498df14-a537-4991-9d7c-7dc232b89f3c",
      pageTitleCaption: "Dashboard",
      key: UniqueKey(),
      appInstanceParam: this.appInstanceParam,
    );
  }
}