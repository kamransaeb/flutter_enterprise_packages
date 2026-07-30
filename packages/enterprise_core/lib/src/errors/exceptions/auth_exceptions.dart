import 'package:enterprise_core/src/errors/exceptions/app_exception.dart';

/// Base authentication exception
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.stackTrace,
    super.details,
    super.severity = ErrorSeverity.high,
  });
}

/// Invalid credentials (wrong email/password)
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException({
    String message = 'Invalid email or password.',
    super.code = 'INVALID_CREDENTIALS',
    super.stackTrace,
    super.details,
  }) : super(message: message);
}

/// Unauthorized access (session expired)
class UnauthorizedAccessException extends AuthException {
  const UnauthorizedAccessException({
    this.realm,
    String message = 'Unauthorized access.',
    super.code = 'UNAUTHORIZED_ACCESS',
    super.stackTrace,
    super.details,
  }) : super(message: message);

  /// Authentication realm
  final String? realm;
}

/// Email not verified
class EmailNotVerifiedException extends AuthException {
  const EmailNotVerifiedException({
    String message = 'Please verify your email address before logging in.',
    super.code = 'EMAIL_NOT_VERIFIED',
    super.stackTrace,
    super.details,
    this.resendEmail = true,
  }) : super(message: message);

  /// Whether the user can request a new verification email
  final bool resendEmail;
}

/// Account locked due to too many failed attempts
class AccountLockedException extends AuthException {
  AccountLockedException({
    required this.remainingTime,
    String message = 'Account temporarily locked due to too many failed attempts.',
    super.code = 'ACCOUNT_LOCKED',
    super.stackTrace,
    super.details,
  }) : super(
          message: '$message Try again in ${remainingTime.inMinutes} minutes.',
        );

  /// Time remaining until account is unlocked
  final Duration remainingTime;
}

/// Account disabled by admin
class AccountDisabledException extends AuthException {
  const AccountDisabledException({
    String message = 'Your account has been disabled. Please contact support.',
    super.code = 'ACCOUNT_DISABLED',
    super.stackTrace,
    super.details,
  }) : super(message: message);
}

/// Refresh token expired
class RefreshTokenExpiredException extends AuthException {
  const RefreshTokenExpiredException({
    String message = 'Session expired. Please login again.',
    super.code = 'REFRESH_TOKEN_EXPIRED',
    super.stackTrace,
    super.details,
  }) : super(message: message);
}

/// Social login failed
class SocialLoginException extends AuthException {
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

/// Two-factor authentication required
class TwoFactorRequiredException extends AuthException {
  const TwoFactorRequiredException({
    required this.twoFactorToken,
    String message = 'Two-factor authentication required.',
    super.code = '2FA_REQUIRED',
    super.stackTrace,
    super.details,
  }) : super(message: message);

  /// Token for 2FA verification
  final String twoFactorToken;
}

/// Two-factor authentication failed
class TwoFactorFailedException extends AuthException {
  const TwoFactorFailedException({
    String message = 'Invalid verification code.',
    super.code = '2FA_FAILED',
    super.stackTrace,
    super.details,
  }) : super(message: message);
}

/// Password reset token expired
class PasswordResetTokenExpiredException extends AuthException {
  const PasswordResetTokenExpiredException({
    String message = 'Password reset link has expired. Please request a new one.',
    super.code = 'PASSWORD_RESET_EXPIRED',
    super.stackTrace,
    super.details,
  }) : super(message: message);
}