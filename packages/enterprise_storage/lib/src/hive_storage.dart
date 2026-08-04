import 'dart:convert';
import 'package:enterprise_logger/enterprise_logger.dart';
import 'package:enterprise_storage/enterprise_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// [LocalStorage] backed by Hive.
///
/// App supplies box names and optional adapter registration.
class HiveStorage implements LocalStorage {
  /// Creates a new [HiveStorage] instance.
  HiveStorage(
    this._logger, {
    this.defaultBoxes = const ['settings_box', 'cache_box'],
    this.defaultBoxName = 'settings_box',
    this.registerAdapters,
    this.clearOnStartup = false,
   }
  );

  /// The logger service.
  final LoggerService _logger;

  /// Boxes opened during [initialize].
  final List<String> defaultBoxes;

  /// Used when boxName is omitted.
  final String defaultBoxName;

  /// Called once before boxes open (register TypeAdapters here).
  final void Function()? registerAdapters;

  /// Whether to clear the cache on startup.
  final bool clearOnStartup;

  /// The open boxes.
  final Map<String, Box<dynamic>> _openBoxes = {};

  /// Whether the storage is initialized.
  bool _isInitialized = false;

  /// Whether the storage is initialized.
  @override
  bool get isInitialized => _isInitialized;

  /// Initialize Hive
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _logger.i('[Hive] Initializing Hive storage...');

