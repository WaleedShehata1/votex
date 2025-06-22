import 'package:flutter/material.dart';

List<Widget> buildStarRating(String rateString, {double iconSize = 16}) {
  final double rate = double.tryParse(rateString) ?? 0;

  return List.generate(5, (index) {
    final int position = index + 1;
    final IconData icon;

    if (rate >= position) {
      icon = Icons.star;
    } else if (rate >= position - 0.5) {
      icon = Icons.star_half;
    } else {
      icon = Icons.star_border;
    }

    return Icon(icon, color: Colors.orange, size: iconSize);
  });
}
