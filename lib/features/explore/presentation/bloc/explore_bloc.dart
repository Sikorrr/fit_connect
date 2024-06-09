import 'dart:async';

import 'package:fit_connect/core/state/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/response.dart';
import '../../../../core/api/result_status.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../shared/data/models/user.dart';
import '../../../shared/domain/repositories/user_repository.dart';
import 'explore_event.dart';
import 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final UserRepository _userRepository;

  bool showAll = true;

  ExploreBloc(this._userRepository) : super(ExploreInitial()) {
    on<FetchUsersEvent>(_fetchUsers);
    on<ToggleShowAllEvent>(_showAll);
  }

  Future<FutureOr<void>> _fetchUsers(
      FetchUsersEvent event, Emitter<ExploreState> emit) async {
    emit(ExploreLoading());
    Response<List<User>> response = await _userRepository.fetchUsers();
    if (response.result == ResultStatus.success && response.data != null) {
      List<User> users = response.data!;
      User? currentUser = getIt<AppState>().user;
      final filteredUsers = _filterUsers(users, currentUser!);
      emit(ExploreLoaded(filteredUsers));
    } else {
      emit(ExploreError(response.message ?? 'failed_to_fetch_users'));
    }
  }

  FutureOr<void> _showAll(
      ToggleShowAllEvent event, Emitter<ExploreState> emit) {
    showAll = event.showAll;
    add(FetchUsersEvent());
  }

  List<User> _filterUsers(List<User> users, User currentUser) {
    if (showAll) {
      return users;
    } else {
      return users.where((user) => user.matches(currentUser)).toList();
    }
  }
}
