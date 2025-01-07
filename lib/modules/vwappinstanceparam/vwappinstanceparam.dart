

import 'package:matrixclient2base/modules/base/pagecoordinator/bloc/pagecoordinator_bloc.dart';
import 'package:matrixclient2base/modules/base/vwloginresponse/vwloginresponse.dart';

class VwAppInstanceParam{
  VwAppInstanceParam({
    this.loginResponse,
    required this.appBloc,

});
  final VwLoginResponse? loginResponse;
  final PagecoordinatorBloc appBloc;

}