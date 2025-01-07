import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwform/vwformdefinition/vwformdefinition.dart';
import 'package:matrixclient/modules/vwwidget/nodelistview/nodelistview.dart';

class VwUiPageBodyComponentDetailNodeParam{
  VwUiPageBodyComponentDetailNodeParam({
    required this.formParam,
    this.enableCreateUserGroupIds,
    this.enableUpdateUserGroupIds,
    this.enableDeleteUserGroupIds,
    this.enableCreate=false,
    this.enableUpdate=false,
    this.enableDelete=false
});

  VwFormDefinition formParam;
  List<String>? enableCreateUserGroupIds;
  List<String>? enableUpdateUserGroupIds;
  List<String>? enableDeleteUserGroupIds;
  bool enableCreate;
  bool enableUpdate;
  bool enableDelete;
}