import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/auth/presentation/bloc/auth_event.dart';
import 'package:fit_connect/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/presentation/bloc/auth_bloc.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return Center(
          child: TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(Logout());
              },
              child: Text("logout".tr())));
    }));
  }
}
