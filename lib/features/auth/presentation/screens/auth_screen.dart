import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_scaffold.dart';
import '../../../../common_widgets/custom_textformfield.dart';
import '../../../../common_widgets/linked_text.dart';
import '../../../../constants/sizes.dart';
import '../../../../core/alert_service.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../dialog_manager.dart';
import '../../../../utils/validator.dart';
import '../../../navigation/data/routes/router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

enum AuthScreenType {
  login,
  register,
}

class AuthScreen extends HookWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>(), const []);

    void submitForm() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        context.read<AuthBloc>().add(EmailSignInSubmitted(
            emailController.text, passwordController.text));
      }
    }

    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthErrorState) {
        _handleErrorState(context, state);
      } else if (state is AuthEmailNotVerifiedState) {
        _handleEmailNotVerifiedState(context);
      } else if (state is EmailResendSuccessState) {
        _handleEmailResendSuccessState(context);
      }
    }, builder: (BuildContext context, AuthState state) {
      return CustomScaffold(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                controller: emailController,
                label: 'email'.tr(),
                validator: (text) => Validator.validateEmail(text),
              ),
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
                label: state.authScreenType == AuthScreenType.register
                    ? 'create_account'.tr()
                    : 'log_in'.tr(),
              ),
              const Gap(Sizes.p12),
              if (state.authScreenType == AuthScreenType.login)
                Align(
                  alignment: Alignment.centerRight,
                  child: LinkedText(
                      text: 'forgot_password'.tr(),
                      onPressed: () => context.go(Routes.forgotPassword.path)),
                ),
              const Gap(Sizes.p12),
              LinkedText(
                  text: state.authScreenType == AuthScreenType.register
                      ? 'log_in_text'.tr()
                      : 'sign_up_text'.tr(),
                  onPressed: () => getIt<AuthBloc>().add(ToggleFormType())),
              const Gap(Sizes.p24),
              SocialLoginButton(
                  borderRadius: Sizes.defaultRadius,
                  buttonType: SocialLoginButtonType.google,
                  onPressed: () =>
                      context.read<AuthBloc>().add(GoogleSignInRequested())),
              const Gap(Sizes.p12),
              SocialLoginButton(
                  borderRadius: Sizes.defaultRadius,
                  buttonType: SocialLoginButtonType.facebook,
                  onPressed: () =>
                      context.read<AuthBloc>().add(FacebookSignInRequested())),
            ],
          ),
        ),
      );
    });
  }

  void _handleErrorState(BuildContext context, AuthErrorState state) {
    getIt<AlertService>().showMessage(context, state.error, MessageType.error);
  }

  void _handleEmailNotVerifiedState(BuildContext context) {
    getIt<DialogManager>().showAppDialog(
      context,
      "Email Verification Required",
      "Please verify your email to continue. Check your inbox for the verification email.",
      DialogType.info,
      secondaryButtonText: 'Resend Email',
      onSecondaryPressed: () {
        context
            .read<AuthBloc>()
            .add(ResendVerificationEmail(displayMessage: true));
      },
    );
  }

  void _handleEmailResendSuccessState(BuildContext context) {
    getIt<AlertService>()
        .showMessage(context, 'E-mail successfully sent', MessageType.success);
  }
}
