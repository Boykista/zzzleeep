import 'package:flutter/material.dart';

class DateBoxClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // path.moveTo(0, 0);
    // path.lineTo(size.width * 0.35, 0);
    // path.lineTo(size.width, size.height * 0.75);
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);
    path
          ..moveTo(size.width / 2, 0)
          // ..lineTo(size.width / 2 + (size.width * 0.05), 0)
          ..arcToPoint(
              Offset(size.width / 2 + (size.width * 0.3), size.height * 0.3),
              radius: Radius.circular(3))
          ..lineTo(size.width / 2 + (size.width * 0.3), size.height * 0.3)
          ..lineTo(size.width, size.height * 0.3)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..lineTo(0, size.height * 0.3)
          ..lineTo(size.width / 2 - (size.width * 0.18), size.height * 0.3)
          ..lineTo(size.width / 2 - (size.width * 0.18), size.height * 0.2)
          ..arcToPoint(Offset(size.width / 2 - (size.width * 0.18), 0),
              radius: Radius.circular(5))

        // ..lineTo(size.width * 0.3, 0)
        // ..arcToPoint(Offset(size.width * 0.3, size.height * 0.3),
        //     radius: Radius.circular(10))
        // ..lineTo(size.width * 0.3, size.height * 0.3)
        // ..lineTo(size.width, size.height * 0.3)
        // ..lineTo(size.width, size.height)
        // ..lineTo(0, size.height)
        // ..lineTo(0, size.height * 0.3)
        // ..lineTo(size.width * 0.3, size.height * 0.3)
        // ..lineTo(size.width * 0.3, 0)
        // ..arcToPoint(Offset(size.width * 0.3, size.height * 0.3),
        //     radius: Radius.circular(10))
        ;

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
