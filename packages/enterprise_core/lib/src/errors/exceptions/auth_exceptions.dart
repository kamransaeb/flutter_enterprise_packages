import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base authentication exception.
class AuthException extends AppException {
  /// Creates an authentication exception.
  const AuthException({
    required super.message,
    super.code,
    super.stackTrace,
    super.details,
    super.severity = ErrorSeverity.high,
  });
}

/// Invalid credentials (wrong email/password).
class InvalidCredentialsException extends AuthException {
  /// Creates an invalid-credentials exception.
  const InvalidCredentialsException({
    super.message = 'Invalid email or password.',
    super.code = 'INVALID_CREDENTIALS',
    super.stackTrace,
    super.details,
  });
}

/// Unauthorized access (session expired).
class UnauthorizedAccessException extends AuthException {
  /// Creates an unauthorized-access exception.
  const UnauthorizedAccessException({
    this.realm,
    super.message = 'Unauthorized access.',
    super.code = 'UNAUTHORIZED_ACCESS',
    super.stackTrace,
    super.details,
  });

  /// Authentication realm.
  final String? realm;
}

/// Email not verified.
class EmailNotVerifiedException extends AuthException {
  /// Creates an email-not-verified exception.
  const EmailNotVerifiedException({
    super.message = 'Please verify your email address before logging in.',
    super.code = 'EMAIL_NOT_VERIFIED',
    super.stackTrace,
    super.details,
    this.resendEmail = true,
  });

  /// Whether the user can request a new verification email.
  final bool resendEmail;
}

/// Account locked due to too many failed attempts.
class AccountLockedException extends AuthException {
  /// Creates an account-locked exception with [remainingTime] until unlock.
  AccountLockedException({
    required this.remainingTime,
    String message =
        'Account temporarily locked due to too many failed attempts.',
    super.code = 'ACCOUNT_LOCKED',
    super.stackTrace,
    super.details,
  }) : super(
          message: '$message Try again in ${remainingTime.inMinutes} minutes.',
        );

  /// Time remaining until account is unlocked.
  final Duration remainingTime;
}

/// Account disabled by admin.
class AccountDisabledException extends AuthException {
  /// Creates an account-disabled exception.
  const AccountDisabledException({
    super.message =
        'Your account has been disabled. Please contact support.',
    super.code = 'ACCOUNT_DISABLED',
    super.stackTrace,
    super.details,
  });
}

/// Refresh token expired.
class RefreshTokenExpiredException extends AuthException {
  /// Creates a refresh-token-expired exception.
  const RefreshTokenExpiredException({
    super.message = 'Session expired. Please login again.',
    super.code = 'REFRESH_TOKEN_EXPIRED',
    super.stackTrace,
    super.details,
  });
}

/// Social login failed.
class SocialLoginException extends AuthException {
  /// Creates a social-login failure for [provider].
  SocialLoginException({
    required String provider,
    String message = 'Social login failed.',
    super.code = 'SOCIAL_LOGIN_FAILED',
    super.stackTrace,
    Map<String, dynamic>? details,
  }) : super(
          message: '$message Provider: $provider',
          details: {'provider': provider, ...?details},
        );
}

/// Two-factor authentication required.
class TwoFactorRequiredException extends AuthException {
  /// Creates a 2FA-required exception with [twoFactorToken].
  const TwoFactorRequiredException({
    required this.twoFactorToken,
    super.message = 'Two-factor authentication required.',
    super.code = '2FA_REQUIRED',
    super.stackTrace,
    super.details,
  });

  /// Token for 2FA verification.
  final String twoFactorToken;
}

/// Two-factor authentication failed.
class TwoFactorFailedException extends AuthException {
  /// Creates a 2FA-failed exception.
  const TwoFactorFailedException({
    super.message = 'Invalid verification code.',
    super.code = '2FA_FAILED',
    super.stackTrace,
    super.details,
  });
}

/// Password reset token expired.
class PasswordResetTokenExpiredException extends AuthException {
  /// Creates a password-reset-token-expired exception.
  const PasswordResetTokenExpiredException({
    super.message =
        'Password reset link has expired. Please request a new one.',
    super.code = 'PASSWORD_RESET_EXPIRED',
    super.stackTrace,
    super.details,
  });
}
