import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwfiedvalue/vwfieldvalue.dart';
import 'package:path/path.dart';
import 'package:qr_flutter/qr_flutter.dart';


class VwQrCodePage extends StatefulWidget{

  VwQrCodePage({
    required this.data,
    required this.title,
    this.useAsComponentWidget=false
  });

  final String data;
  final String title;
  final bool useAsComponentWidget;

  _VwQrCodePageState createState()=>_VwQrCodePageState();
}
class _VwQrCodePageState extends State<VwQrCodePage>{

  @override
  Widget build(BuildContext context) {
    return Text("Vw QR Code Page not implemented");
  }

}