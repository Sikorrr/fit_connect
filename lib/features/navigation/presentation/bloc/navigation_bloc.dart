import 'package:bloc/bloc.dart';

import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(index: 0)) {
    on<NavigationItemSelected>((event, emit) {
      emit(NavigationState(index: event.index));
    });
  }
}
