import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/alerts/alert_service.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../navigation/data/routes/router.dart';
import '../bloc/user_data_bloc.dart';
import '../bloc/user_data_state.dart';
import '../widgets/account_screen_details.dart';
import '../widgets/logout_button.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SizedBox()),
      body: BlocConsumer<UserDataBloc, UserDataState>(
        builder: (context, state) {
          if (state is UserDataFetched || state is UserUpdateState) {
            return AccountScreenDetails(user: state.user);
          } else if (state is UserDataLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox.shrink();
        },
        listener: (BuildContext context, UserDataState state) {
          if (state is UserDataError) {
            getIt<AlertService>()
                .showMessage(context, state.error, MessageType.error);
          }
        },
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle),
            title:  Text('account_info'.tr()),
            onTap: () {
              context.go('${Routes.account.path}/${Routes.accountInfo.path}');
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title:  Text('all_workouts'.tr()),
            onTap: () {
              context.go(Routes.workoutSessions.path);
            },
          ),
          const LogoutButton(),
        ],
      ),
    );
  }
}
