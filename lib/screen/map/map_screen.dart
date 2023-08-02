import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:gas_app/model/gas_type.dart';
import 'package:gas_app/service/gas_type_service.dart';
import '../../constants.dart';
import '../../model/gas_station.dart';
import '../../model/get_gas_types.dart';
import '../../service/api_service.dart';
import '../../service/gas_station_service.dart';
import '../../widget/gas_station_marker.dart';
import '../../widget/gas_station_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import '../../widget/scale_layer.dart';

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
  int nbGasTypes = -1;
  LatLng currentCenter = const LatLng(48.764977, 2.358192);

  late List<Marker> markers = [];
  final gasStationService = GasStationService();
  final gasTypeService = GasTypeService();
  final apiService = ApiService();

  late GetGasTypes gasTypes = GetGasTypes(gasTypes: [], totalItems: 0, statusCode: -1);
  late String favoriteGasTypeId = '';
  String? selected;

  @override
  void initState() {
    super.initState();

    apiService.getFavoriteGasType().then((value) {
      selected = (value == 'null' || value == null ? '1' : value);
      getGasStationsMap(currentCenter.latitude, currentCenter.longitude, 50000, selected);
    });

    gasTypeService.getGasTypes().then((value) {
      gasTypes = value;
    });

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

  getGasStationsMap(double latitude, double longitude, double radius, String? gasType) {
    gasStationService.getGasStationsMap(currentCenter.latitude, currentCenter.longitude, 50000, gasType).then(
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
    const RoundedRectangleBorder cZoomIn = RoundedRectangleBorder(
        side: BorderSide(width: 0.0), borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)));
    const RoundedRectangleBorder cZoomOut = RoundedRectangleBorder(
        side: BorderSide(width: 0.0), borderRadius: BorderRadius.only(bottomRight: Radius.circular(8.0), bottomLeft: Radius.circular(8.0)));

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
                        ScaleLayerWidget(
                          options: ScaleLayerPluginOption(
                            lineColor: const Color.fromARGB(255, 0, 0, 0),
                            lineWidth: 2,
                            textStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12),
                            padding: const EdgeInsets.only(top: 50, left: 10),
                          ),
                        ),
                        getGasTypesWidget(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 120, right: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  height: 30.0,
                                  width: 40.0,
                                  padding: const EdgeInsets.only(right: 10),
                                  child: FloatingActionButton(
                                    shape: ShapeBorder.lerp(cZoomIn, null, 0.0),
                                    heroTag: 'zoomInButton',
                                    mini: true,
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        if (currentZoom < maxZoom) {
                                          currentZoom = currentZoom + 1;
                                        }
                                      });
                                      mapController.move(currentCenter, currentZoom);
                                    },
                                    child: Icon(Icons.add, color: IconTheme.of(context).color),
                                  ),
                                ),
                                Container(
                                  height: 30.0,
                                  width: 40.0,
                                  padding: const EdgeInsets.only(right: 10),
                                  child: FloatingActionButton(
                                    shape: ShapeBorder.lerp(cZoomOut, null, 0.0),
                                    heroTag: 'zoomOutButton',
                                    mini: true,
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        if (currentZoom > minZoom) {
                                          currentZoom = currentZoom - 1;
                                        }
                                      });
                                      mapController.move(currentCenter, currentZoom);
                                    },
                                    child: Icon(Icons.remove, color: IconTheme.of(context).color),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      options: MapOptions(
                        center: currentCenter,
                        onSecondaryTap: (tapPosition, point) => {print('here')},
                        maxZoom: maxZoom,
                        minZoom: minZoom,
                        onTap: (_, __) => popupLayerController.hideAllPopups(),
                        zoom: currentZoom,
                        onMapEvent: (mapEvent) {
                          if (mapEvent is MapEventDoubleTapZoomEnd) {
                            setState(() {
                              if (currentZoom < maxZoom) {
                                currentZoom = mapEvent.zoom;
                              }
                              currentCenter = mapEvent.center;
                            });
                            mapController.move(currentCenter, currentZoom);
                          }
                          debugPrint(mapEvent.toString());
                        },
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

  Widget getGasTypesWidget() {
    List<Widget> items = List.generate(
      gasTypes.totalItems,
      (int index) {
        GasType gasType = gasTypes.gasTypes[index];
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: GestureDetector(
            onTap: () {
              apiService.setFavoriteGasType(gasType.id);
              debugPrint(gasType.name);
            },
            child: Image.network(
              Constants.baseUrl + gasType.imagePath,
              width: 45,
              height: 45,
            ),
          ),
        );
      },
    ).toList();

    
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, right: 8),
        child: Column(
          children: items,
        ),
      ),
    );
  }
}
