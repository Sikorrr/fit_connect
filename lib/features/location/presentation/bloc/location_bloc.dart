import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fit_connect/features/location/data/repositories/location_repository_impl.dart';
import 'package:injectable/injectable.dart';

import 'location_event.dart';
import 'location_state.dart';

@singleton
class LocationAutocompleteBloc
    extends Bloc<LocationAutocompleteEvent, LocationAutocompleteState> {
  final LocationRepositoryImpl locationRepositoryImpl;

  LocationAutocompleteBloc({required this.locationRepositoryImpl})
      : super(LocationAutocompleteInitial()) {
    on<LocationQueryChanged>(_onLocationQueryChanged);
    on<ClearSuggestions>(onClearSuggestions);
  }

  FutureOr<void> onClearSuggestions(event, emit) {
    emit(LocationAutocompleteEmpty());
  }

  FutureOr<void> _onLocationQueryChanged(event, emit) async {
    emit(LocationAutocompleteLoading());
    try {
      List<String> suggestions =
          await locationRepositoryImpl.fetchSuggestions(event.query);
      emit(LocationAutocompleteLoaded(suggestions));
    } catch (error) {
      emit(LocationAutocompleteError(error.toString()));
    }
  }
}
