// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    // Draw the blurred shadow background
    paint.shader = RadialGradient(
      colors: [Colors.blue.withOpacity(0.2), Colors.transparent],
    ).createShader(Rect.fromCircle(
        center: Offset(size.width * 0.4, size.height * 0.6),
        radius: size.width * 0.8));

    Path shadowPath = Path();
    shadowPath.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.4, size.height * 0.6),
      radius: size.width * 0.6,
    ));

    canvas.drawPath(shadowPath, paint);

    // Draw the main blue blob
    paint.shader = null;
    paint.color = Colors.blue;

    Path blobPath = Path();
    blobPath.moveTo(size.width * 0.7, size.height * 0.2);
    blobPath.quadraticBezierTo(
        size.width, size.height * 0.3, size.width * 0.9, size.height * 0.6);
    blobPath.quadraticBezierTo(
        size.width * 0.7, size.height, size.width * 0.3, size.height * 0.9);
    blobPath.quadraticBezierTo(
        0, size.height * 0.8, size.width * 0.2, size.height * 0.4);
    blobPath.quadraticBezierTo(size.width * 0.3, size.height * 0.1,
        size.width * 0.7, size.height * 0.2);
    blobPath.close();

    canvas.drawPath(blobPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
