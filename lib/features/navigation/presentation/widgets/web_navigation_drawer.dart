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
        const NavigationDrawerDestination(
            icon: Icon(Icons.home), label: Text('Home')),
        const NavigationDrawerDestination(
            icon: Icon(Icons.search), label: Text('Search')),
        const NavigationDrawerDestination(
            icon: Icon(Icons.message), label: Text('Messages')),
        const NavigationDrawerDestination(
            icon: Icon(Icons.account_circle), label: Text('Account')),
      ],
    );
  }
}
