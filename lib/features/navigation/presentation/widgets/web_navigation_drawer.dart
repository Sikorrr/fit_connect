import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WebNavigationDrawer extends StatelessWidget {
  final Function(int) onDestinationSelected;
  final int selectedIndex;
  final Widget? header;

  const WebNavigationDrawer({
    super.key,
    this.header,
    required this.onDestinationSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: onDestinationSelected,
      selectedIndex: selectedIndex,
      children: [
        if (header != null) header!,
        NavigationDrawerDestination(
            icon: const Icon(Icons.home), label: Text('home'.tr())),
        NavigationDrawerDestination(
            icon: const Icon(Icons.search), label: Text('explore'.tr())),
        NavigationDrawerDestination(
            icon: const Icon(Icons.message), label: Text('messages'.tr())),
        NavigationDrawerDestination(
            icon: const Icon(Icons.account_circle),
            label: Text('account'.tr())),
      ],
    );
  }
}
