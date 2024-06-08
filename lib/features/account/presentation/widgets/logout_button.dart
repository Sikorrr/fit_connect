import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fit_connect/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';

import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: Text("logout".tr()),
      onTap: () {
        getIt<AuthBloc>().add(Logout());
        getIt<AuthRepositoryImpl>().logOut();
      },
    );
  }
}
