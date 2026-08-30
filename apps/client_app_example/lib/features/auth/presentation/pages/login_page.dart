import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:client_app_example/core/navigation/app_router.dart';
import 'package:client_app_example/core/navigation/route_guards.dart';
import 'package:client_app_example/errors/error_mapper.dart';
import 'package:client_app_example/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:client_app_example/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:client_app_example/features/auth/presentation/pages/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

/// Login screen — page-scoped [LoginBloc], session via root [AuthBloc].
@RoutePage()
class LoginPage extends StatelessWidget {
  /// Creates a [LoginPage].
  const LoginPage({super.key, this.onResult});

  /// Used by [AuthGuard] when login is pushed over a protected route.
  final void Function({bool? success})? onResult;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<LoginBloc, LoginState>(
            listenWhen: (previous, current) =>
                previous.status != current.status &&
                current.status == FormzSubmissionStatus.success,
            listener: (context, state) {
              context.read<AuthBloc>().add(
                AuthEvent.loginRequested(
                  email: state.email.value.trim(),
                  password: state.password.value,
                ),
              );
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                previous != current &&
                current.maybeWhen(
                  failure: (_) => true,
                  authenticated: (_) => true,
                  orElse: () => false,
                ),
            listener: (context, state) {
              state.maybeWhen(
                failure: (failure) {
                  // Reset submission status only — keep field text in controllers.
                  context.read<LoginBloc>().add(const LoginEvent.authFailed());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ErrorMapper.toUserMessage(failure)),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                },
                authenticated: (_) {
                  onResult?.call(success: true);
                  unawaited(context.router.replace(const PostsDemoRoute()));
                },
                orElse: () {},
              );
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please sign in to your account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 48),
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
