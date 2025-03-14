// Custom Clipper for Triangle Shape
import 'package:flutter/material.dart';

class SaleBannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(SaleBannerClipper oldClipper) => false;
}
