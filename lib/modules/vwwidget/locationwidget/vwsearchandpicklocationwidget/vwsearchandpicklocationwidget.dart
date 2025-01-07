/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrixclient/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:matrixclient/modules/vwwidget/locationwidget/vwsearchandpicklocationwidget/locationservice.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class VwSearchAndPickLocationWidget extends StatefulWidget{
  VwSearchAndPickLocationWidget({required this.location});

  VwRowData location;
  VwLocationWidgetState createState()=>VwLocationWidgetState();
}
class VwLocationWidgetState extends State<VwSearchAndPickLocationWidget>{
  late LocationService locationService = LocationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationService = LocationService();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold (

        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.location.getFieldByName("title")!.valueString!),
        ),
        body: OpenStreetMapSearchAndPick (
          buttonTextStyle:
          const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
          center:  LatLong(double.parse(widget.location.getFieldByName("latitude")!.valueString!) , double.parse(widget.location.getFieldByName("longitude")!.valueString!)),
          buttonColor: Colors.blue,
          buttonText: 'Set Current Location',
          onPicked: (pickedData) {
            print(pickedData.latLong.latitude);
            print(pickedData.latLong.longitude);
            print(pickedData.address);
            print(pickedData.addressName);
          },
          onGetCurrentLocationPressed: locationService.getPosition,
        ));
  }
}

 */