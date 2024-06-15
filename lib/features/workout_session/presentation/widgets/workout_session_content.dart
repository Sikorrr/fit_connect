import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/workout_session/presentation/widgets/show_all_button.dart';
import 'package:fit_connect/features/workout_session/presentation/widgets/workout_card_main.dart';
import 'package:flutter/material.dart';

import '../../../../constants/style_guide.dart';
import '../../../../utils/image_utils.dart';
import '../bloc/workout_session_state.dart';

class WorkoutSectionContent extends StatelessWidget {
  final WorkoutSessionLoaded state;

  const WorkoutSectionContent({super.key, required this.state});

  static const double carouselHeight = 280.0;
  static const double carouselEnlargeFactor = 0.15;
  static const double carouselViewportFraction = 0.75;

  @override
  Widget build(BuildContext context) {
    final workoutsToShow = state.sessions.length > 2
        ? state.sessions.sublist(0, 2)
        : state.sessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(Sizes.p12),
          child: Text(
            'upcoming_workouts_title'.tr(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
        workoutsToShow.isEmpty
            ? Center(
                child: Text(
                  'no_upcoming_workouts'.tr(),
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : CarouselSlider.builder(
                options: CarouselOptions(
                  height: carouselHeight,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  padEnds: false,
                  enlargeFactor: carouselEnlargeFactor,
                  viewportFraction: carouselViewportFraction,
                ),
                itemCount: workoutsToShow.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  String imagePath = getImagePath(index);
                  return WorkoutCardMain(
                      workout: workoutsToShow[index], imagePath: imagePath);
                },
              ),
        if (state.sessions.length > 2) const ShowAllButton(),
      ],
    );
  }
}
