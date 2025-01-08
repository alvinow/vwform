part of 'fileviewer_bloc.dart';

abstract class FileviewerEvent extends Equatable {
  FileviewerEvent();

  @override
  List<Object> get props => [];
}

class BootstrapFileviewerEvent extends FileviewerEvent {
  BootstrapFileviewerEvent({required this.timestamp});

  final DateTime timestamp;

  @override
  List<Object> get props => [timestamp];
}

class LoadFileviewerEvent extends FileviewerEvent {
  LoadFileviewerEvent({required this.timestamp});

  final DateTime timestamp;

  @override
  List<Object> get props => [timestamp];
}

