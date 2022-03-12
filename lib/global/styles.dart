
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static containerCustom([double radius = 10]) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.0),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 0),
          ),
        ]);
  }

  static letterCustom(
      [double size = 30,
      bool bold = false,
      double strong = .6,
      bool through = false]) {
    return GoogleFonts.quicksand(
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.w600,
        decoration: through ? TextDecoration.lineThrough : null,
        color: strong >= 0.0 ? Colors.black.withOpacity(strong) : Colors.white);
  }
}
