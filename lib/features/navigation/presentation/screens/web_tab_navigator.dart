import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/navigation_bloc.dart';
import '../widgets/web_navigation_drawer.dart';
import '../widgets/web_navigation_header.dart';

class WebTabNavigator extends StatelessWidget {
  final Widget child;
  final Function(int) onDestinationSelected;

  const WebTabNavigator(
      {super.key, required this.child, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          WebNavigationDrawer(
            header: const NavigationHeader(),
            onDestinationSelected: onDestinationSelected,
            selectedIndex: context.read<NavigationBloc>().state.index,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
