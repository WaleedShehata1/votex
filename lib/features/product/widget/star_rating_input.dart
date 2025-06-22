import 'package:flutter/material.dart';

class StarRatingInput extends StatelessWidget {
  final int currentRating;
  final void Function(int) onRate;

  const StarRatingInput({
    super.key,
    required this.currentRating,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final value = index + 1;
        return GestureDetector(
          onTap: () => onRate(value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              currentRating >= value ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
          ),
        );
      }),
    );
  }
}
