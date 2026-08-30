/// Minimal user entity (product-specific fields live here).
class AuthUser {
  /// Creates a new [AuthUser] instance.
  const AuthUser({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.emailVerified = false,
  });

  /// The user's ID.
  final String id;

  /// The user's email.
  final String email;

  /// The user's first name.
  final String? firstName;

  /// The user's last name.
  final String? lastName;

  /// The user's avatar URL.
  final String? avatarUrl;

  /// Whether the user's email is verified.
  final bool? emailVerified;

  /// The user's display name.
  String get displayName =>
      [firstName, lastName].whereType<String>().join(' ').trim();
}
