import 'package:flutter/material.dart';
import '../model/gas_station.dart';
import '../model/gas_price.dart';
import 'package:google_fonts/google_fonts.dart';

List<Widget> getLastGasPrices(GasStation gasStation) {
  List<Widget> widgets = [];

  for (GasPrice element in gasStation.lastGasPrices) {
    TextStyle textStyle = GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.black,
    );
    if (element.isLowPrice) {
      textStyle = GoogleFonts.roboto(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.green,
      );
    }

    widgets.add(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: SizedBox(
            child: Column(
              children: [
                Text(
                  '${element.gasPriceValue / 1000}€ ',
                  style: popUpTextColor(element.gasPriceDifference),
                  textAlign: TextAlign.center,
                ),
                Text(
                  element.gasTypeLabel,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  return widgets;
}

TextStyle popUpTextColor(String value) {
  Color color = Colors.orangeAccent;
  if ('increasing' == value) {
    color = Colors.redAccent;
  }
  if ('decreasing' == value) {
    color = Colors.green;
  }

  return GoogleFonts.roboto(
    fontWeight: FontWeight.w800,
    fontSize: 12,
    color: color,
  );
}
