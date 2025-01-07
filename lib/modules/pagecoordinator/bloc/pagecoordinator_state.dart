part of 'pagecoordinator_bloc.dart';

abstract class PagecoordinatorState extends Equatable {
  PagecoordinatorState();

  @override
  List<Object> get props => [];
}

class BootupPagecoordinatorState extends PagecoordinatorState {}

class InitsplashscreenPagecoordinatorState extends PagecoordinatorState {
  InitsplashscreenPagecoordinatorState({required this.initsplashscreenParam});

  final VwRowData initsplashscreenParam;
  @override
  List<Object> get props => [initsplashscreenParam];
}

class LoadingPagecoordinatorState extends PagecoordinatorState {
  LoadingPagecoordinatorState({required this.loadingParam});

  final VwRowData loadingParam;
  @override
  List<Object> get props => [loadingParam];
}

class UserRvspTicketPagePagecoordinatorState extends PagecoordinatorState{
  UserRvspTicketPagePagecoordinatorState({required this.ticketCode,this.ticketNode});

  final String ticketCode;
  final VwNode? ticketNode;
  @override
  List<Object> get props => [ticketCode];
}

class RegInfoPagePagecoordinatorState extends PagecoordinatorState{
  RegInfoPagePagecoordinatorState({required this.regCode,this.regInfoNode});
  final String regCode;
  final VwNode? regInfoNode;
  @override
  List<Object> get props => [regCode];
}



class PublicLandingPagePagecoordinatorState extends PagecoordinatorState {
  PublicLandingPagePagecoordinatorState({this.loginResponse,required this.standardArticleMaincategory});

  final VwLoginResponse? loginResponse;
  final String standardArticleMaincategory;
  @override
  List<Object> get props => [standardArticleMaincategory];
}

class LoginPagecoordinatorState extends PagecoordinatorState {
  LoginPagecoordinatorState({required this.loginParam});

  final VwRowData loginParam;
  @override
  List<Object> get props => [loginParam];
}

class ViewArticleState extends PagecoordinatorState {
  ViewArticleState({required this.articleId, this.loginResponse, this.mediaPointer,this.autoplay=false});

  final VwLoginResponse? loginResponse;
  final String articleId;
  final VwRowData? mediaPointer;
  final bool autoplay;

  @override
  List<Object> get props => [articleId];
}

class HomePagecoordinatorState extends PagecoordinatorState {
  HomePagecoordinatorState({required this.homeParam,required this.loginResponse});

  final VwRowData homeParam;
  final VwLoginResponse loginResponse;
  @override
  List<Object> get props => [homeParam];
}

class NewFormRecordState extends PagecoordinatorState{
  NewFormRecordState({required this.containerFolderNode, required this.loginResponse, required this.formResponse, required this.formDefinition });

 final VwLoginResponse loginResponse;
 final VwRowData formResponse;
 final VwFormDefinition formDefinition;
 final VwNode containerFolderNode;

}
