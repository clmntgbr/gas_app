import 'package:flutter/material.dart';
import 'package:gas_app/model/gas_station.dart';

class GasStationMarkerPopup extends StatelessWidget {
  const GasStationMarkerPopup({Key? key, required this.gasStation}) : super(key: key);
  final GasStation gasStation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 5),
          ),
          const Image(
            width: 70,
            height: 20,
            image: AssetImage('images/maximaze.png'),
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
                    'gasStation.name',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_sharp,
                        size: 13,
                        color: Colors.grey,
                      ),
                      Text(
                        ' ${'${gasStation.address.number} ${gasStation.address.street}'.trim()}',
                        textAlign: TextAlign.left,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  Text(
                    '     ${'${gasStation.address.postalCode}, ${gasStation.address.city}'.trim()}',
                    textAlign: TextAlign.left,
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 60,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: getLastGasPrices(gasStation),
                  //   ),
                  // ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: GFButton(
                  //     color: Colors.green,
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => GasStationView(
                  //             gasStation: gasStation,
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     text: "Accèder à la station",
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
