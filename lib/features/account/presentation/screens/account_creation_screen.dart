import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/constants.dart';
import '../../../../core/alerts/alert_service.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../utils/validator.dart';
import '../../../location/presentation/location_widget.dart';
import '../../../navigation/data/routes/router.dart';
import '../../../shared/domain/entities/fitness_interest.dart';
import '../../../shared/domain/entities/fitness_level.dart';
import '../../../shared/domain/entities/gender.dart';
import '../../../shared/domain/entities/workout_day.dart';
import '../../../shared/domain/entities/workout_day_times.dart';
import '../../../shared/domain/entities/workout_time.dart';
import '../bloc/user_data_bloc.dart';
import '../bloc/user_data_event.dart';
import '../bloc/user_data_state.dart';
import '../widgets/multi_select_daytime_widget.dart';
import '../widgets/multi_select_list_widget.dart';
import '../widgets/range_selector.dart';
import '../widgets/single_select_list_widget.dart';
import '../widgets/slider_widgets.dart';
import '../widgets/text_input_widget.dart';

class AccountCreationScreen extends StatelessWidget {
  AccountCreationScreen({super.key});

  void _onNextPressed() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserDataBloc, UserDataState>(
      builder: (BuildContext context, UserDataState state) {
        return Scaffold(
          body: SliderWidget(
            controller: pageController,
            steps: [
              TextInputWidget(
                text: 'enter_your_name'.tr(),
                onChanged: (name) {
                  context.read<UserDataBloc>().add(UpdateName(name));
                  _onNextPressed();
                },
                validator: (text) => Validator.validateField(text),
                initialValue: state.user.name,
                textCapitalization: TextCapitalization.words,
              ),
              TextInputWidget(
                text: 'enter_your_age'.tr(),
                initialValue: state.user.age,
                onChanged: (age) {
                  context.read<UserDataBloc>().add(UpdateAge(age));
                  _onNextPressed();
                },
                validator: (text) => Validator.validateAge(text),
                keyboardType: TextInputType.number,
              ),
              LocationAutocompleteWidget(
                  title: 'enter_your_location'.tr(),
                  initialLocation: state.user.location,
                  onLocationSelected: (location) {
                    context.read<UserDataBloc>().add(UpdateLocation(location));
                    _onNextPressed();
                  }),
              SingleSelectListWidget<Gender>(
                initialSelectedItem: state.user.gender,
                items: Gender.values,
                displayNames:
                    Gender.values.map((gender) => gender.displayName).toList(),
                title: 'enter_your_gender'.tr(),
                onItemSelected: (Gender gender) {
                  context.read<UserDataBloc>().add(UpdateGender(gender));
                  _onNextPressed();
                },
              ),
              MultiSelectDayTimeWidget(
                title: 'update_preferred_workout_times_and_days'.tr(),
                availableDays: WorkoutDay.values,
                availableTimes: WorkoutTime.values,
                initialSelectedItems: state.user.preferredWorkoutDayTimes,
                onSelected: (List<WorkoutDayTimes> workoutDayTimes) {
                  context
                      .read<UserDataBloc>()
                      .add(UpdatePreferredWorkoutTimes(workoutDayTimes));
                  _onNextPressed();
                },
              ),
              MultiSelectListWidget<FitnessInterest>(
                title: 'select_your_fitness_interests'.tr(),
                displayNames: FitnessInterest.values
                    .map((interest) => interest.displayName)
                    .toList(),
                initialSelectedItems: state.user.fitnessInterests,
                onSelected: (List<FitnessInterest> interests) {
                  context
                      .read<UserDataBloc>()
                      .add(UpdateFitnessInterests(interests));
                  _onNextPressed();
                },
                availableOptions: FitnessInterest.values,
              ),
              SingleSelectListWidget<FitnessLevel>(
                initialSelectedItem: state.user.fitnessLevel,
                displayNames: FitnessLevel.values
                    .map((value) => value.displayName)
                    .toList(),
                items: FitnessLevel.values,
                title: 'select_your_fitness_level'.tr(),
                onItemSelected: (FitnessLevel item) {
                  context.read<UserDataBloc>().add(UpdateFitnessLevel(item));
                  _onNextPressed();
                },
              ),
              MultiSelectListWidget<Gender>(
                initialSelectedItems:
                    state.user.preferredGenderOfWorkoutPartner,
                displayNames:
                    Gender.values.map((gender) => gender.displayName).toList(),
                availableOptions: Gender.values,
                title: 'select_preferred_gender_of_your_partner'.tr(),
                onSelected: (List<Gender> item) {
                  context.read<UserDataBloc>().add(UpdatePreferredGender(item));
                  _onNextPressed();
                },
              ),
              RangeSelector(
                onRangeSelected: (values) {
                  context
                      .read<UserDataBloc>()
                      .add(UpdateAgeRangePreference(values));
                  _onNextPressed();
                },
                title: 'select_age_range'.tr(),
                sliderMin: AppConstants.minUserAge,
                sliderMax: AppConstants.maxUserAge,
                selectedMinValue: state.user.ageRangePreference.start,
                selectedMaxValue: state.user.ageRangePreference.end,
              ),
              TextInputWidget(
                text: 'do_you_want_to_write_something_about_you'.tr(),
                initialValue: state.user.bio,
                onChanged: (bio) {
                  context.read<UserDataBloc>().add(UpdateBio(bio));
                  context.read<UserDataBloc>().add(FinishOnboarding());
                },
              ),
            ],
            onFinished: () {
              context.read<UserDataBloc>().add(FinishOnboarding());
            },
            onNextPressed: _onNextPressed,
          ),
        );
      },
      listener: (BuildContext context, UserDataState state) {
        if (state is UserDataComplete) {
          getIt<AlertService>().showMessage(context,
              'account_successfully_created'.tr(), MessageType.success);
          context.go(Routes.home.path);
        }
      },
    );
  }
}
