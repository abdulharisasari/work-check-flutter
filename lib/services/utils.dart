import 'package:flutter/material.dart';

class Utils {
  
  static List<BoxShadow> shadowCustom({Color color = Colors.black12, double blur = 8, double spread = 0, Offset offset = const Offset(0, 8)}) {
    return [
      BoxShadow(color: color, blurRadius: blur, spreadRadius: spread, offset: offset)
    ];
  }

}
