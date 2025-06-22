import 'package:flutter/material.dart';

class StaticStarDisplay extends StatelessWidget {
  final double rating;
  final double size;

  const StaticStarDisplay({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final starPos = index + 1;
        IconData icon =
            rating >= starPos
                ? Icons.star
                : (rating >= starPos - 0.5
                    ? Icons.star_half
                    : Icons.star_border);
        return Icon(icon, color: Colors.orange, size: size);
      }),
    );
  }
}
