import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// File-system helpers for storage / cache layers.
class FileHelper {
  FileHelper._();

  /// Formats [bytes] as a human-readable size string (B, KB, MB, or GB).
  static String formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Returns the final path component of [path].
  static String basename(String path) => p.basename(path);

  /// Returns the file extension of [path] without a leading dot.
  static String extensionOf(String path) {
    final ext = p.extension(path);
    return ext.startsWith('.') ? ext.substring(1) : ext;
  }

  /// Returns the app documents directory.
  static Future<Directory> documentsDir() => getApplicationDocumentsDirectory();

  /// Returns the system temporary directory.
  static Future<Directory> tempDir() => getTemporaryDirectory();

  /// Ensures [path] exists as a directory, creating it if needed.
  static Directory ensureDir(String path) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  /// Deletes the file or directory at [path] if it exists.
  ///
  /// Returns `true` if something was deleted, otherwise `false`.
  static bool deleteIfExists(String path) {
    final type = FileSystemEntity.typeSync(path);
    if (type == FileSystemEntityType.notFound) return false;

    if (type == FileSystemEntityType.directory) {
      Directory(path).deleteSync(recursive: true);
    } else {
      File(path).deleteSync();
    }
    return true;
  }

  /// Creates a unique temp [File] path under the system temp directory.
  static Future<File> tempFile({String prefix = 'tmp', String? suffix}) async {
    final dir = await tempDir();
    final name =
        '${prefix}_${DateTime.now().millisecondsSinceEpoch}${suffix ?? ''}';
    return File(p.join(dir.path, name));
  }
}
