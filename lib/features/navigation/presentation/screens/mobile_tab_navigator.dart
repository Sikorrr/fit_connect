import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/navigation_bloc.dart';
import '../widgets/mobile_navigation_bar.dart';

class MobileTabNavigator extends StatelessWidget {
  final Widget child;
  final Function(int) onDestinationSelected;

  const MobileTabNavigator(
      {super.key, required this.child, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: MobileNavigationBar(
          selectedIndex: context.read<NavigationBloc>().state.index,
          onDestinationSelected: onDestinationSelected),
    );
  }
}
