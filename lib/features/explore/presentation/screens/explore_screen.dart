import 'package:fit_connect/features/explore/presentation/screens/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../shared/domain/repositories/user_repository.dart';
import '../bloc/explore_bloc.dart';
import '../bloc/explore_event.dart';
import '../widgets/toggle_button.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExploreBloc(getIt<UserRepository>())..add(FetchUsersEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const SizedBox(),
          actions: const [
            ToggleButton(),
          ],
        ),
        body: const UserListScreen(),
      ),
    );
  }
}
