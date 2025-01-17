import 'package:matrixclient2base/appconfig.dart';
import 'package:matrixclient2base/modules/base/vwloginresponse/vwloginresponse.dart';
import 'package:vwform/modules/pagecoordinator/bloc/pagecoordinator_bloc.dart';


class VwAppInstanceParam{
  VwAppInstanceParam({
    this.loginResponse,
    required this.appBloc,
    required this.baseAppConfig

});
  final VwLoginResponse? loginResponse;
  final PagecoordinatorBloc appBloc;
  final BaseAppConfig baseAppConfig;
}