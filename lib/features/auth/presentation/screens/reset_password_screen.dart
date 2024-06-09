import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_scaffold.dart';
import '../../../../common_widgets/custom_textformfield.dart';
import '../../../../constants/style_guide.dart';
import '../../../../core/alerts/alert_service.dart';
import '../../../../core/alerts/dialog_manager.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../utils/validator.dart';
import '../../../navigation/data/routes/router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class ResetPasswordScreen extends HookWidget {
  const ResetPasswordScreen(
      {super.key, required this.code, required this.email});

  final String code;
  final String email;

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>(), const []);

    void submitForm() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        context.read<AuthBloc>().add(NewPasswordRequested(
            newPassword: passwordController.text, code: code));
      }
    }

    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is PasswordChangedSuccessState) {
        _handlePasswordChangedSuccessState(context);
      } else if (state is AuthErrorState) {
        _handleErrorState(context, state);
      }
    }, builder: (context, state) {
      return CustomScaffold(
        child: Form(
          key: formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('${'setting_new_password_for_email'.tr()}: $email'),
            const Gap(Sizes.p24),
            CustomTextFormField(
              controller: passwordController,
              label: 'password'.tr(),
              obscureText: true,
              validator: (text) => Validator.validatePassword(text),
            ),
            const Gap(Sizes.p24),
            CustomButton(
              onPressed: submitForm,
              isLoading: state is AuthLoadingState,
              label: 'set_new_password'.tr(),
            ),
          ]),
        ),
      );
    });
  }

  _handlePasswordChangedSuccessState(BuildContext context) {
    getIt<DialogManager>().showAppDialog(context, "password_updated".tr(),
        "password_updated_success".tr(), DialogType.success,
        onPrimaryPressed: () => context.go(Routes.home.path));
  }

  void _handleErrorState(BuildContext context, AuthErrorState state) {
    getIt<AlertService>().showMessage(context, state.error, MessageType.error);
  }
}
