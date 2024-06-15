import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/workout_sessions_list.dart';

class AllWorkoutSessionsScreen extends StatelessWidget {
  const AllWorkoutSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('all_workouts'.tr()),
          bottom: TabBar(
            tabs: [
              Tab(text: 'upcoming'.tr()),
              Tab(text: 'past'.tr()),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            WorkoutSessionsList(fetchPast: false),
            WorkoutSessionsList(fetchPast: true),
          ],
        ),
      ),
    );
  }
}
