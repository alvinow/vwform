
import 'package:vwform/modules/vwwidget/vwuiframework/vwuipage/vwuipageparam.dart';

class VwUiDeployParam {
  VwUiDeployParam({this.bootIndex = 0, required this.uiPages});

  int bootIndex;
  List<VwUiPageParam> uiPages;
}
