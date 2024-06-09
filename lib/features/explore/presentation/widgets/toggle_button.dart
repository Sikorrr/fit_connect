import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/style_guide.dart';
import '../bloc/explore_bloc.dart';
import '../bloc/explore_event.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton({super.key});

  @override
  State<StatefulWidget> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool showAll = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(showAll ? 'show_all_users'.tr() : 'show_matching_users'.tr()),
          Switch(
            value: showAll,
            onChanged: (value) {
              setState(() {
                showAll = value;
              });
              context.read<ExploreBloc>().add(ToggleShowAllEvent(showAll));
            },
          ),
        ],
      ),
    );
  }
}
