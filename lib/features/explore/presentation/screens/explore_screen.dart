import 'package:fit_connect/features/explore/presentation/screens/user_list_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/toggle_button.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox(),
        actions: const [
          ToggleButton(),
        ],
      ),
      body: const UserListScreen(),
    );
  }
}
