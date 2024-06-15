import 'package:flutter/material.dart';

import '../workout_session/presentation/screens/upcoming_workout_sessions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UpcomingWorkoutsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
