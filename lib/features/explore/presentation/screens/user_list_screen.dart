import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/alerts/alert_service.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../navigation/data/routes/router.dart';
import '../bloc/explore_bloc.dart';
import '../bloc/explore_state.dart';
import '../widgets/user_tile.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExploreBloc, ExploreState>(builder: (context, state) {
      if (state is ExploreLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is ExploreLoaded) {
        return ListView.builder(
          itemCount: state.users.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return UserTile(
              user: state.users[index],
              onTap: () {
                context.go(
                  '${Routes.explore.path}/${state.users[index].id}',
                  extra: state.users[index],
                );
              },
            );
          },
        );
      }
      return const SizedBox.shrink();
    }, listener: (context, state) {
      if (state is ExploreError) {
        getIt<AlertService>()
            .showMessage(context, state.message, MessageType.error);
      }
    });
  }
}