      // Get application documents directory
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);

      // Register adapters
      registerAdapters?.call();

      // Open default boxes
      await Future.wait(defaultBoxes.map(_openBox));

      if (clearOnStartup) {
        await clear();
      }

      _isInitialized = true;
      _logger.i(
        '[Hive] Hive storage initialized with ${_openBoxes.length} boxes',
      );
    } catch (e, stack) {
      _logger.e(
        '[Hive] Failed to initialize Hive storage',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Open a Hive box
  Future<Box<dynamic>> _openBox(String name) async {
    final existingBox = _openBoxes[name];
    if (existingBox != null && existingBox.isOpen) return existingBox;
    final box = await Hive.openBox<dynamic>(
      name,
      //
      compactionStrategy: (entries, deletedEntries) {
        // Auto-compact when many entries are deleted
        return deletedEntries > 100;
      },
    );
    _openBoxes[name] = box;
    _logger.i('[Hive] Opened Hive box: $name');
    return box;
  }

  /// Opens [name] on demand if it was not in [defaultBoxes].
  Future<Box<dynamic>> ensureBox(String name) => _openBox(name);

  /// Get a box by name
  Box<dynamic> _getBox(String? boxName) {
    _ensureInitialized();
    final name = boxName ?? defaultBoxName;
    final box = _openBoxes[name];
    if (box == null || !box.isOpen) {
      throw StateError('Box $name is not open, call ensureBox first');
    }
    return box;
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('Hive storage is not initialized');
    }
  }
  //============================================================================
  // CRUD Operations
  //============================================================================

  @override
  Future<void> write(String key, dynamic value, {String? boxName}) async {
    await _getBox(boxName).put(key, value);
  }

  @override
  Future<T?> read<T>(String key, {String? boxName}) async {
    return _getBox(boxName).get(key) as T?;
  }

  @override
  Future<void> delete(String key, {String? boxName}) async {
    await _getBox(boxName).delete(key);
  }

  @override
  Future<void> clear({String? boxName}) async {
    if (boxName != null) {
      await _getBox(boxName).clear();
      _logger.i('[Hive] Cleared Hive box: $boxName');
    } else {
      // Clear all open boxes
      for (final box in _openBoxes.values) {
        if (box.isOpen) {
          await box.clear();
        }
      }
      _logger.i('[Hive] Cleared all Hive boxes');
    }
  }

  @override
  Future<bool> contains(String key, {String? boxName}) async {
    return _getBox(boxName).containsKey(key);
  }

  @override
  Future<Map<String, dynamic>> getAll({String? boxName}) async {
    return _getBox(boxName).toMap().map(
      (key, value) => MapEntry(key.toString(), value),
    );
  }

  //============================================================================
  // Batch Operations
  //============================================================================

  /// Write multiple values at once
  Future<void> writeAll(Map<String, dynamic> entries, {String? boxName}) async {
    await _getBox(boxName).putAll(entries);
  }

  /// Watch a box for changes
  Stream<BoxEvent> watchBox({String? boxName}) => _getBox(boxName).watch();

  /// Delete multiple keys at once
  Future<void> deleteAll(List<String> keys, {String? boxName}) async {
    final box = _getBox(boxName);
    await box.deleteAll(keys);
    _logger.i('[Hive] Deleted ${keys.length} entries from Hive: $boxName');
  }

  /// Get all keys in a box
  List<String> getKeys({String? boxName}) {
    return _getBox(boxName).keys.cast<String>().toList();
  }

  /// Get box length
  int getLength({String? boxName}) {
    return _getBox(boxName).length;
  }

  /// Check if box is empty
  bool isEmpty({String? boxName}) {
    return _getBox(boxName).isEmpty;
  }

  /// Check if box is not empty
  bool isNotEmpty({String? boxName}) {
    return _getBox(boxName).isNotEmpty;
  }

  /// Compact a box
  /// Hive forces a compaction of that box file on disk.
  /// - Hive marks deleted/overwritten entries as stale internally.
  /// - Compaction rewrites the box and removes that stale data.
  /// - Result: smaller file size, potentially better read/write performance.
  /// - Tradeoff: it does extra I/O work. don't call it too frequently.
  Future<void> compact({String? boxName}) async {
    await _getBox(boxName).compact();
    _logger.i(
      '[Hive] Compacted Hive box: $boxName',
    );
  }

  //============================================================================
  // JSON Serialization Helpers
  //============================================================================

  /// Write JSON object
  Future<void> writeJson(
    String key,
    Map<String, dynamic> value, {
    String? boxName,
  }) => write(key, jsonEncode(value), boxName: boxName);

  /// Read JSON object
  Future<Map<String, dynamic>?> readJson(String key, {String? boxName}) async {
    final value = await read<String>(key, boxName: boxName);
    if (value != null) {
      return jsonDecode(value) as Map<String, dynamic>;
    }
    return null;
  }

  /// Write list as JSON
  Future<void> writeJsonList(
    String key,
    List<dynamic> value, {
    String? boxName,
  }) => write(key, jsonEncode(value), boxName: boxName);

  /// Read JSON list
  Future<List<dynamic>?> readJsonList(String key, {String? boxName}) =>
      read<String>(key, boxName: boxName).then(
        (value) => value != null ? jsonDecode(value) as List<dynamic> : null,
      );

  //============================================================================
  // Box Management
  //============================================================================

  /// Close a box
  Future<void> closeBox({String? boxName}) async {
    if (boxName != null) {
      final box = _openBoxes[boxName];
      if (box != null && box.isOpen) {
        await box.close();
        _openBoxes.remove(boxName);
        _logger.i('[Hive] Closed Hive box: $boxName');
      }
    }
  }

  /// Close all boxes
  @override
  Future<void> close() async {
    for (final entry in _openBoxes.entries) {
      if (entry.value.isOpen) {
        await entry.value.close();
      }
    }
    _openBoxes.clear();
    _isInitialized = false;
    _logger.i('[Hive] Closed all Hive boxes');
  }

  /// Delete a box from disk
  Future<void> deleteBox(String boxName) async {
    if (_openBoxes.containsKey(boxName)) {
      await closeBox(boxName: boxName);
    }
    await Hive.deleteBoxFromDisk(boxName);
    _logger.i('[Hive] Deleted Hive box from disk: $boxName');
  }

  //============================================================================
  // Export/Import (for debugging)
  //============================================================================
  /// Export box data (for debugging)
  /// Export box data (for debugging)
  Map<String, dynamic> exportBox({String? boxName}) {
    return _getBox(boxName).toMap().map(
      (key, value) => MapEntry(key.toString(), value),
    );
  }

  /// Export all boxes (for debugging)
  Map<String, Map<String, dynamic>> exportAllBoxes() {
    final export = <String, Map<String, dynamic>>{};
    for (final boxName in _openBoxes.keys) {
      export[boxName] = exportBox(boxName: boxName);
    }
    return export;
  }

  /// Import data into a box (for testing)
  Future<void> importBox(String boxName, Map<String, dynamic> data) async {
    final box = _getBox(boxName);
    await box.clear();
    await box.putAll(data);
    _logger.i('[Hive] Imported ${data.length} entries into box: $boxName');
  }
}
