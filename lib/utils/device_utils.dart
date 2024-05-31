import 'package:flutter/material.dart';

import '../constants/sizes.dart';

class DeviceUtils {
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= Sizes.tabletBreakpoint;
  }
}
