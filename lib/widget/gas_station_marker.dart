import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../model/gas_station.dart';
import 'package:latlong2/latlong.dart';

class GasStationMarker extends Marker {
  final GasStation gasStation;
  final bool hasLowPrices;

  GasStationMarker({required this.gasStation, required this.hasLowPrices})
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.top),
          height: 45,
          width: 45,
          point: LatLng(
            double.parse(gasStation.address.latitude),
            double.parse(gasStation.address.longitude),
          ),
          builder: (BuildContext ctx) => Image.asset(
            hasLowPrices ? 'assets/marker/marker_low.png' : 'assets/marker/marker.png',
          ),
        );
}
