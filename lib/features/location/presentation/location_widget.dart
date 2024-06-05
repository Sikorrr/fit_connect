import 'package:fit_connect/common_widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/alerts/alert_service.dart';
import '../../../core/dependency_injection/dependency_injection.dart';
import '../../../utils/debouncer.dart';
import '../../account/presentation/widgets/user_input.dart';
import 'bloc/location_bloc.dart';
import 'bloc/location_event.dart';
import 'bloc/location_state.dart';

class LocationAutocompleteWidget extends HookWidget {
  LocationAutocompleteWidget({
    super.key,
    required this.title,
    required this.onLocationSelected,
    this.initialLocation,
    this.isEditing = false,
  });

  final String? initialLocation;
  final String title;
  final bool isEditing;
  final Function(String) onLocationSelected;
  final debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialLocation);
    final isButtonEnabled = useState<bool>(controller.text.isNotEmpty);

    return UserInput(
      isFullscreen: true,
      title: title,
      onPressed: isButtonEnabled.value
          ? () {
              onLocationSelected(controller.text);
            }
          : null,
      isEditing: isEditing,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: controller,
            onChanged: (value) {
              isButtonEnabled.value = false;
              debouncer.run(() {
                if (value.length >= 3) {
                  getIt<LocationAutocompleteBloc>()
                      .add(LocationQueryChanged(value));
                } else {
                  getIt<LocationAutocompleteBloc>().add(ClearSuggestions());
                }
              });
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          BlocConsumer<LocationAutocompleteBloc, LocationAutocompleteState>(
            bloc: getIt<LocationAutocompleteBloc>(),
            builder: (context, state) {
              if (state is LocationAutocompleteLoading) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              } else if (state is LocationAutocompleteLoaded) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.suggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.suggestions[index]),
                        onTap: () {
                          String location = state.suggestions[index];
                          controller.text = location;
                          isButtonEnabled.value = true;
                          getIt<LocationAutocompleteBloc>()
                              .add(ClearSuggestions());
                        },
                      );
                    },
                  ),
                );
              } else if (state is LocationAutocompleteEmpty) {
                return const SizedBox.shrink();
              }
              return const SizedBox.shrink();
            },
            listener: (BuildContext context, LocationAutocompleteState state) {
              if (state is LocationAutocompleteError) {
                getIt<AlertService>().showMessage(
                    context, state.errorMessage, MessageType.error);
              }
            },
          ),
        ],
      ),
    );
  }
}
