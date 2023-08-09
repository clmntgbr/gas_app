import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import '../../service/address_service.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:side_sheet/side_sheet.dart';
import '../../model/address_filter.dart';
import '../../service/gas_type_service.dart';
import '../../constants.dart';
import '../../model/gas_station.dart';
import '../../service/api_service.dart';
import '../../service/gas_station_service.dart';
import '../../widget/gas_station_marker.dart';
import '../../widget/gas_station_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import '../../widget/scale_layer.dart';
import 'dart:async';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

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
  late double distance;
  late String favoriteGasTypeId = '';

  final addressService = AddressService();
  final gasStationService = GasStationService();
  final gasTypeService = GasTypeService();
  final apiService = ApiService();

  bool isGasTypeLoaded = false;
  bool isDistanceLoaded = false;
  bool isAddressCitiesLoaded = false;
  bool isAddressDepartmentsLoaded = false;
  bool isAddressPostalCodesLoaded = false;
  bool hasFilters = false;

  List<MultiSelectItem> addressCities = [];
  List<DropdownMenuItem> addressPostalCodes = [];
  List<DropdownMenuItem> addressDepartments = [];
  List<CoolDropdownItem> gasTypes = [];

  CoolDropdownItem? selectedGasTypes;
  String? selectedGasTypeUuid;
  List selectedAddressCities = [];
  List selectedAddressPostalCodes = [];
  List selectedAddressDepartments = [];

  StreamSubscription<dynamic>? streamSubscription;

  @override
  void initState() {
    super.initState();

    apiService.getFavoriteGasType().then(
      (value) {
        selectedGasTypeUuid = (value == 'null' || value == null ? Constants.gasTypeDefault : value);
        isGasTypeLoaded = true;
        if (isGasTypeLoaded && isDistanceLoaded) {
          getGasStationsMap(currentCenter.latitude, currentCenter.longitude, distance, selectedGasTypeUuid, selectedAddressCities);
        }
      },
    );

    gasTypeService.getGasTypes().then(
      (value) {
        gasTypes = value.gasTypes.map((gasType) {
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

          if (selectedGasTypeUuid == null && gasType.uuid == Constants.gasTypeDefault) {
            selectedGasTypes = coolDropdownItem;
          }

          if (selectedGasTypeUuid == gasType.uuid) {
            selectedGasTypes = coolDropdownItem;
          }

          return coolDropdownItem;
        }).toList();
      },
    );

    addressService.getAddressCities().then(
      (value) {
        addressCities = value.cities.map((e) {
          return MultiSelectItem<AddressFilter>(e, toBeginningOfSentenceCase("${e.name} - ${e.code}") ?? '');
        }).toList();
        isAddressCitiesLoaded = true;
      },
    );

    addressService.getAddressDepartments().then(
      (value) {
        addressDepartments = value.departments.map((e) {
          return DropdownMenuItem(
            child: Text(e.name),
          );
        }).toList();
        isAddressDepartmentsLoaded = true;
      },
    );

    addressService.getAddressPostalCodes().then(
      (value) {
        addressPostalCodes = value.postalCodes.map((e) {
          return DropdownMenuItem(
            child: Text(e.code),
          );
        }).toList();
        isAddressPostalCodesLoaded = true;
      },
    );

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

  getGasStationsMap(double latitude, double longitude, double radius, String? gasType, List selectedAddressCities) {
    streamSubscription = gasStationService
        .getGasStationsMap(currentCenter.latitude, currentCenter.longitude, radius, gasType, selectedAddressCities)
        .asStream()
        .listen((data) {
      markers = [];
      for (GasStation element in data.gasStations) {
        markers.add(
          addMarker(element, element.hasLowPrices),
        );
      }
      setState(() {
        hasFilters = false;
      });
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
                        getGasFilters(),
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
                              getGasStationsMap(
                                  currentCenter.latitude, currentCenter.longitude, distance, selectedGasTypeUuid, selectedAddressCities);
                            }
                          });
                        },
                        onMapEvent: (mapEvent) {
                          if (mapEvent is MapEventMove || mapEvent is MapEventRotate || mapEvent is MapEventFlingAnimation) {
                            setState(() {
                              currentZoom = mapEvent.zoom;

                              if (currentZoom > maxZoom) {
                                currentZoom = maxZoom;
                              }

                              if (currentZoom < minZoom) {
                                currentZoom = minZoom;
                              }

                              currentCenter = mapEvent.center;

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
                                getGasStationsMap(
                                    currentCenter.latitude, currentCenter.longitude, distance, selectedGasTypeUuid, selectedAddressCities);
                              }
                            });
                          }

                          if (mapEvent is MapEventMoveEnd || mapEvent is MapEventFlingAnimationEnd) {
                            setState(() {
                              currentCenter = mapEvent.center;

                              mapController.move(currentCenter, currentZoom);

                              if (isGasTypeLoaded && isDistanceLoaded) {
                                streamSubscription?.cancel();
                                getGasStationsMap(
                                    currentCenter.latitude, currentCenter.longitude, distance, selectedGasTypeUuid, selectedAddressCities);
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

  Widget getGasFilters() {
    if (!isAddressCitiesLoaded && !isAddressDepartmentsLoaded && !isAddressPostalCodesLoaded) {
      return Container();
    }

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, right: 13),
        child: Container(
          color: Colors.transparent,
          height: 45,
          width: 45,
          child: ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              iconColor: const MaterialStatePropertyAll(Colors.black),
              alignment: Alignment.center,
              backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
            ),
            onPressed: () async {
              await SideSheet.right(
                // barrierDismissible: false,
                body: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    getAddressCitiesFilter()
                  ],
                ),
                context: context,
              );
              if (hasFilters) {
                setState(() {
                  markers = [];
                });
                getGasStationsMap(
                  currentCenter.latitude,
                  currentCenter.longitude,
                  distance,
                  selectedGasTypeUuid,
                  selectedAddressCities,
                );
              }
            },
            child: const Icon(Icons.tune),
          ),
        ),
      ),
    );
  }

  Widget getAddressCitiesFilter() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: MultiSelectBottomSheetField(
        items: addressCities,
        separateSelectedItems: true,
        searchable: true,
        initialValue: selectedAddressCities,
        title: const Text("Villes"),
        selectedColor: Colors.black,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        buttonIcon: const Icon(
          Icons.location_city,
          color: Colors.black,
        ),
        confirmText: const Text(
          'Confirmer',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        cancelText: const Text(
          'Annuler',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        buttonText: const Text(
          "Filtrer par ville",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        onConfirm: (results) {
          if (results.isEmpty) {
            setState(() {
              hasFilters = false;
            });
          }

          if (results.isNotEmpty) {
            setState(() {
              hasFilters = true;
              selectedAddressCities = results;
            });
          }
        },
      ),
    );
  }

  Widget getGasTypesWidget() {
    final gasTypeDropdownController = DropdownController();

    if (gasTypes.isEmpty) {
      return Container();
    }

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 105, right: 0),
        child: DropdownButtonHideUnderline(
          child: CoolDropdown(
            controller: gasTypeDropdownController,
            dropdownList: gasTypes,
            defaultItem: selectedGasTypes ?? gasTypes.last,
            onChange: (uuid) {
              setState(() {
                selectedGasTypeUuid = uuid;
                apiService.setFavoriteGasType(uuid);
                if (isGasTypeLoaded && isDistanceLoaded) {
                  markers = [];
                  streamSubscription?.cancel();
                  getGasStationsMap(currentCenter.latitude, currentCenter.longitude, distance, uuid, selectedAddressCities);
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
