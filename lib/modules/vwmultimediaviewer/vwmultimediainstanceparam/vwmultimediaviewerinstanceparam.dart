import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient/modules/base/vwencodedfile/vwencodedfile.dart';
import 'package:matrixclient/modules/base/vwfilestorage/vwfilestorage.dart';
import 'package:matrixclient/modules/base/vwloginresponse/vwloginresponse.dart';

class VwMultimediaViewerInstanceParam{
  VwMultimediaViewerInstanceParam({
    required this.remoteSource,
    required this.fileSource,
    required this.memorySource,
    this.tagFieldvalue,
    this.caption,

    this.icon=const Icon(Icons.file_present)
});

  final List<VwFileStorage> remoteSource;
  final List<VwEncodedFile> fileSource;
  final List<VwEncodedFile> memorySource;
  final VwFieldValue? tagFieldvalue;
  final Icon? icon;
  final String? caption;

}