import 'package:easy_localization/easy_localization.dart';
import 'package:fit_connect/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_scaffold.dart';
import '../../../../common_widgets/custom_textformfield.dart';
import '../../../../constants/style_guide.dart';
import '../../../../core/alerts/alert_service.dart';
import '../../../../core/alerts/dialog_manager.dart';
import '../../../../core/dependency_injection/dependency_injection.dart';
import '../../../../utils/validator.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordScreen extends HookWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>(), const []);

    void submitForm() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        context
            .read<AuthBloc>()
            .add(PasswordResetRequested(emailController.text));
      }
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetSuccessState) {
          _handlePasswordResetSuccessState(context);
        } else if (state is AuthErrorState) {
          _handleErrorState(context, state);
        }
      },
      child: CustomScaffold(
        child: Form(
          key: formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CustomTextFormField(
              controller: emailController,
              label: 'email'.tr(),
              validator: (text) => Validator.validateEmail(text),
            ),
            const Gap(Sizes.p24),
            CustomButton(
              onPressed: submitForm,
              label: 'reset_password'.tr(),
            ),
          ]),
        ),
      ),
    );
  }

  _handlePasswordResetSuccessState(BuildContext context) {
    getIt<DialogManager>().showAppDialog(
      context,
      "password_reset_email_sent".tr(),
      "password_reset_email_sent_message".tr(),
      InfoDialog(),
    );
  }

  void _handleErrorState(BuildContext context, AuthErrorState state) {
    getIt<AlertService>().showMessage(context, state.error, MessageType.error);
  }
}
