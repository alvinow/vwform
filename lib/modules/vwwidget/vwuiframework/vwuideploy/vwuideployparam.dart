import 'package:matrixclient/modules/vwwidget/vwuiframework/vwuipage/vwuipage.dart';
import 'package:matrixclient/modules/vwwidget/vwuiframework/vwuipage/vwuipageparam.dart';

class VwUiDeployParam {
  VwUiDeployParam({this.bootIndex = 0, required this.uiPages});

  int bootIndex;
  List<VwUiPageParam> uiPages;
}
