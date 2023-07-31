import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import '../../model/gas_station.dart';
import '../../service/gas_station_service.dart';
import '../../widget/gas_station_marker.dart';
import '../../widget/gas_station_marker_popup.dart';
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
  final PopupController popupLayerController = PopupController();
  final MapController mapController = MapController();

  double currentZoom = 12.0;
  double minZoom = 5;
  double maxZoom = 18;
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
                      mapController: mapController,
                      nonRotatedChildren: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: FloatingActionButton(
                                  heroTag: 'zoomInButton',
                                  mini: true,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    setState(() {
                                      if (currentZoom < maxZoom) {
                                        currentZoom = currentZoom + 1;
                                      }
                                    });
                                    mapController.move(currentCenter, currentZoom);
                                  },
                                  child: Icon(Icons.zoom_in, color: IconTheme.of(context).color),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: FloatingActionButton(
                                  heroTag: 'zoomOutButton',
                                  mini: true,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    setState(() {
                                      if (currentZoom > minZoom) {
                                        currentZoom = currentZoom - 1;
                                      }
                                    });
                                    mapController.move(currentCenter, currentZoom);
                                  },
                                  child: Icon(Icons.zoom_out, color: IconTheme.of(context).color),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      options: MapOptions(
                        center: currentCenter,
                        maxZoom: maxZoom,
                        minZoom: minZoom,
                        onTap: (_, __) => popupLayerController.hideAllPopups(),
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
                            popupController: popupLayerController,
                            // markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
                            markerTapBehavior: MarkerTapBehavior.custom(
                              (popupSpec, popupState, popupController) => {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  elevation: 0,
                                  barrierColor: Colors.black.withAlpha(1),
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    var marker = popupSpec.marker;
                                    if (marker is GasStationMarker) {
                                      return GasStationMarkerPopup(
                                        gasStation: marker.gasStation,
                                      );
                                    }
                                    return const Card(
                                      child: Text('Not a gasStation'),
                                    );
                                  },
                                )
                              },
                            ),
                            // onPopupEvent: (event, selectedMarkers) {
                            //   debugPrint(selectedMarkers.toString());
                            //   if (selectedMarkers.isEmpty) {
                            //     debugPrint('closing');
                            //     return;
                            //   }
                            //   var marker = selectedMarkers.first;
                            //   if (marker is GasStationMarker) {
                            //     debugPrint('open');
                            //     showModalBottomSheet(
                            //       elevation: 0,
                            //       clipBehavior: Clip.antiAlias,
                            //       useSafeArea: true,
                            //       barrierColor: Colors.black.withAlpha(1),
                            //       backgroundColor: Colors.transparent,
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return GasStationMarkerPopup(
                            //           gasStation: marker.gasStation,
                            //         );
                            //       },
                            //     );
                            //     selectedMarkers = [];
                            //   }
                            // },
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
