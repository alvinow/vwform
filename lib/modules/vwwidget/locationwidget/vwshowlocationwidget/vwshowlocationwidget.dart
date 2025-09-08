import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:matrixclient2base/modules/base/vwdataformat/vwrowdata/vwrowdata.dart';
import 'package:vwutil/modules/util/vwfluttermaputil.dart';


class VwShowLocationWidget extends StatefulWidget {
  VwShowLocationWidget({required this.location});

  VwRowData location;

  VwShowLocationWidgetState createState() => VwShowLocationWidgetState();
}

class VwShowLocationWidgetState extends State<VwShowLocationWidget> {
  late final MapController _mapController;
  late double latitude;
  late double longitude;

  late final customMarkers;

  Marker buildPin(LatLng point) => Marker(
        point: point,
        child: const Icon(Icons.location_pin, size: 60, color: Colors.red),
        width: 60,
        height: 60,
      );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    latitude =
        double.parse(widget.location.getFieldByName("latitude")!.valueString!);
    longitude =
        double.parse(widget.location.getFieldByName("longitude")!.valueString!);

    customMarkers = <Marker>[buildPin(LatLng(latitude, longitude))];
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    String displayMode = "pointAndPolygon";

    try {
      displayMode = widget.location.getFieldByName("displaymode")!.valueString!;
    } catch (error) {}

    List<Widget> flutterMapWidgetList = [];

    flutterMapWidgetList.add(
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      ),
    );

    if (displayMode == "polygon" || displayMode == "pointAndPolygon") {
      try {
        flutterMapWidgetList.add(
          PolygonLayer(
            polygons: [
              Polygon(
                points: widget.location.getFieldByName("polygon") != null
                    ? VwFlutterMapUtil.createPointsFromLocationLinkNodeList(
                        widget.location
                            .getFieldByName("polygon")!
                            .valueLinkNodeList!)
                    : [],
                color: Colors.greenAccent.withAlpha(50),
                borderStrokeWidth: 4,
                borderColor: Colors.greenAccent,
              ),
            ],
          ),
        );
      } catch (error) {}
    }

    if (displayMode == "point" || displayMode == "pointAndPolygon") {
      try {
        flutterMapWidgetList.add(MarkerLayer(
          markers: customMarkers,
          //rotate: counterRotate,
          //anchorPos: AnchorPos.align(anchorAlign),
        ));
      } catch (error) {}
    }

    Widget body = FlutterMap(
        mapController: _mapController,
        options: MapOptions(

          initialCenter: LatLng(latitude, longitude),
          //enableMultiFingerGestureRace: true,
          initialZoom: 18,
          maxZoom: 18,
          minZoom: 5,
        ),
        children: flutterMapWidgetList);

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.location.getFieldByName("title")!.valueString!),
        ),
        body: body);
  }
}
