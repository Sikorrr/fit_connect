import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MobileNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const MobileNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationDestination(icon: const Icon(Icons.home), label: 'home'.tr()),
        NavigationDestination(icon: const Icon(Icons.search), label: 'search'.tr()),
        NavigationDestination(
            icon: const Icon(Icons.message), label: 'messages'.tr()),
        NavigationDestination(
            icon: const Icon(Icons.account_circle), label: 'account'.tr()),
      ],
    );
  }
}
