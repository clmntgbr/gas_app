import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:gas_app/model/gas_station.dart';
import 'package:gas_app/service/gas_station_service.dart';
import 'package:gas_app/widget/gas_station_marker.dart';
import 'package:gas_app/widget/gas_station_marker_popup.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  final ScrollController scrollController = ScrollController();
  final PopupController _popupLayerController = PopupController();
  final mapController = MapController();

  double currentZoom = 15.0;
  double topBarOpacity = 0.0;
  LatLng currentCenter = const LatLng(48.764977, 2.358192);

  late List<Marker> markers = [];
  final gasStationService = GasStationService();

  @override
  void initState() {
    super.initState();

    getGasStationsMap(currentCenter.latitude, currentCenter.longitude, 50000);

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController!,
        curve: const Interval(
          0,
          0.5,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    scrollController.addListener(
      () {
        if (scrollController.offset >= 24) {
          if (topBarOpacity != 1.0) {
            setState(
              () {
                topBarOpacity = 1.0;
              },
            );
          }
        } else if (scrollController.offset <= 24 && scrollController.offset >= 0) {
          if (topBarOpacity != scrollController.offset / 24) {
            setState(
              () {
                topBarOpacity = scrollController.offset / 24;
              },
            );
          }
        } else if (scrollController.offset <= 0) {
          if (topBarOpacity != 0.0) {
            setState(
              () {
                topBarOpacity = 0.0;
              },
            );
          }
        }
      },
    );
  }

  getGasStationsMap(double latitude, double longitude, double radius) {
    gasStationService.getGasStationsMap(currentCenter.latitude, currentCenter.longitude, 50000).then(
      (value) {
        markers = [];
        for (GasStation element in value.gasStations) {
          markers.add(
            addMarker(element, element.hasLowPrices),
          );
        }
        setState(() {});
      },
    );
  }

  Marker addMarker(GasStation gasStation, bool hasLowPrices) {
    return GasStationMarker(
      gasStation: gasStation,
      hasLowPrices: hasLowPrices,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupScope(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    child: FlutterMap(
                      options: MapOptions(
                        center: currentCenter,
                        onTap: (_, __) => _popupLayerController.hideAllPopups(),
                        zoom: currentZoom,
                        onMapEvent: (mapEvent) {},
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        PopupMarkerLayer(
                          options: PopupMarkerLayerOptions(
                            markerCenterAnimation: const MarkerCenterAnimation(),
                            markers: markers,
                            popupController: _popupLayerController,
                            markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
                            onPopupEvent: (event, selectedMarkers) {
                              showModalBottomSheet(
                                elevation: 0,
                                barrierColor: Colors.black.withAlpha(1),
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  debugPrint(selectedMarkers.toString());
                                  if (selectedMarkers.isEmpty) {
                                    return Container();
                                  }
                                  var marker = selectedMarkers.first;
                                  if (marker is GasStationMarker) {
                                    return GasStationMarkerPopup(
                                      gasStation: marker.gasStation,
                                    );
                                  }
                                  return Container();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
