import 'package:fit_connect/features/navigation/presentation/screens/web_tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/device_utils.dart';
import '../../data/routes/tab_routes.dart';
import '../bloc/navigation_bloc.dart';
import '../bloc/navigation_event.dart';
import 'mobile_tab_navigator.dart';

class TabNavigator extends StatelessWidget {
  final Widget child;

  const TabNavigator({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    bool isTablet = DeviceUtils.isTablet(context);
    return isTablet
        ? WebTabNavigator(
            onDestinationSelected: (index) => _onItemTapped(context, index),
            child: child,
          )
        : MobileTabNavigator(
            onDestinationSelected: (index) => _onItemTapped(context, index),
            child: child,
          );
  }

  void _onItemTapped(BuildContext context, int index) {
    context.read<NavigationBloc>().add(NavigationItemSelected(index));
    context.go(TabRoutes.getPath(index));
  }
}
