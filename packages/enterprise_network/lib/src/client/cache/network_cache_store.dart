/// App-supplied GET response cache (Hive, memory, …).
abstract class NetworkCacheStore {
  /// Reads a value from the cache
  Future<String?> read(String key);

  /// Writes a value to the cache
  Future<void> write(String key, String value, {Duration? ttl});

  /// Deletes a value from the cache
  Future<void> delete(String key);
}
