import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/account/presentation/widgets/account_info_tile.dart';
import 'package:fit_connect/features/account/presentation/widgets/range_selector.dart';
import 'package:fit_connect/features/account/presentation/widgets/single_select_list_widget.dart';
import 'package:fit_connect/features/account/presentation/widgets/text_input_widget.dart';
import 'package:fit_connect/features/shared/domain/entities/gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/constants.dart';
import '../../../../utils/validator.dart';
import '../../../location/presentation/location_widget.dart';
import '../../../shared/data/models/user.dart';
import '../../../shared/domain/entities/fitness_interest.dart';
import '../../../shared/domain/entities/fitness_level.dart';
import '../../../shared/domain/entities/workout_day.dart';
import '../../../shared/domain/entities/workout_day_times.dart';
import '../../../shared/domain/entities/workout_time.dart';
import '../bloc/user_data_bloc.dart';
import '../bloc/user_data_event.dart';
import 'multi_select_daytime_widget.dart';
import 'multi_select_list_widget.dart';

class AccountScreenDetails extends StatelessWidget {
  final User user;

  const AccountScreenDetails({super.key, required this.user});

  void _showDialog(BuildContext context, Widget dialogContent) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(child: dialogContent);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        AccountInfoTile(title: 'email'.tr(), value: user.email),
        AccountInfoTile(
          title: 'name'.tr(),
          value: user.name,
          onPressed: () => _showDialog(
            context,
            TextInputWidget(
              isEditing: true,
              text: 'edit_name'.tr(),
              initialValue: user.name,
              onChanged: (newValue) {
                context.read<UserDataBloc>().add(UpdateName(newValue));
                Navigator.of(context, rootNavigator: true).pop();
              },
              validator: (text) => Validator.validateField(text),
            ),
          ),
        ),
        AccountInfoTile(
          title: 'age'.tr(),
          value: user.age,
          onPressed: () => _showDialog(
            context,
            TextInputWidget(
              isEditing: true,
              text: 'edit_age'.tr(),
              initialValue: user.age,
              onChanged: (newValue) {
                context.read<UserDataBloc>().add(UpdateAge(newValue));
                Navigator.of(context, rootNavigator: true).pop();
              },
              validator: (text) => Validator.validateAge(text),
            ),
          ),
        ),
        AccountInfoTile(
          title: 'location'.tr(),
          value: user.location,
          onPressed: () => _showDialog(
            context,
            LocationAutocompleteWidget(
              isEditing: true,
              title: 'edit_location'.tr(),
              initialLocation: user.location,
              onLocationSelected: (newValue) {
                context.read<UserDataBloc>().add(UpdateLocation(newValue));
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ),
        ),
        AccountInfoTile(
          title: 'gender'.tr(),
          value: user.gender?.displayName ?? '',
          onPressed: () => _showDialog(
            context,
            SingleSelectListWidget<Gender>(
              title: 'update_gender'.tr(),
              items: Gender.values,
              isEditing: true,
              initialSelectedItem: user.gender,
              displayNames:
              Gender.values.map((value) => value.displayName).toList(),
              onItemSelected: (newValue) {
                context.read<UserDataBloc>().add(UpdateGender(newValue));
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ),
        ),
        AccountInfoTile(
          title: 'fitness_interests'.tr(),
          value: user.fitnessInterests.map((e) => e.displayName).join(', '),
          onPressed: () => _showDialog(
            context,
            MultiSelectListWidget<FitnessInterest>(
              title: 'update_fitness_interests'.tr(),
              availableOptions: FitnessInterest.values,
              initialSelectedItems: user.fitnessInterests,
              displayNames: FitnessInterest.values
                  .map((item) => item.displayName)
                  .toList(),
              onSelected: (newValue) {
                context
                    .read<UserDataBloc>()
                    .add(UpdateFitnessInterests(newValue));
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ),
        ),
        AccountInfoTile(
          title: 'fitness_level'.tr(),
          value: user.fitnessLevel?.displayName ?? '',
          onPressed: () => _showDialog(
            context,
            SingleSelectListWidget<FitnessLevel>(
              title: 'update_fitness_level'.tr(),
              items: FitnessLevel.values,
              isEditing: true,
              initialSelectedItem: user.fitnessLevel,
              displayNames: FitnessLevel.values
                  .map((value) => value.displayName)
                  .toList(),
              onItemSelected: (newValue) {
                context.read<UserDataBloc>().add(UpdateFitnessLevel(newValue));
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ),
        ),
        AccountInfoTile(
          title: 'preferred_workout_times'.tr(),
          value: user.preferredWorkoutDayTimes
              .map((dayTime) => dayTime.displayName)
              .join('; '),
          onPressed: () => _showDialog(
            context,
            MultiSelectDayTimeWidget(
              isEditing: true,
              title: 'update_preferred_workout_times'.tr(),
              availableDays: WorkoutDay.values,
              availableTimes: WorkoutTime.values,
              initialSelectedItems: user.preferredWorkoutDayTimes,
              onSelected: (List<WorkoutDayTimes> workoutDayTimes) {
                context
                    .read<UserDataBloc>()
                    .add(UpdatePreferredWorkoutTimes(workoutDayTimes));
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ),
        ),
        AccountInfoTile(
          title: 'preferred_partner_gender'.tr(),
          value: user.preferredGenderOfWorkoutPartner
              .map((e) => e.displayName)
              .join(', '),
          onPressed: () => _showDialog(
            context,
            MultiSelectListWidget<Gender>(
              title: 'update_preferred_partner_gender'.tr(),
              availableOptions: Gender.values,
              isEditing: true,
              initialSelectedItems: user.preferredGenderOfWorkoutPartner,
              displayNames:
              Gender.values.map((value) => value.displayName).toList(),
              onSelected: (newValue) {
                context
                    .read<UserDataBloc>()
                    .add(UpdatePreferredGender(newValue));
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ),
        ),
        AccountInfoTile(
          title: 'age_range_preference'.tr(),
          value:
          '${user.ageRangePreference.start.round()} - ${user.ageRangePreference.end.round()}',
          onPressed: () => _showDialog(
            context,
            RangeSelector(
              isEditing: true,
              sliderMin: AppConstants.minUserAge,
              sliderMax: AppConstants.maxUserAge,
              title: 'update_age_range_preference'.tr(),
              selectedMinValue: user.ageRangePreference.start,
              selectedMaxValue: user.ageRangePreference.end,
              onRangeSelected: (range) {
                context
                    .read<UserDataBloc>()
                    .add(UpdateAgeRangePreference(range));
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ),
        ),
        AccountInfoTile(
          title: 'bio'.tr(),
          value: user.bio ?? '',
          onPressed: () => _showDialog(
            context,
            TextInputWidget(
              isEditing: true,
              text: 'bio'.tr(),
              initialValue: user.bio,
              onChanged: (newValue) {
                context.read<UserDataBloc>().add(UpdateBio(newValue));
                Navigator.of(context, rootNavigator: true).pop();
              },
              validator: null,
            ),
          ),
        ),
      ],
    );
  }
}

