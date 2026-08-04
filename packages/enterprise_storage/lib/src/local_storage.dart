/// Abstract interface for local storage implementations
///
/// This interface defines the contract that all storage implementations
/// must follow, allowing for interchangeable storage backends
/// (SharedPreferences, SecureStorage, Hive, etc.)
abstract class LocalStorage {
  /// Initialize the storage backend
  Future<void> initialize();

  /// Check if storage is initialized
  bool get isInitialized;

  /// Write a value to storage
  ///
  /// [key] - The key to store the value under
  /// [value] - The value to store (should be JSON-serializable)
  /// [boxName] - Optional box/table name for databases that support multiple containers
  Future<void> write(String key, dynamic value, {String? boxName});

  /// Read a value from storage
  ///
  /// [key] - The key to read
  /// [boxName] - Optional box/table name
  /// Returns the value cast to type T, or null if not found
  Future<T?> read<T>(String key, {String? boxName});

  /// Delete a value from storage
  ///
  /// [key] - The key to delete
  /// [boxName] - Optional box/table name
  Future<void> delete(String key, {String? boxName});

  /// Clear all values from storage
  ///
  /// [boxName] - Optional box/table name to clear specific container
  Future<void> clear({String? boxName});

  /// Check if a key exists in storage
  ///
  /// [key] - The key to check
  /// [boxName] - Optional box/table name
  Future<bool> contains(String key, {String? boxName});

  /// Get all key-value pairs from storage
  ///
  /// [boxName] - Optional box/table name
  Future<Map<String, dynamic>> getAll({String? boxName});

  /// Close the storage connection and release resources
  Future<void> close();
}
