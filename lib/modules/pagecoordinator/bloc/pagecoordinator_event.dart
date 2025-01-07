part of 'pagecoordinator_bloc.dart';

abstract class PagecoordinatorEvent extends Equatable {
  PagecoordinatorEvent();

  @override
  List<Object> get props => [];
}

class BootstrapPagecoordinatorEvent extends PagecoordinatorEvent {
  BootstrapPagecoordinatorEvent({required this.timestamp, this.goRouterState, this.url});

  final DateTime timestamp;
  final String? url;
  GoRouterState? goRouterState;

  @override
  List<Object> get props => [timestamp];
}

class HomePagecoordinatorEvent extends PagecoordinatorEvent {
  HomePagecoordinatorEvent({required this.timestamp});

  final DateTime timestamp;

  @override
  List<Object> get props => [timestamp];
}

class PublicLandingPagecoordinatorEvent extends PagecoordinatorEvent {
  PublicLandingPagecoordinatorEvent({ required this.timestamp,this.standardArticleMaincategory="beranda"});

  final DateTime timestamp;
  final String standardArticleMaincategory;


  @override
  List<Object> get props => [timestamp];
}

class LoginPagecoordinatorEvent extends PagecoordinatorEvent {
  LoginPagecoordinatorEvent({required this.timestamp});

  final DateTime timestamp;

  @override
  List<Object> get props => [timestamp];
}

class AuthorizePagecoordinatorEvent extends PagecoordinatorEvent {
  AuthorizePagecoordinatorEvent(
      {required this.timestamp, required this.paramAuthorize});

  final DateTime timestamp;
  final VwRowData paramAuthorize;

  @override
  List<Object> get props => [timestamp, paramAuthorize];
}

class CheckauthorizationPagecoordinatorEvent extends PagecoordinatorEvent {
  CheckauthorizationPagecoordinatorEvent({required this.timestamp});

  final DateTime timestamp;

  @override
  List<Object> get props => [timestamp];
}

class LogoutPagecoordinatorEvent extends PagecoordinatorEvent {
  LogoutPagecoordinatorEvent({required this.timestamp});

  final DateTime timestamp;



  @override
  List<Object> get props => [timestamp];
}
