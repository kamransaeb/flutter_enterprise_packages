/// Immutable token bundle.
class AuthTokens {
  /// Creates a new [AuthTokens] instance.
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  /// The access token.
  final String accessToken;

  /// The refresh token.
  final String refreshToken;

  /// The expiration date of the tokens.
  final DateTime expiresAt;

  /// Whether the tokens are expired.
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
