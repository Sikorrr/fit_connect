import 'package:equatable/equatable.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object> get props => [];
}

class FetchUsersEvent extends ExploreEvent {}

class ToggleShowAllEvent extends ExploreEvent {
  final bool showAll;

  const ToggleShowAllEvent(this.showAll);
}
