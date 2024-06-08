import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alerts/alert_service.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../bloc/user_data_bloc.dart';
import '../bloc/user_data_state.dart';
import '../widgets/account_screen_details.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

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
