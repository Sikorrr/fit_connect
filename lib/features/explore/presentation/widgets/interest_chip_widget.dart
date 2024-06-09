import 'package:fit_connect/utils/device_utils.dart';
import 'package:flutter/material.dart';

import '../../../../constants/style_guide.dart';
import '../../../shared/domain/entities/fitness_interest.dart';

class InterestChipsWidget extends StatelessWidget {
  final List<FitnessInterest> interests;

  const InterestChipsWidget({
    super.key,
    required this.interests,
  });

  static const double _fontSizeTablet = 14;
  static const double _fontSizePhone = 12;

  @override
  Widget build(BuildContext context) {
    bool isTabletView = DeviceUtils.isTablet(context);
    double chipFontSize = isTabletView ? _fontSizeTablet : _fontSizePhone;
    return Wrap(
      spacing: Sizes.chipSpacing,
      runSpacing: Sizes.chipRunSpacing,
      children: interests.map((interest) {
        return Chip(
          labelPadding: const EdgeInsets.all(Sizes.p2),
          label: Text(
            interest.displayName,
            style: TextStyle(fontSize: chipFontSize),
          ),
          avatar: const Icon(Icons.fitness_center, size: Sizes.p16),
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
        );
      }).toList(),
    );
  }
}
