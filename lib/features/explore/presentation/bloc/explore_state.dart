import 'package:equatable/equatable.dart';

import '../../../shared/data/models/user.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final List<User> users;

  const ExploreLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class ExploreError extends ExploreState {
  final String message;

  const ExploreError(this.message);

  @override
  List<Object> get props => [message];
}
