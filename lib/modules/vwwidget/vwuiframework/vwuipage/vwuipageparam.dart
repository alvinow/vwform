
import 'package:vwform/modules/vwwidget/vwuiframework/vwuipagebodycomponent/vwuipagebodycomponentparam.dart';
import 'package:vwform/modules/vwwidget/vwuiframework/vwuipagelink/vwuipagelink.dart';

class VwUiPageParam{
  VwUiPageParam({
  required this.recordId,
    required this.tabPages,
    this.bubbleButtons,
    this.actionButtons
});

  String recordId;
  String? caption;
  List<VwUiPageBodyComponentParam> tabPages;
  List<VwUiPageLink>? bubbleButtons;
  List<VwUiPageLink>? actionButtons;

}