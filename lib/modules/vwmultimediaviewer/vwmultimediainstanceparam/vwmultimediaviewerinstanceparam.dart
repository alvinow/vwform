import 'package:flutter/material.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:matrixclient2base/modules/base/vwencodedfile/vwencodedfile.dart';
import 'package:matrixclient2base/modules/base/vwfilestorage/vwfilestorage.dart';


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