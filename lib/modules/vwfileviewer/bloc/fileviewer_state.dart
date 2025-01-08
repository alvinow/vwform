part of 'fileviewer_bloc.dart';

abstract class FileviewerState extends Equatable {
  FileviewerState();

  @override
  List<Object> get props => [];
}

class BootupFileviewerState extends FileviewerState {}

class LoadingFileviewerState extends FileviewerState {
  @override
  List<Object> get props => [];
}

class LoadFailedFileviewerState extends FileviewerState {
  @override
  List<Object> get props => [];
}

class DisplayContentInYoutubeVideoIdFileviewerState extends FileviewerState {
  DisplayContentInYoutubeVideoIdFileviewerState({required this.videoIds});

  final List<String> videoIds;

  @override
  List<Object> get props => [];
}

class DisplayContentInFileFileviewerState extends FileviewerState {
  DisplayContentInFileFileviewerState({required this.fileLink, required this.fileStorage,  this.metadata=const {}});

  final File fileLink;
  VwFileStorage fileStorage;
  Map<String, dynamic> metadata;

  @override
  List<Object> get props => [];
}

class DisplayContentInMemoryFileviewerState extends FileviewerState {
  DisplayContentInMemoryFileviewerState({required this.fileInMemory,  required this.fileStorage, this.metadata=const {}});

  final Uint8List fileInMemory;
  final VwFileStorage fileStorage;
  Map<String, dynamic> metadata;

  @override
  List<Object> get props => [];
}
