import 'package:client_app_example/core/utils/validators/email_validator.dart';
import 'package:client_app_example/core/utils/validators/login_password_input.dart';
import 'package:client_app_example/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:client_app_example/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:enterprise_ui/enterprise_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The login form widget.
class LoginForm extends StatefulWidget {
  /// The constructor for the login form widget.
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final loading = authState.isLoading;

            return Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    errorText:
                        loginState.showErrors || loginState.email.isNotValid
                        ? Email.getErrorMessage(loginState.email.error)
                        : null,
                  ),
                  onChanged: (value) => context.read<LoginBloc>().add(
                    LoginEvent.emailChanged(value),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    errorText:
                        loginState.showErrors || loginState.password.isNotValid
                        ? LoginPassword.getErrorMessage(
                            loginState.password.error,
                          )
                        : null,
                  ),
                  onChanged: (value) => context.read<LoginBloc>().add(
                    LoginEvent.passwordChanged(value),
                  ),
                  onFieldSubmitted: (_) => context.read<LoginBloc>().add(
                    const LoginEvent.submitted(),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Sign in',
                  expanded: true,
                  loading: loading,
                  onPressed: loading || !loginState.isValid
                      ? null
                      : () => context.read<LoginBloc>().add(
                          const LoginEvent.submitted(),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
