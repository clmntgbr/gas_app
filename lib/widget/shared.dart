import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

buildTextTitleVariation1(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: GoogleFonts.breeSerif(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),
    ),
  );
}

BoxShadow kBoxShadow = BoxShadow(
  color: Colors.grey.withOpacity(0.2),
  spreadRadius: 2,
  blurRadius: 8,
  offset: const Offset(0, 0),
);

buildTextTitleVariation2(String text, bool opacity) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: opacity ? Colors.grey[400] : Colors.black,
      ),
    ),
  );
}

buildTextSubTitleVariation1(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[400],
      ),
    ),
  );
}

buildTextSubTitleVariation2(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.grey[400],
      ),
    ),
  );
}

buildItemTitle(String text, double size, Color color, FontWeight fontWeight, int nbLines, bool hasTextSpan) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: nbLines,
      text: TextSpan(
        style: GoogleFonts.roboto(
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
        ),
        children: <TextSpan>[
          TextSpan(
            text: text,
          ),
          hasTextSpan
              ? const TextSpan(
                  text:
                      ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  style: TextStyle(
                    color: Colors.transparent,
                  ),
                )
              : const TextSpan(),
        ],
      ),
    ),
  );
}
