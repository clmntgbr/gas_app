import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import '../../model/gas_type.dart';
import '../../service/gas_type_service.dart';
import '../../constants.dart';
import '../../model/gas_station.dart';
import '../../model/get_gas_types.dart';
import '../../service/api_service.dart';
import '../../service/gas_station_service.dart';
import '../../widget/gas_station_marker.dart';
import '../../widget/gas_station_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import '../../widget/scale_layer.dart';
import 'dart:async';

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
  late double distance;

  bool isGasTypeLoaded = false;
  bool isDistanceLoaded = false;

  late GetGasTypes gasTypes = GetGasTypes(gasTypes: [], totalItems: 0, statusCode: -1);
  late String favoriteGasTypeId = '';
  String? selected;

  StreamSubscription<dynamic>? streamSubscription;

  @override
  void initState() {
    super.initState();

    apiService.getFavoriteGasType().then((value) {
      selected = (value == 'null' || value == null ? Constants.gasTypeDefault : value);
      isGasTypeLoaded = true;
      if (isGasTypeLoaded && isDistanceLoaded) {
        // markers = [];
        getGasStationsMap(currentCenter.latitude, currentCenter.longitude, distance, selected);
      }
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
    streamSubscription =
        gasStationService.getGasStationsMap(currentCenter.latitude, currentCenter.longitude, radius, gasType).asStream().listen((data) {
      markers = [];
      for (GasStation element in data.gasStations) {
        markers.add(
          addMarker(element, element.hasLowPrices),
        );
      }
      setState(() {});
    });
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
                        ScaleLayerWidget(
                          options: ScaleLayerPluginOption(
                            lineColor: const Color.fromARGB(255, 0, 0, 0),
                            lineWidth: 2,
                            textStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12),
                            padding: const EdgeInsets.only(top: 50, left: 10),
                          ),
                        ),
                        getGasTypesWidget(),
                      ],
                      options: MapOptions(
                        center: currentCenter,
                        onSecondaryTap: (tapPosition, point) => {print('here')},
                        maxZoom: maxZoom,
                        minZoom: minZoom,
                        onTap: (_, __) => popupLayerController.hideAllPopups(),
                        zoom: currentZoom,
                        onMapReady: () {
                          var northEastLatitude = mapController.bounds!.northEast.latitude;
                          var northWestLatitude = mapController.bounds!.northWest.latitude;
                          var northEastLongitude = mapController.bounds!.northEast.longitude;
                          var northWestLongitude = mapController.bounds!.northWest.longitude;

                          setState(() {
                            distance = apiService.distanceBetweenTwoCoordinates(
                              northEastLatitude,
                              northEastLongitude,
                              northWestLatitude,
                              northWestLongitude,
                            );
                            isDistanceLoaded = true;
                            if (isGasTypeLoaded && isDistanceLoaded) {
                              getGasStationsMap(currentCenter.latitude, currentCenter.longitude, distance, selected);
                            }
                          });
                        },
                        onMapEvent: (mapEvent) {
                          debugPrint(mapEvent.toString());
                          if (mapEvent is MapEventMove || mapEvent is MapEventRotate) {
                            setState(() {
                              currentZoom = mapEvent.zoom;

                              if (currentZoom > maxZoom) {
                                currentZoom = maxZoom;
                              }

                              if (currentZoom < minZoom) {
                                currentZoom = minZoom;
                              }

                              currentCenter = mapEvent.center;
                              mapController.move(currentCenter, currentZoom);

                              var northEastLatitude = mapController.bounds!.northEast.latitude;
                              var northWestLatitude = mapController.bounds!.northWest.latitude;
                              var northEastLongitude = mapController.bounds!.northEast.longitude;
                              var northWestLongitude = mapController.bounds!.northWest.longitude;

                              distance = apiService.distanceBetweenTwoCoordinates(
                                northEastLatitude,
                                northEastLongitude,
                                northWestLatitude,
                                northWestLongitude,
                              );
                            });
                          }

                          if (mapEvent is MapEventDoubleTapZoomEnd) {
                            setState(() {
                              currentZoom = mapEvent.zoom;

                              if (currentZoom > maxZoom) {
                                currentZoom = maxZoom;
                              }

                              if (currentZoom < minZoom) {
                                currentZoom = minZoom;
                              }

                              currentCenter = mapEvent.center;
                              mapController.move(currentCenter, currentZoom);

                              var northEastLatitude = mapController.bounds!.northEast.latitude;
                              var northWestLatitude = mapController.bounds!.northWest.latitude;
                              var northEastLongitude = mapController.bounds!.northEast.longitude;
                              var northWestLongitude = mapController.bounds!.northWest.longitude;

                              distance = apiService.distanceBetweenTwoCoordinates(
                                northEastLatitude,
                                northEastLongitude,
                                northWestLatitude,
                                northWestLongitude,
                              );

                              if (isGasTypeLoaded && isDistanceLoaded) {
                                streamSubscription?.cancel();
                                getGasStationsMap(currentCenter.latitude, currentCenter.longitude, distance, selected);
                              }
                            });
                          }

                          if (mapEvent is MapEventMoveEnd) {
                            setState(() {
                              currentCenter = mapEvent.center;

                              mapController.move(currentCenter, currentZoom);

                              if (isGasTypeLoaded && isDistanceLoaded) {
                                streamSubscription?.cancel();
                                getGasStationsMap(currentCenter.latitude, currentCenter.longitude, distance, selected);
                              }
                            });
                          }
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
    List<CoolDropdownItem> items = [];
    final gasTypeDropdownController = DropdownController();
    CoolDropdownItem? selectedItem;

    items = List.generate(
      gasTypes.totalItems,
      (int index) {
        GasType gasType = gasTypes.gasTypes[index];
        CoolDropdownItem coolDropdownItem = CoolDropdownItem(
          label: '',
          icon: SizedBox(
            height: 70,
            width: 70,
            child: Image.network(
              Constants.baseUrl + gasType.imagePath,
            ),
          ),
          value: gasType.uuid,
        );

        if (selected == null && gasType.uuid == Constants.gasTypeDefault) {
          selectedItem = coolDropdownItem;
        }

        if (selected == gasType.uuid) {
          selectedItem = coolDropdownItem;
        }

        return coolDropdownItem;
      },
    );

    if (items.isEmpty) {
      return Container();
    }

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, right: 8),
        child: DropdownButtonHideUnderline(
          child: CoolDropdown(
            controller: gasTypeDropdownController,
            dropdownList: items,
            defaultItem: selectedItem ?? items.last,
            onChange: (uuid) {
              setState(() {
                selected = uuid;
                apiService.setFavoriteGasType(uuid);
                if (isGasTypeLoaded && isDistanceLoaded) {
                  markers = [];
                  streamSubscription?.cancel();
                  getGasStationsMap(currentCenter.latitude, currentCenter.longitude, distance, uuid);
                }
              });
              gasTypeDropdownController.close();
            },
            resultOptions: const ResultOptions(
              width: 70,
              space: 0,
              mainAxisAlignment: MainAxisAlignment.center,
              boxDecoration: BoxDecoration(
                color: Colors.transparent,
                gradient: null,
                border: null,
                backgroundBlendMode: null,
                borderRadius: null,
                boxShadow: null,
                shape: BoxShape.circle,
              ),
              openBoxDecoration: BoxDecoration(
                color: Colors.transparent,
                gradient: null,
                border: null,
                backgroundBlendMode: null,
                borderRadius: null,
                boxShadow: null,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.only(left: 0, right: 0),
              render: ResultRender.icon,
              icon: SizedBox(
                width: 0,
                height: 0,
              ),
            ),
            dropdownOptions: const DropdownOptions(
              height: 300,
              width: 70,
              color: Colors.transparent,
            ),
            dropdownItemOptions: const DropdownItemOptions(
              padding: EdgeInsets.zero,
              render: DropdownItemRender.icon,
              selectedPadding: EdgeInsets.zero,
              mainAxisAlignment: MainAxisAlignment.center,
              selectedBoxDecoration: BoxDecoration(
                color: Colors.transparent,
                gradient: null,
                border: null,
                backgroundBlendMode: null,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
