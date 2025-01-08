

import 'package:vwform/modules/vwform/vwformdefinition/vwformdefinition.dart';

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