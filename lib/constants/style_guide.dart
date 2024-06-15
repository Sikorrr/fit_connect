import 'package:flutter/material.dart';

class Sizes {
  static const p2 = 2.0;
  static const p4 = 4.0;
  static const p8 = 8.0;
  static const p12 = 12.0;

  static const p16 = 16.0;

  static const p24 = 24.0;

  static const p48 = 48.0;

  static const p64 = 64.0;

  static const double tabletBreakpoint = 800;

  static const double maxScreenWidth = 400;
  static const double defaultRadius = 20;

  static const double defaultElevation = 6;
  static const double defaultStrokeWidth = 2;

  static const double iconSize = 16.0;
  static const Color iconColor = Colors.grey;

  static const double chipSpacing = 6.0;
  static const double chipRunSpacing = 0.0;
  static const double userAvatarSmallSize = 30;
  static const double userAvatarLargeSize = 50;
}

class Decorations {
  static BoxDecoration tileDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, Colors.grey[100]!],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(Sizes.defaultRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
