import 'package:client_app_example/core/constants/storage_constants.dart';
import 'package:enterprise_network/enterprise_network.dart';
import 'package:enterprise_storage/enterprise_storage.dart';

/// A network cache store that uses Hive to store cache data.
class HiveNetworkCacheStore extends NetworkCacheStore {
  /// Creates a new instance of [HiveNetworkCacheStore].
  HiveNetworkCacheStore(
    this._storage, {
    this.boxName = StorageConstants.cacheBox,
  });

  final LocalStorage _storage;

  /// The name of the Hive box to use for storing cache data.
  final String boxName;

  @override
  Future<String?> read(String key) =>
      _storage.read<String>(key, boxName: boxName);

  @override
  Future<void> write(String key, String value, {Duration? ttl}) =>
      // TTL: add later if LocalStorage supports expiry; ignore for now.
      _storage.write(key, value, boxName: boxName);

  @override
  Future<void> delete(String key) => _storage.delete(key, boxName: boxName);
}
