import 'dart:convert';

import 'package:client_app_example/core/constants/di_constants.dart';
import 'package:client_app_example/core/constants/storage_constants.dart';
import 'package:client_app_example/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:client_app_example/features/auth/data/models/auth_tokens_model.dart';
import 'package:client_app_example/features/auth/data/models/user_model.dart';
import 'package:enterprise_storage/enterprise_storage.dart';
import 'package:injectable/injectable.dart';

/// The implementation of the [AuthLocalDataSource].
@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  /// Creates a new [AuthLocalDataSourceImpl] instance.
  AuthLocalDataSourceImpl(
    @Named(DiConstants.secureStorage) this._secureStorage,
  );

  final LocalStorage _secureStorage;

  @override
  Future<void> cacheTokens(AuthTokensModel tokens) async {
    await _secureStorage.write(
      StorageConstants.accessToken,
      tokens.accessToken,
    );
    await _secureStorage.write(
      StorageConstants.refreshToken,
      tokens.refreshToken,
    );
    await _secureStorage.write(
      StorageConstants.tokenExpiresAt,
      tokens.expiresAt.toIso8601String(),
    );
    await _secureStorage.write(
      StorageConstants.tokensKey,
      jsonEncode(tokens.toJson()),
    );
  }

  @override
  Future<AuthTokensModel?> getCachedTokens() async {
    final raw = await _secureStorage.read<String>(StorageConstants.tokensKey);
    if (raw == null || raw.isEmpty) {
      // Fallback to individual keys if bundle missing
      final accessToken = await _secureStorage.read<String>(StorageConstants.accessToken);
      final refreshToken = await _secureStorage.read<String>(StorageConstants.refreshToken);
      final expiresAt = await _secureStorage.read<String>(StorageConstants.tokenExpiresAt);
      if (accessToken == null || refreshToken == null || expiresAt == null) {
        return null;
      }
      return AuthTokensModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: DateTime.parse(expiresAt),
        );
    } 
    return AuthTokensModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> clearCachedTokens() async {
    await _secureStorage.delete(StorageConstants.accessToken);
    await _secureStorage.delete(StorageConstants.refreshToken);
    await _secureStorage.delete(StorageConstants.tokenExpiresAt);
    await _secureStorage.delete(StorageConstants.tokensKey);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await _secureStorage.write(
      StorageConstants.userKey,
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final raw = await _secureStorage.read<String>(StorageConstants.userKey);
    if (raw == null || raw.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> clearCachedUser() async {
    await _secureStorage.delete(StorageConstants.userKey);
  }

  @override
  Future<void> clearSession() async {
    await clearCachedTokens();
    await clearCachedUser();  
    await _secureStorage.delete(StorageConstants.sessionActive);
  }
}
