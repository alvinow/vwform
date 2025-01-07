import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class VwMobileScanner extends StatefulWidget {
VwMobileScanner({required this.key});

Key key;

VwMobileScannerState createState()=> VwMobileScannerState();

}
class VwMobileScannerState extends State<VwMobileScanner>{

  late bool hasDetected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.hasDetected=false;
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(


        controller: MobileScannerController(

          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
          torchEnabled: false,
        ),
        key: this.widget.key,
        // fit: BoxFit.contain,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          // final Uint8List? image = capture.image;
          if ( barcodes.length>0 ) {

            if(this.hasDetected==false) {
              Barcode barcode=barcodes.elementAt(0);
              this.hasDetected=true;
              Navigator.pop(context, barcode.rawValue);
            }

          }
        },
      ),
    );
  }
}