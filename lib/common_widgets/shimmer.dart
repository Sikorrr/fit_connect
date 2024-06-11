import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/style_guide.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key, this.width = 100});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: width,
                    height: 20.0,
                    child: Container(
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ))),
    );
  }
}
