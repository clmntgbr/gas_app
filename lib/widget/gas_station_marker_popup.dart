import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gas_app/constants.dart';
import 'package:gas_app/model/gas_station.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:image_network/image_network.dart';
import 'package:indexed/indexed.dart';

class GasStationMarkerPopup extends StatelessWidget {
  const GasStationMarkerPopup({Key? key, required this.gasStation}) : super(key: key);
  final GasStation gasStation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2000,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Indexer(
                children: [
                  Indexed(
                    index: 1,
                    child: Positioned(
                      child: ImageNetwork(
                        image: Constants.baseUrl + gasStation.imagePath,
                        height: 225,
                        width: MediaQuery.of(context).size.width,
                        onTap: () {},
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        fitAndroidIos: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Indexed(
                    index: 2,
                    child: Positioned(
                      left: 10,
                      bottom: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Stack(
                            children: [
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                                child: Container(),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white.withOpacity(0.20)),
                                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                    Colors.white.withOpacity(0.15),
                                    Colors.white.withOpacity(0.05),
                                  ]),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${gasStation.address.number} ${gasStation.address.street}'.replaceAll('null', '').trim(),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: Color(0xffe7e7e7),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      '${gasStation.address.postalCode}, ${gasStation.address.city}'.trim(),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        color: Color(0xffe7e7e7),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Indexed(
                    index: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 100,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color.fromARGB(255, 199, 198, 198),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Text(
                    '${gasStation.name}',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GFButton(
                      color: Colors.green,
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => GasStationView(
                        //       gasStation: gasStation,
                        //     ),
                        //   ),
                        // );
                      },
                      text: "Accèder à la station",
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
