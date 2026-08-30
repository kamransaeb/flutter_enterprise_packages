import 'package:enterprise_network/enterprise_network.dart';

/// Auth HTTP paths (relative to [NetworkClientConfig.baseUrl]).
abstract final class AuthEndpoints {
  /// Login endpoint  
  static const String login = '/auth/login';
  /// Logout endpoint
  static const String logout = '/auth/logout';
  /// Refresh token endpoint
  static const String refreshToken = '/auth/refresh-token';
  /// Current user endpoint
  static const String currentUser = '/auth/current-user';
}
